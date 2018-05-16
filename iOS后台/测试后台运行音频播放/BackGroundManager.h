//
//  BackGroundManager.h
//  测试后台运行
//
//  Created by water on 2018/5/15.
//  Copyright © 2018年 water. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
@interface BackGroundManager : NSObject
@property (nonatomic,strong,nullable) AVAudioPlayer *audioPlayer;
@property (nonatomic,assign)          UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@property (nonatomic,assign)  BOOL isStartBackground;// 是否开启后台 YES 开启后台  NO不开启后台
+(instancetype)shareManager;
@end
