//
//  AppDelegate.m
//  baisibudeijie
//
//  Created by dzy on 15/12/31.
//  Copyright © 2015年 董震宇. All rights reserved.
//

#import "AppDelegate.h"
#import "DZYTabBarViewController.h"
#import "DZYAdViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

// 广告界面:什么时候进入广告,程序每次运行就会进入广告
// 实现方式:把一个广告view添加到窗口上,只不过这个广告界面根启动图片相似(假象 误以为是启动图片)
// 广告界面不是启动图,启动界面不能处理业务逻辑

// 程序启动完成就会调用该方法
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 设置根控制器,进入广告界面
//    DZYTabBarViewController *tabBarVc = [[DZYTabBarViewController alloc] init];
    DZYAdViewController *adVc = [[DZYAdViewController alloc] init];
    
    self.window.rootViewController = adVc;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
