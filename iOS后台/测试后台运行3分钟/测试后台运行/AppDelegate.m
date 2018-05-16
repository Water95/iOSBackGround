//
//  AppDelegate.m
//  测试后台运行
//
//  Created by water on 2018/5/14.
//  Copyright © 2018年 water. All rights reserved.
//

#import "AppDelegate.h"
#import "NSString+HH.h"
@interface AppDelegate ()

@property (nonatomic,assign) UIBackgroundTaskIdentifier backIde;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    [self beginTask];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self invalidBackGround];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (void)invalidBackGround{
    if (self.backIde != UIBackgroundTaskInvalid ) {
        [[UIApplication sharedApplication] endBackgroundTask:self.backIde];
        self.backIde = UIBackgroundTaskInvalid;
    }
}

- (void)beginTask{
    _backIde  = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSString getCurrentTime] writeToFile:[NSString libraryAppendPath:@"temptwo"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
        });
    }];
}

@end
