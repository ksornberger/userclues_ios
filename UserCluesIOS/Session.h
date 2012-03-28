//
//  Session.h
//  UserCluesIOS
//
//  Created by Kevin Sornberger on 12-03-28.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "API.h"

@interface Session : NSObject <UCAPIRequest>{
    @private
    API *req;
    NSString *version;
}

-(id)initWithAPIKeyAndVersion:(NSString *)apikey appVersion:(NSString *)ver;
-(void) create;


@end
