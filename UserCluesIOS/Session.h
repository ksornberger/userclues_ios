//
//  Session.h
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-28.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "API.h"
#import "SBJSON.h"

@interface Session : NSObject <UCAPIRequest>{
    NSInteger sessionId;
    id delegate;
    @private
    API *req;
    NSString *version;
}

@property (nonatomic) NSInteger sessionId;
@property (nonatomic, retain) id delegate;


-(id)initWithAPIKeyAndVersion:(NSString *)apikey;
-(void)create;
-(void)end;
-(void)endInBackground;
-(void)update:(NSDictionary *)data;

-(void) didReceiveResponse:(NSString *)response responseCode:(NSInteger)code;

@end
