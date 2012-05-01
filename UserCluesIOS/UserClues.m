//
//  UserCluesIOS.m
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-19.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import "UserClues.h"
#import "UserClues+Private.h"
#import "Session.h"
#import "EventQueue.h"
#import "Routes.h"
#import "ExceptionHandler.h"
#import "Session.h"
#import "API.h"
#import "UCIdentifier.h"

NSString* const userCluesVersionNum = @"0.1";

//@property (nonatomic, retain) Session *curSession;


@implementation UserClues
Session *curSession;

static UserClues *uc = nil;
ExceptionHandler *exceptionHandler = nil;
EventQueue *queue;


//@synthesize curSession;

@synthesize queue;
@synthesize ucApiKey;
@synthesize appVersionNumber;




+ (void)installUncaughtExceptionHandler
{
	InstallUncaughtExceptionHandler();
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        curSession = nil;
    }
    
    return self;
}

#pragma mark -
#pragma mark Session Data

+(UserClues *)start:(NSString *)apiKey{
    if (nil == uc){
        uc = [[UserClues alloc] init];
        
        uc.ucApiKey = apiKey;
        
        //set default version number
        uc.appVersionNumber = @"0";
        
        curSession =  [[Session alloc] initWithAPIKeyAndVersion:uc.ucApiKey appVersion:uc.appVersionNumber];
        curSession.delegate = uc;

        
        //uc.curSession = [[Session alloc] initWithAPIKeyAndVersion:apiKey appVersion:appVersionNumber];
        //uc.curSession.delegate = uc;
        [[uc getSession] create];

        
        // Initialize the event queue for this session
        uc.queue = [[EventQueue alloc] initWithSessionId:[uc getSession].sessionId];
        uc.queue.isRecording = kUCIsRecording;
        uc.queue.apiKey = apiKey;
        
        //Configure app delegates
        if (&UIApplicationDidEnterBackgroundNotification != NULL){
        [[NSNotificationCenter defaultCenter] addObserver:uc 
                                                 selector:@selector(didEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        }
    
        
        
        //Log a session_start event
        [UserClues createEvent:@"session_start"];
        
        //Identify the device and record it as a magic event
        [uc identifyDevice];
        
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
    [[uc getSession] end];
    [uc release];
    uc = nil;
}

+(void)endInBackground{
    [UserClues log:@"Ending session due to application entering background"];
    [UserClues flush];
    [[uc getSession] endInBackground];
    [uc release];
    uc = nil;
}


+(void)identifyUser:(NSString *)identifier{
    [UserClues log:[NSString stringWithFormat:@"Identifying User: %@", identifier]];
    [UserClues createEvent:@"identify_user" withData:[NSDictionary dictionaryWithObjectsAndKeys:identifier, @"user_id", nil]];
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
    [uc.queue flush];
    /*
    if ([uc.queue count] >0 && uc.curSession.sessionId > 0 && kUCIsRecording){
        [UserClues log:@"Flushing the Event Queue"];
        //TODO: Lock the event queue here?        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:[uc.queue data], @"events", [NSNumber numberWithInt:uc.curSession.sessionId], @"session_id", nil];
        API *req = [[API alloc] initWithAPIKeyAndVersion:apiKey ucVersion:userCluesVersionNum]; //TODO is this version number needed or even incorrect?
        [req sendRequestAsync:[Routes eventCreate] requestMethod:@"POST" delegate:uc.queue data:data];
        [data release];

    }
     */
}

+(void)setAppVersionNumber:(NSString *)versionNumber{
    uc.appVersionNumber = versionNumber;
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
    [curSession release];
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

-(void)setSessionId:(NSInteger)newSessionId{
    [self.queue setSessionId:newSessionId];
}

-(void)identifyDevice{
    UCIdentifier *uid = [[UCIdentifier alloc] init];
    NSString *idString = [[NSString alloc] initWithString:[uid getIdentifier]];
    [UserClues log:[NSString stringWithFormat:@"Device Id: %@", idString]];
    [UserClues createEvent:@"identify_device" withData:[NSDictionary dictionaryWithObjectsAndKeys:idString, @"device_id", @"ODIN1", @"device_id_type", nil]];
    [uid release];
    [idString release];
}


#pragma mark -
#pragma mark Delegates
-(void)didEnterBackground:(UIApplication *)application {
    [UserClues log:@"Did enter background"];
    [UserClues endInBackground];

}

-(Session *)getSession{
    return curSession;
}



@end

void uncaughtExceptionHandler(NSException *exception) {
    [UserClues log:@"Exception Caught"];
}
