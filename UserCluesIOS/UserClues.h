//
//  UserCluesIOS.h
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-19.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


/**********************************************
 Configuration settings
 **********************************************/
// IMPORTANT: Enter your API Key Below:
//NSString* const UCApiKey = @"61561061dd4b41f6810cb63c983e4b1a";

// Enter the version number of your application below:
// This is important in order to separate reports by version number
//NSString* const appVersionNumber = @"1.0";

// Enable NSLog Debug messages to be displayed. Enabling this is useful for integration and debugging.
#define kUCDebugLogging YES

// Flag to determine whether or not UserClues will register a global exception handler to report unhandled exceptions
// and debug information to the server for later analysis.
#define kUCHandleExceptions YES

// Flag to determine whether the application should be logging events to the UC Server (default is true)
// You may want to set this to NO while testing your integration. Everything will function as normal but events
// will not be sent to the UserClues server.
#define kUCIsRecording YES


#define kUCAutoFlushEventCount 10



@interface UserClues : NSObject {
    NSString *ucApiKey;
    NSString *appVersionNumber;
}

@property (nonatomic, retain) NSString *ucApiKey;
@property (nonatomic, retain) NSString *appVersionNumber;

/*
 * Returns the singleton istance of the UserClues reporting object. Will also start the necessary session related 
 * data if a session has not already been initialized.
 */
+(UserClues *)start:(NSString *)apiKey;
+(void)end;
+(void)endInBackground;
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

void uncaughtExceptionHandler(NSException *exception);
