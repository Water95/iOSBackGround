# iOSBackGround

[Githup项目地址](https://github.com/Water95/iOSBackGround/tree/master/iOS后台)
[简书地址](https://www.jianshu.com/p/2ef9b2a223d4)

### 一 iOS 应用的运行状态

Not running  应用还没有启动或者应用正在运行但是途中被系统停止

Inactive     当前应用正在前台运行，但是并不接收事件。应用要从一个状态切换到另一个不同的状态时，中途过渡会短暂停留在此状态。

Active     当前应用正在前台运行，并且接收事件。这是应用正在前台运行时所处的正常状态

Suspended 应用处在后台，并且已经停止执行带。

Background  应用处在后台，并且还在执行代码。如果代码不做任何事情，应用程序不会停留在这个阶段。

###二 设置UIBackgroundTaskIdentifier，会让程序在后台执行3分钟的时间。满足两个条件，让你的应用有3分钟的时间在后台执行代码

* 用户点击home，没有双击home，移除应用程序
* AppDelegate.h中的代码



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

为了验证每隔一秒输入当前的时间的文件，看看在何时停止的。经测试 >= 180秒，至少有3分钟的后台时间去做一些事情


这种申请后台任务的，不存在任何的风险，3分钟够用了，如果是下载大文件的，显然不够用了。



# 三 公司App 有播放音视频功能，所以注册音视频的方法保证后台运行。思路是如果需要开启后台任务，就播放音乐，结束后，就停止。具体代码在项目地址中测试后台运行音频播放






