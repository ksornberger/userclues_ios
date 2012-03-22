//
//  ExceptionHandler.m
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-22.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

// Reference: Much of this code is based off a blog post and example code by Matt Gallagher
// http://cocoawithlove.com/2010/05/handling-unhandled-exceptions-and.html

#import "ExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>


void InstallUncaughtExceptionHandler();
void HandleException(NSException *exception);
void SignalHandler(int signal);


NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

@implementation ExceptionHandler



#pragma mark - 
#pragma mark Memory Management
- (id)init
{
    self = [super init];
    if (self) {
        InstallUncaughtExceptionHandler();
    }
    
    return self;
}

-(void)dealloc
{
    //Restore defaults for certain signals
    signal(SIGABRT, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    
    NSSetUncaughtExceptionHandler(NULL);
    
    [super dealloc];
}

#pragma mark -
#pragma mark C Functions

void InstallUncaughtExceptionHandler(){
    NSSetUncaughtExceptionHandler(&HandleException);
    signal(SIGABRT, SignalHandler);
	signal(SIGILL, SignalHandler);
	signal(SIGSEGV, SignalHandler);
	signal(SIGFPE, SignalHandler);
	signal(SIGBUS, SignalHandler);
	signal(SIGPIPE, SignalHandler);
}



void HandleException(NSException *exception){
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
	if (exceptionCount > UncaughtExceptionMaximum){
		return;
	}
	
	NSArray *callStack = [ExceptionHandler backtrace];
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
	[userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
	
	[[[[ExceptionHandler alloc] init] autorelease]
        performSelectorOnMainThread:@selector(handleException:)
        withObject: [NSException exceptionWithName:[exception name]
                                            reason:[exception reason]
                                          userInfo:userInfo]
        waitUntilDone:YES];
}


void SignalHandler(int signal)
{
	int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
	if (exceptionCount > UncaughtExceptionMaximum){
		return;
	}
	
	NSMutableDictionary *userInfo =[NSMutableDictionary
                                    dictionaryWithObject:[NSNumber numberWithInt:signal]
                                    forKey:UncaughtExceptionHandlerSignalKey];
    
	NSArray *callStack = [ExceptionHandler backtrace];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
	
	[[[[ExceptionHandler alloc] init] autorelease]
        performSelectorOnMainThread:@selector(handleException:)
        withObject:[NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
                                           reason: [NSString stringWithFormat:
                                                    NSLocalizedString(@"Signal %d was raised.", nil), signal]
                                         userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:signal]
                                                                               forKey:UncaughtExceptionHandlerSignalKey]]
        waitUntilDone:YES];
}

#pragma mark -
#pragma mark Core
+(NSArray *)backtrace{
    //TODO: Verify that this gives a useful backtrace
    void* callstack[128];
    const int numFrames = backtrace(callstack, 128);
    char **symbols = backtrace_symbols(callstack, numFrames);
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:numFrames];
    for (int i = 0; i < numFrames; ++i) 
    {
        [arr addObject:[NSString stringWithUTF8String:symbols[i]]];
    }
    
    free(symbols);
    
    return arr;
}



- (void)handleException:(NSException *)exception
{
    // If the app has any critical data that needs to be saved, do it here.
    NSLog(@"Unhandled Exception Caught By UserClues.\n\n%@\n%@", [exception reason], [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]);
    //TODO: Now send this to the UC Servers in the run loop
    bool dismissed = NO;
	
	CFRunLoopRef runLoop = CFRunLoopGetCurrent();
	CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
	
	while (!dismissed)
	{
		for (NSString *mode in (NSArray *)allModes)
		{
			CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
		}
	}
	
	CFRelease(allModes);

	
	if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName]){
		kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
	}
	else{
		[exception raise];
	}
}

@end
