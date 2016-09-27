//
//  AppDelegate.m
//  FlyppGame
//
//  Created by dingjianjaja on 16/6/1.
//  Copyright © 2016年 dingjian. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (nonatomic, retain)NSDate *date;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // dingjian
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    self.date = [NSDate date];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"退出时间：%@   现在时间：%@   时间间隔：%.0f",self.date,[NSDate date],[[NSDate date] timeIntervalSinceDate:self.date]);
    
    if (self.date) {
        if ([[NSDate date] timeIntervalSinceDate:self.date] > 60 * 60 * 24) {
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController * vc = [board instantiateViewControllerWithIdentifier:@"gameVC"];
            [window setRootViewController:vc];
            window.backgroundColor = [UIColor whiteColor];
            [window makeKeyAndVisible];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
