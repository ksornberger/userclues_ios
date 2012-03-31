//
//  EventQueue.h
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-31.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

@interface EventQueue : NSObject{
    NSMutableArray *queue;
}

-(void)add:(Event *)event;
-(void)flush;

@end
