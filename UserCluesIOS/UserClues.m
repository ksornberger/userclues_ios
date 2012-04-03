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

//#define USER_CLUES_VERSION_NUM @"1.0"
NSString *userCluesVersionNum = @"1.0";


@implementation UserClues

static UserClues *uc = nil;
ExceptionHandler *exceptionHandler = nil;

@synthesize curSession;
@synthesize queue;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


+(UserClues *)start{
    if (nil == uc){
        uc = [[UserClues alloc] init];
        
        uc.curSession = [[Session alloc] initWithAPIKeyAndVersion:apiKey appVersion:userCluesVersionNum];
        [uc.curSession create];
        
        // Initialize the event queue for this session
        uc.queue = [[EventQueue alloc] initWithSessionId:uc.curSession.sessionId];
        
        //Set up global exception handling?
        if (kUCHandleExceptions){
            if (!exceptionHandler)
                exceptionHandler = [[ExceptionHandler alloc] init];
        }
    }
    return uc;
}

-(void)flush{
    //TODO: Lock the flush operation here?
    if ([self.queue count] >0 && self.curSession.sessionId > 0 && kUCIsRecording){
        //TODO: Lock the event queue here?
        [queue flush:self.curSession];
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:[self.queue data], @"events", self.curSession, @"session", nil];
        API *req = [[API alloc] initWithAPIKeyAndVersion:apiKey ucVersion:userCluesVersionNum];
        [req sendRequestAsync:[Routes eventCreate] requestMethod:@"POST" delegate:queue data:data];
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
    [exceptionHandler release];
    [super dealloc];
}






@end
