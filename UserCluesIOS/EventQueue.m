//
//  EventQueue.m
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-31.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import "EventQueue.h"

@implementation EventQueue

#pragma mark Memory Management
- (id)init {
    return [self initWithSessionId: -1];
}

-(id)initWithSessionId:(NSInteger)sessionId{
    if (self = [super init]) {
        queue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [queue release];
    [super dealloc];
}

#pragma mark -
#pragma mark Queue Functions
-(void)add:(Event *)event{
    [queue addObject:event];
}

-(void)flush{
    
}

-(NSInteger)count{
    return [queue count];
}

-(NSMutableArray *)data{
    return queue;
}


@end
