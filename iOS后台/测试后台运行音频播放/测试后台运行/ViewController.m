//
//  ViewController.m
//  测试后台运行
//
//  Created by water on 2018/5/14.
//  Copyright © 2018年 water. All rights reserved.
//

#import "ViewController.h"
#import "NSString+HH.h"
@interface ViewController ()
{
    NSTimer *_timer;
}
@property (nonatomic,strong) NSOutputStream *outputStream;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",NSHomeDirectory());
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(testOutputStream) userInfo:nil repeats:YES];
    }

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self testOutputStream];
}
- (void)testOutputStream{
    [[NSString getCurrentTime] writeToFile:[NSString libraryAppendPath:@"temp"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
