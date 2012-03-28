//
//  UserCluesIOS.h
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-19.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "API.h"


// Custom configuration flags
#define kUCDebugLogging YES

// Flag to determine whether or not UserClues will register a global exception handler to report unhandled exceptions
// and debug information to the server for later analysis.
#define kUCHandleExceptions YES

NSString *apiKey = @"5d3ac439306a4a5c987ce9afc41c76e8";


@interface UserClues : NSObject <UCAPIRequest> {

}




/*
 * Returns the singleton istance of the UserClues reporting object. Will also start the necessary session related 
 * data if a session has not already been initialized.
 */
+(UserClues *)start;
+(void)log:(NSString *)msg;



@end
