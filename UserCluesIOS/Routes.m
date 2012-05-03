//
//  Routes.m
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-19.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import "Routes.h"

@implementation Routes

//NOTE: Make sure the host matches the host in rootUrl before
//Other Note: (Yes, I know this can be done so that the host is only written once, but for right now, this is how I'm doing it.)
//TODO: Elimiate redundency below.
//#ifdef DEBUG
    static NSString *rootUrl = @"http://api.lvh.me:3000/";
    static NSString *host = @"lvh.me";
//#else
 
//static NSString *rootUrl = @"https://api.userclues.com/";
//static NSString *host = @"userclues.com";
//#endif



+(NSString *)sessionCreate{
    return [rootUrl stringByAppendingString:@"raw/sessions"];
}

+(NSString *)sessionDestroy{
    return [rootUrl stringByAppendingString:@"raw/sessions/:id"];
}

+(NSString *)sessionUpdate{
    return [rootUrl stringByAppendingString:@"raw/sessions/:id"];
}

+(NSString *)eventCreate{
    return [rootUrl stringByAppendingString:@"raw/events"];
}

+(NSString *)clientDiagnosticReportCreate{
    return [rootUrl stringByAppendingString:@"raw/diagnostics"];
}

+(NSString *)host{
    return host;
}
@end
