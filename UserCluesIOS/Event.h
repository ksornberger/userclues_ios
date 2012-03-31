//
//  Event.h
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-30.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject{
    BOOL isException;
    NSDate *loggedAt;
    NSString *featureName;
    NSInteger value;
    NSDictionary *data;
}

@property (nonatomic) BOOL isException;
@property (nonatomic, retain) NSDate *loggedAt;
@property (nonatomic, retain) NSString *featureName;
@property (nonatomic) NSInteger value;
@property (nonatomic, retain) NSDictionary *data;


-(id)initWithNameAndData:(NSString *)name eventData:(NSDictionary *)data;
-(void)setDefaults;


@end
