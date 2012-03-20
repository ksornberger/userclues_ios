//
//  Routes.h
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-19.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Routes : NSObject

@property (nonatomic, readonly) NSString *sessionCreate;
@property (nonatomic, readonly) NSString *sessionDestroy;
@property (nonatomic, readonly) NSString *sessionUpdate;
@property (nonatomic, readonly) NSString *eventCreate;
@property (nonatomic, readonly) NSString *clientDiagnosticReportCreate;

@end
