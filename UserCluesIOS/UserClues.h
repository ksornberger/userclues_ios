//
//  UserCluesIOS.h
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-19.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Session.h"
#import "EventQueue.h"


// Custom configuration flags
#define kUCDebugLogging YES

// Flag to determine whether or not UserClues will register a global exception handler to report unhandled exceptions
// and debug information to the server for later analysis.
#define kUCHandleExceptions NO

NSString *apiKey = @"5d3ac439306a4a5c987ce9afc41c76e8";

// Flag to determine whether the application should be logging events to the UC Server (default is true)
#define kUCIsRecording YES


@interface UserClues : NSObject {
    Session *curSession;
    @private
    EventQueue *queue;
}


@property (nonatomic, retain) Session *curSession;

/*
 * Returns the singleton istance of the UserClues reporting object. Will also start the necessary session related 
 * data if a session has not already been initialized.
 */
+(UserClues *)start;
+(void)end;
+(void)log:(NSString *)msg;


/*
 Record events or errors after a session has been started
 */
+(void)createEvent:(NSString *)eventName;
+(void)createEvent:(NSString *)eventName withData:(NSDictionary *)data;
+(void)flush;

/*
 Additional and optional information to record
 */
+(void)identifyUser:(NSString *)identifier;



@end
