
#import <UIKit/UIKit.h>


@interface UserClues()

@property (nonatomic, retain) EventQueue *queue;

-(void)didEnterBackground:(UIApplication *)application;
+(void)log:(NSString *)msg;

@end