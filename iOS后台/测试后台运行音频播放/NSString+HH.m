//
//  NSString+HH.m
//  测试后台运行
//
//  Created by water on 2018/5/15.
//  Copyright © 2018年 water. All rights reserved.
//

#import "NSString+HH.h"

@implementation NSString (HH)
+ (NSString *)libraryAppendPath:(NSString *)subPath{
    NSString *lib = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    
    return [lib stringByAppendingPathComponent:subPath];
}
+ (NSString*)getCurrentTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    
    return currentTimeString;
}
@end
