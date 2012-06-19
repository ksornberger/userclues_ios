//
//  UCResponse.h
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-28.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCResponse : NSObject{
    NSInteger responseCode;
    NSString *responseBody;
}

@property (nonatomic) NSInteger responseCode;
@property (nonatomic, retain) NSString *responseBody;

@end
