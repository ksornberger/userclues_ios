//
//  API.h
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-19.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface API : NSObject

+(API *)instance;

-(void)sessionCreate:(NSString *)apikey ucVersion:(NSString *)version;
-(void)sendRequest:(NSString *)url requestMethod:(NSString *)method delegate:(id)delegate data:(NSDictionary *)data;
-(void)sendRequestAsync:(NSString *)url requestMethod:(NSString *)method delegate:(id)delegate data:(NSDictionary *)data;

@end
