//
//  API.m
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-19.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import "API.h"

@implementation API

static API *instance = nil;

+(API *)instance{
    if (!instance){
        instance = [[[API alloc] init] autorelease];
    }
    return instance;
}

-(void)sessionCreate:(NSString *)apikey ucVersion:(NSString *)version{
    //[self log:@"Starting session synchronously"];
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys: version, @"version", nil];
    
}

@end
