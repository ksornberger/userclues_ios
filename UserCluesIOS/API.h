//
//  API.h
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-19.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Routes.h"
#import "SBJSON.h"
#import "UCResponse.h"

@protocol UCAPIRequest
-(void) didReceiveResponse:(NSString *)response responseCode:(NSInteger)code;
@end

@interface API : NSObject{
    UCResponse *response;
    @private
    NSString *apiKey;
    NSString *version;
}

@property (nonatomic, retain) UCResponse *response;

//+(API *)instance;
-(id)initWithAPIKeyAndVersion:(NSString *)apikey ucVersion:(NSString *)ver;

//-(void)sessionCreate:(NSString *)apikey ucVersion:(NSString *)version;
-(void)sessionCreate;
-(void)sendRequest:(NSString *)url requestMethod:(NSString *)method delegate:(id)delegate data:(NSDictionary *)data;
-(void)sendRequestAsync:(NSString *)url requestMethod:(NSString *)method delegate:(id)delegate data:(NSDictionary *)data;

// NSURLConnection delegate methods:
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;



@end
