//
//  Session.m
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-28.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import "Session.h"

@interface Session(){
}
@property (nonatomic, retain) API *req;
@property (nonatomic, retain) NSString * version;
@end

@implementation Session

@synthesize req;
@synthesize version;
@synthesize sessionId;


#pragma mark Constructor/Destructor
-(id)initWithAPIKeyAndVersion:(NSString *)apikey appVersion:(NSString *)ver{
    self = [super init];
    if (self) {
        self.req = [[API alloc] initWithAPIKeyAndVersion:apikey ucVersion:ver];
        self.version = ver;
    }
    
    return self;
}

-(void)dealloc
{
    [self.req release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Functionality
-(void) create{
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys: self.version, @"version", nil];
    [self.req sendRequestAsync:[Routes sessionCreate] requestMethod:@"POST" delegate:self data:data];
    [data release];
}

#pragma mark -
-(void) didReceiveResponse:(NSString *)response responseCode:(NSInteger)code{
    if (200 == code){
        NSDictionary *responseDict = [response JSONValue];
        self.sessionId = [[responseDict objectForKey:@"session_id"] integerValue];
        NSLog(@"Session ID: %@", [responseDict objectForKey:@"session_id"]);
        NSLog(@"Session ID Stored: %d", self.sessionId);
        
    }
    
}


@end
