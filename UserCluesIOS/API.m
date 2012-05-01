//
//  API.m
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-19.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import "API.h"

@interface API(){
}
@property (nonatomic, retain) NSString *apiKey;
@property (nonatomic, retain) NSString *version;
@end

@implementation API

@synthesize apiKey;
@synthesize version;
@synthesize response;
@synthesize callback;

//static API *instance = nil;

NSMutableData *receivedData;
NSTimeInterval const TIMEOUT_SECONDS = 15.0;

#ifdef DEBUG
    NSString *apiProtocol = @"http";
    NSInteger apiPort = 3000;
#else
    NSString *apiProtocol = @"https";
    NSInteger apiPort = 0;
#endif

/*
#pragma mark Constructor/Destructor
+(API *)instance{
    if (nil == instance){
        instance = [[[API alloc] init] autorelease];
        
        //Setup the http authentication credentials
        NSURLCredential *credential = [NSURLCredential credentialWithUser:@"user" password:@"pass" persistence:NSURLCredentialPersistenceForSession];
        NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc]
                                                 initWithHost:[Routes host]
                                                 port:0
                                                 protocol:@"http"
                                                 realm:nil
                                                 authenticationMethod:nil];
        [[NSURLCredentialStorage sharedCredentialStorage] setDefaultCredential:credential forProtectionSpace:protectionSpace];
        [protectionSpace release];
        
    }
    return instance;
}
*/

-(id)initWithAPIKeyAndVersion:(NSString *)apikey ucVersion:(NSString *)ver{
    self = [super init];
    if (self) {
        self.apiKey = apikey;
        self.version = ver;
        self.response = [[UCResponse alloc] init];

        
/*        NSURLCredential *credential = [NSURLCredential credentialWithUser:self.apiKey password:@"" persistence:NSURLCredentialPersistenceNone];
        NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc]
                                                 initWithHost:[Routes host]
                                                 port:apiPort
                                                 protocol:apiProtocol
                                                 realm:nil
                                                 authenticationMethod:nil];
        [[NSURLCredentialStorage sharedCredentialStorage] setDefaultCredential:credential forProtectionSpace:protectionSpace];
        [protectionSpace release];
*/
    }
    
    return self;
}

-(void)dealloc
{
    [self.response release];
    
    [super dealloc];
}


#pragma mark -
//-(void)sessionCreate:(NSString *)apikey ucVersion:(NSString *)version{
/*
-(void)sessionCreate{

    //[self log:@"Starting session synchronously"];
    //self.apiKey = apiKey;
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys: self.version, @"version", nil];
    
    [self sendRequestAsync:[Routes sessionCreate] requestMethod:@"POST" delegate:self data:data];
}
*/

#pragma mark -
#pragma mark Server Requests
-(void)sendRequest:(NSString *)url requestMethod:(NSString *)method delegate:(id)delegate data:(NSDictionary *)data{
    
}

-(void)sendRequestAsync:(NSString *)url requestMethod:(NSString *)method delegate:(id)delegate data:(NSDictionary *)data{
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIMEOUT_SECONDS];
    [req setHTTPMethod:method];
    [req setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    self.callback = delegate;
    
    if (data){
        NSLog(@"Data to send: %@\n", [data JSONRepresentation]);
        const char *bytes = [[data JSONRepresentation] UTF8String];
        [req setHTTPBody:[NSData dataWithBytes:bytes length:strlen(bytes)]];
    }
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn){
        // Create the NSMutableData to hold the received data.
        receivedData = [[NSMutableData data] retain];
    }
    else{
        //TODO: Handle a failed connection here
    }
}

#pragma mark -
#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)_response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
    
    //Set the response code that we just received.
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)_response;
    self.response.responseCode = [httpResponse statusCode];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    // TODO: Call Callback when error happens.
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
    NSString *responseString  = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
    self.response.responseBody = responseString;
    NSLog(@"Received Data: %@", responseString);
    [responseString release];

    [callback didReceiveResponse:self.response.responseBody responseCode:self.response.responseCode];
    
    // release the connection, and the data object
    [connection release];
    [receivedData release];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"got auth challange");
    
    if ([challenge previousFailureCount] == 0) {
        NSLog(@"Sending API key: %@", self.apiKey);
        [[challenge sender]  useCredential:[NSURLCredential credentialWithUser:self.apiKey password:@"" persistence:NSURLCredentialPersistenceNone] forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];  
    }
}

@end
