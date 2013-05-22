//
//  AppDelegate.m
//  Guess
//
//  Created by Chris on 4/28/13.
//  Copyright (c) 2013 Chris. All rights reserved.
//

#import "AppDelegate.h"
//#import "UncaughtExceptionHandler.h"

void UncaughtExceptionHandler(NSException *exception) {
	NSArray *arr = [exception callStackSymbols];
	NSString *reason = [exception reason];
	NSString *name = [exception name];
	NSLog(@"~~~###");
	NSString *urlStr = [NSString stringWithFormat:@"mailto://kirzalid@163.com?subject=bug报告&body=感谢您的配合!<br><br><br>"
						"\n错误详情:<br>%@<br>--------------------------<br>%@<br>---------------------<br>%@",
						name,reason,[arr componentsJoinedByString:@"<br>"]];
	
	NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"~~~###  %@",urlStr);
	[[UIApplication sharedApplication] openURL:url];
}
@implementation AppDelegate

//- (void)installUncaughtExceptionHandler
//{
//	InstallUncaughtExceptionHandler();
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSLog(@"here~");
//    [self installUncaughtExceptionHandler];
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
//    NSLog(@"phone number is %@",[Tools phoneNumber]);
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
