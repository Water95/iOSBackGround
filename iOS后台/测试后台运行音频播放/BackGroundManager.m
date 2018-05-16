//
//  BackGroundManager.m
//  测试后台运行
//
//  Created by water on 2018/5/15.
//  Copyright © 2018年 water. All rights reserved.
//

#import "BackGroundManager.h"

@implementation BackGroundManager
+(instancetype)shareManager{
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
- (instancetype)init{
    if (self = [super init]) {
        self.isStartBackground = YES;
        [self registerNotifications];
    }
    return self;
}
#pragma mark 注册通知
- (void)registerNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}
#pragma mark 程序进入活跃状态
- (void)applicationDidBecomeActive:(NSNotification*)notification {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self initPreventSuspending];
    });
}
#pragma mark 即将退出活跃状态
- (void)applicationWillResignActive:(UIApplication *)application {
    if (self.isStartBackground) {
        [self activePreventSuspending];
    }else{
        [self pausePreventSuspending];
    }
}
#pragma mark 即将进入前台
- (void)applicationWillEnterForeground:(NSNotification*)notification {
    [self disablePostEnterBackground];
}
#pragma mark 后台播放被打断
- (void)handleInterruptionNotification:(NSNotification *)notificaiton{
    NSDictionary *interruptInfo = notificaiton.userInfo;
    NSUInteger interruptType = AVAudioSessionInterruptionTypeBegan;
    if ([interruptInfo[AVAudioSessionInterruptionTypeKey] respondsToSelector:@selector(unsignedIntegerValue)]) {
        interruptType = [interruptInfo[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    }
    if (AVAudioSessionInterruptionTypeBegan == interruptType) {
        [self pausePreventSuspending];
    }
    else if (AVAudioSessionInterruptionTypeEnded == interruptType){
        [self activePreventSuspending];
    }
}
#pragma mark 初始化后台播放防止被操作系统杀死
- (void)initPreventSuspending{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    if (!self.audioPlayer) {
        AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[self soundfileURL] error:nil];
        self.audioPlayer = newPlayer;
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer setVolume:0];
        [self.audioPlayer setNumberOfLoops:-1];
    }
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [self.audioPlayer pause];
}
#pragma  mark 退出后台时，让播放器开始播放
- (void)activePreventSuspending{
    if (!self.audioPlayer) {
        [self initPreventSuspending];
    }
    if (!self.audioPlayer.isPlaying) {
        BOOL result = YES;
        NSError *error = nil;
        result = [[AVAudioSession sharedInstance] setActive:YES error:&error];
        if (result) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruptionNotification:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
            [self.audioPlayer play];
        }
    }
}
#pragma mark 停止播放
- (void)pausePreventSuspending{
    if (!self.audioPlayer) {
        return;
    }
    
    UIApplicationState appState = [UIApplication sharedApplication].applicationState;
    if (appState != UIApplicationStateActive) {
        [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    }
    [self.audioPlayer pause];
}

#pragma mark 播放音乐的地址
- (NSURL *)soundfileURL{
    NSURL *soundFileUrl = nil;
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"一生有你" ofType:@"mp3"];
    if (soundFilePath.length) {
        soundFileUrl = [[NSURL alloc] initFileURLWithPath:soundFilePath];
    }
    return soundFileUrl;
}
#pragma mark 激活后台任务
- (void)activePostponeEnterBackground{
    if (UIBackgroundTaskInvalid == self.backgroundTaskIdentifier) {
        self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
        
                [self disablePostEnterBackground];
            });
        }];
    }
}
#pragma mark 结束后台任务
- (void)disablePostEnterBackground{
    if (self.backgroundTaskIdentifier  != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
        self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    }
}
@end
