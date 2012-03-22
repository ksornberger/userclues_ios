//
//  UserCluesIOS.m
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-19.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import "UserClues.h"
#import "UserClues+Private.h"
#import "API.h"
#import "Routes.h"
#import "ExceptionHandler.h"

#define USER_CLUES_VERSION_NUM @"1.0"



@implementation UserClues

static UserClues * uc = nil;
ExceptionHandler *exceptionHandler = nil;



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
        [[API instance] sessionCreate];
        
        //Set up global exception handling?
        if (kUCHandleExceptions){
            if (!exceptionHandler)
                exceptionHandler = [[ExceptionHandler alloc] init];
        }
    }
    return uc;
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
