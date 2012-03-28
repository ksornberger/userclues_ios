//
//  Routes.h
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-19.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Routes : NSObject

+(NSString *)sessionCreate;
+(NSString *)sessionDestroy;
+(NSString *)sessionUpdate;
+(NSString *)eventCreate;
+(NSString *)clientDiagnosticReportCreate;
+(NSString *)host;

@end
