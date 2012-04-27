//
//  Session.m
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-28.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import "Session.h"

NSString* const IsFirstLaunchKey = @"IsFirstLaunchKey";

@interface Session(){
}
@property (nonatomic, retain) API *req;
@property (nonatomic, retain) NSString * version;
@end

@implementation Session

@synthesize req;
@synthesize version;
@synthesize sessionId;
@synthesize delegate;


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
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL isFirstLaunch = [prefs boolForKey:IsFirstLaunchKey];
    //Change the value if this is infact the first launch
    if (isFirstLaunch)
        [prefs setBool:NO forKey:IsFirstLaunchKey];
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys: self.version, @"version_name", [NSNumber numberWithBool:isFirstLaunch], @"first_launch", [NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]], @"logged_at", nil];
    [self.req sendRequestAsync:[Routes sessionCreate] requestMethod:@"POST" delegate:self data:data];
    [data release];
}


-(void)end{
    [self.req sendRequestAsync:[[Routes sessionDestroy] stringByReplacingOccurrencesOfString:@":id" withString:[NSString stringWithFormat:@"%d", self.sessionId]] requestMethod:@"DELETE" delegate:self data:nil];
}

-(void)endInBackground{
    [self.req sendRequestAsync:[[Routes sessionDestroy] stringByReplacingOccurrencesOfString:@":id" withString:[NSString stringWithFormat:@"%d", self.sessionId]] requestMethod:@"DELETE" delegate:self data:[[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"didEnterBackground", nil]];
}

-(void)update:(NSDictionary *)data{
    if (self.sessionId > 0){
        [self.req sendRequestAsync:[[Routes sessionUpdate] stringByReplacingOccurrencesOfString:@":id" withString:[NSString stringWithFormat:@"%d", self.sessionId]] requestMethod:@"PUT" delegate:self data:data];
    }else{
        NSLog(@"Session Update Aborted: Session updated called without session ID available");
    }
    
}


#pragma mark -
-(void) didReceiveResponse:(NSString *)response responseCode:(NSInteger)code{
    if (200 == code){
        NSDictionary *responseDict = [response JSONValue];
        self.sessionId = [[responseDict objectForKey:@"session_id"] integerValue];
        NSLog(@"Session ID: %@", [responseDict objectForKey:@"session_id"]);
        NSLog(@"Session ID Stored: %d", self.sessionId);
        
        if (delegate)
            [delegate setSessionId:self.sessionId];
        
    }
    
}


@end
