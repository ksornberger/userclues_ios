//
//  ExceptionHandler.h
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-22.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExceptionHandler : NSObject

+(NSArray *)backtrace;
- (void)handleException:(NSException *)exception;


@end

