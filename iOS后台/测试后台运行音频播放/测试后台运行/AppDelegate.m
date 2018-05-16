//
//  AppDelegate.m
//  测试后台运行
//
//  Created by water on 2018/5/14.
//  Copyright © 2018年 water. All rights reserved.
//

#import "AppDelegate.h"
#import "NSString+HH.h"
#import "BackGroundManager.h"
@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [BackGroundManager shareManager];
    return YES;
}
- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}


@end
