//
//  Event.m
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-30.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import "Event.h"
@implementation Event

@synthesize isException;
@synthesize loggedAt;
@synthesize featureName;
@synthesize value;
@synthesize data;


#pragma mark Memory Management
- (id)init{
    return [self initWithNameAndData:@"" eventData:nil];
}

-(id)initWithNameAndData:(NSString *)name eventData:(NSDictionary *)eventData{
    self = [super init];
    if (self) {
        [self setDefaults];
        self.featureName = name;
        self.data = eventData;
    }
    
    return self;
}

-(void)setDefaults{
    self.isException = NO;
    self.loggedAt = [[NSDate date] timeIntervalSince1970];//[NSDate date];
    self.value = 1;
}


#pragma mark -
- (id)proxyForJson {
    if (self.data)
        return [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithInteger: self.value], @"value",
                [NSNumber numberWithInteger:self.loggedAt] , @"logged_at",
                self.data, @"data",
                self.featureName, @"feature_name",
                [NSNumber numberWithInteger: self.isException], @"is_exception",
                nil];
    else
        return [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithInteger: self.value], @"value",
                [NSNumber numberWithInteger: self.loggedAt] , @"logged_at",
                [[[NSDictionary alloc] init]autorelease], @"data",
                self.featureName, @"feature_name",
                [NSNumber numberWithInteger: self.isException], @"is_exception",

                nil];
}

@end
