//
//  AppDelegate.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/14.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "AppDelegate.h"
#import "Heqz_DUContext.h"
#import "MultiChannelDemoViewController.h"
#import "Heqz_RubishManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [[Heqz_DUContext sharedDUContext] resetJSDataWithDirectory:[[NSBundle mainBundle] bundlePath]];
    
    // 可以在测试阶段运行所有功能，收集未使用过的垃圾资源
#if DEBUG
    Heqz_RubishManager* rubishManager = [Heqz_RubishManager sharedManager];
    rubishManager.arrayClassPreStr = @[@"DUDemo"];
    [[Heqz_RubishManager sharedManager] collectAllClassName];
    [[Heqz_RubishManager sharedManager] collectAllImageName];
    [[Heqz_RubishManager sharedManager] collectAllXibName];
#endif
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    MultiChannelDemoViewController* demoVc = [[MultiChannelDemoViewController alloc] init];
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:demoVc];
    navi.navigationBar.hidden = YES;
    self.window.rootViewController = navi;
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
