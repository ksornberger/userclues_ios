//
//  EventQueue.h
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-31.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
//#import "Session.h"
#import "API.h"

@interface EventQueue : NSObject <UCAPIRequest>{
    NSMutableArray *queue;
    BOOL isRecording;
    NSInteger sessionId;
    NSString *apiKey;
    BOOL isFlushingAfterException;
    
    @private
    API *req;
}

@property (nonatomic) BOOL isRecording;
@property (nonatomic) NSInteger sessionId;
@property (nonatomic, retain) NSString *apiKey;
@property (nonatomic) BOOL isFlushingAfterException;

-(id)initWithSessionId:(NSInteger)sessionId;
-(void)add:(Event *)event;
//-(void)flush:(Session *)session;
-(NSInteger)count;
-(NSMutableArray *)data;
-(void)flush;

+(EventQueue *) getInstance;


@end
