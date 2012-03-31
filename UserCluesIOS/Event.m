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
    self. isException = false;
    self.loggedAt = [NSDate date];
    self.value = 1;
}


@end
