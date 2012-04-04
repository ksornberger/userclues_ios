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
    @private
    API *req;
    NSString *version;
}

@property (nonatomic) NSInteger sessionId;

-(id)initWithAPIKeyAndVersion:(NSString *)apikey appVersion:(NSString *)ver;
-(void) create;

-(void) didReceiveResponse:(NSString *)response responseCode:(NSInteger)code;

@end
