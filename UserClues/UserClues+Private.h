
#import <UIKit/UIKit.h>
#import "Session.h"
#import "EventQueue.h"


@interface UserClues()

@property (nonatomic, retain) EventQueue *queue;

-(void)didEnterBackground:(UIApplication *)application;
+(void)log:(NSString *)msg;
-(void)setSessionId:(NSInteger)newSessionId;
-(void)identifyDevice;
-(Session *)getSession;

@end