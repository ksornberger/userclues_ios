//
//  EventQueue.m
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-31.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//
#import "EventQueue.h"


@implementation EventQueue

static EventQueue *instance = nil;

@synthesize isRecording;
@synthesize sessionId;
@synthesize apiKey;
@synthesize isFlushingAfterException;

#pragma mark Memory Management
- (id)init {
    return [self initWithSessionId: -1];
}

-(id)initWithSessionId:(NSInteger)sessionId{
    if (self = [super init]) {
        //TODO: Session ID Isn't used here yet?
        queue = [[NSMutableArray alloc] init];
        isFlushingAfterException = NO;
        instance = self;
    }
    return self;
}

//NOTE: This is assuming that this object has already been initialized elsewhere.
+(EventQueue *) getInstance{
    return instance;
}

- (void)dealloc {
    [queue release];
    [super dealloc];
}

#pragma mark -
#pragma mark Queue Functions
-(void)add:(Event *)event{
    [queue addObject:event];
    NSLog(@"- Added event: %@", event.featureName);
}

/*
-(void)flush:(Session *)session{


     NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:queue, @"events", session, @"session", nil];

    [self.req sendRequestAsync:[Routes sessionCreate] requestMethod:@"POST" delegate:self data:data];
    [data release];
}
 */

-(NSInteger)count{
    return [queue count];
}

-(NSMutableArray *)data{
    return queue;
}

-(void)flush{
    //TODO: Lock the flush operation here?
    //if ([queue count] >0 && self.sessionId > 0 && self.isRecording){
    if ([queue count] >0 && self.isRecording){
        //TODO: Lock the event queue here?        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:queue, @"events", [NSNumber numberWithInt:self.sessionId], @"session_id", nil];
        req = [[API alloc] initWithAPIKeyAndVersion:self.apiKey ucVersion:0]; //TODO is this version number needed or even incorrect?
        [req sendRequestAsync:[Routes eventCreate] requestMethod:@"POST" delegate:self data:data];
        [data release];
        
    }
}


#pragma mark -
-(void) didReceiveResponse:(NSString *)response responseCode:(NSInteger)code{
    if (200 == code){
        NSDictionary *responseDict = [response JSONValue];
        NSInteger affected = [[responseDict objectForKey:@"affected"] integerValue];
        NSLog(@"Events recorded: %d", affected);
        if (affected > 0){
            NSLog(@"Queue Size Before Removal: %d", [queue count]);
            NSRange processed = NSMakeRange(0, affected);
            [queue removeObjectsInRange:processed];
            NSLog(@"Queue Size After Removal: %d", [queue count]);

        }
        self.isFlushingAfterException = NO;
        
    }
    
}


@end
