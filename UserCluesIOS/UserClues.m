//
//  UserCluesIOS.m
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-19.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import "UserClues.h"
#import "UserClues+Private.h"
#import "Routes.h"
#import "ExceptionHandler.h"
#import "Session.h"
#import "API.h"

NSString* const userCluesVersionNum = @"0.1";


@implementation UserClues

static UserClues *uc = nil;
ExceptionHandler *exceptionHandler = nil;

@synthesize curSession;
@synthesize queue;


+ (void)installUncaughtExceptionHandler
{
	InstallUncaughtExceptionHandler();
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

#pragma mark -
#pragma mark Session Data

+(UserClues *)start{
    if (nil == uc){
        uc = [[UserClues alloc] init];
        
        uc.curSession = [[Session alloc] initWithAPIKeyAndVersion:apiKey appVersion:appVersionNumber];
        [uc.curSession create];
        
        // Initialize the event queue for this session
        uc.queue = [[EventQueue alloc] initWithSessionId:uc.curSession.sessionId];
        
        //Configure app delegates
        if (&UIApplicationDidEnterBackgroundNotification != NULL){
        [[NSNotificationCenter defaultCenter] addObserver:uc 
                                                 selector:@selector(didEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        }
        
        //Log a session_start event
        [UserClues createEvent:@"session_start"];
        
        //Set up global exception handling?
        if (kUCHandleExceptions){
            [UserClues log:@"Enabling UserClues Uncaught Exception Handler"];
            //NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
            
            exceptionHandler = [[ExceptionHandler alloc] init];
            if (exceptionHandler){
                exceptionHandler = [[ExceptionHandler alloc] init];	
                [self performSelector:@selector(installUncaughtExceptionHandler) withObject:nil afterDelay:0];
                
            }
             
        }
    }
    return uc;
}

+(void)end{
    [UserClues flush];
    [uc.curSession end];
    [uc release];
    uc = nil;
}

+(void)endInBackground{
    [UserClues log:@"Ending session due to application entering background"];
    [UserClues flush];
    [uc.curSession endInBackground];
    [uc release];
    uc = nil;
}


+(void)identifyUser:(NSString *)identifier{
    [uc.curSession update:[[NSDictionary alloc] initWithObjectsAndKeys:identifier, @"user_identifier",nil]];
}



#pragma mark -
#pragma mark Event Management

+(void)createEvent:(NSString *)eventName{
    //TODO Warn developer that a session hasn't been started
    [UserClues log:[NSString stringWithFormat: @"Creating event with name: %@", eventName]];
    [UserClues createEvent:eventName withData:nil];

    
}
                
+(void)createEvent:(NSString *)eventName withData:(NSDictionary *)data{
    Event *e = [[Event alloc] initWithNameAndData:eventName eventData:data];
    [uc.queue add:e];
    [e release];
}


+(void)flush{
    //TODO: Lock the flush operation here?
    if ([uc.queue count] >0 && uc.curSession.sessionId > 0 && kUCIsRecording){
        [UserClues log:@"Flushing the Event Queue"];
        //TODO: Lock the event queue here?        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:[uc.queue data], @"events", [NSNumber numberWithInt:uc.curSession.sessionId], @"session_id", nil];
        API *req = [[API alloc] initWithAPIKeyAndVersion:apiKey ucVersion:userCluesVersionNum]; //TODO is this version number needed or even incorrect?
        [req sendRequestAsync:[Routes eventCreate] requestMethod:@"POST" delegate:uc.queue data:data];
        [data release];

    }
}



#pragma mark Private Functions



+(void)log:(NSString *)msg{
    //TODO: Improve the logging mechanism
    if(kUCDebugLogging){
        NSLog(@"-- UserClues: %@", msg);
    }
}


-(void)dealloc{
    [UserClues log:@"UC Dealloc called"];
    [self.queue release];
    [self.curSession release];
    if (exceptionHandler){
        [exceptionHandler release];
    }
    
    
    //Unregister custom delegates:
    if (&UIApplicationDidEnterBackgroundNotification != NULL){
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    }
    [super dealloc];
}

#pragma mark -
#pragma mark Delegates
-(void)didEnterBackground:(UIApplication *)application {
    [UserClues log:@"Did enter background"];
    [UserClues endInBackground];

}



@end

void uncaughtExceptionHandler(NSException *exception) {
    [UserClues log:@"Exception Caught"];
}
