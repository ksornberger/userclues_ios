//
//  Routes.m
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-19.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import "Routes.h"

@implementation Routes

@dynamic sessionCreate;
@dynamic sessionDestroy;
@dynamic sessionUpdate;
@dynamic eventCreate;
@dynamic clientDiagnosticReportCreate;

static NSString *rootUrl = @"https://api.userclues.com/";

-(NSString *)sessionCreate{
    return [rootUrl stringByAppendingString:@"sessions"];
}

-(NSString *)sessionDestroy{
    return [rootUrl stringByAppendingString:@"sessions/:id"];
}

-(NSString *)sessionUpdate{
    return [rootUrl stringByAppendingString:@"sessions/:id"];
}

-(NSString *)eventCreate{
    return [rootUrl stringByAppendingString:@"events"];
}

-(NSString *)clientDiagnosticReportCreate{
    return [rootUrl stringByAppendingString:@"diagnostics"];
}
@end
