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

#define USER_CLUES_VERSION_NUM @"1.0"


@implementation UserClues

static UserClues * uc = nil;


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
        [uc sessionCreate];
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


@end
