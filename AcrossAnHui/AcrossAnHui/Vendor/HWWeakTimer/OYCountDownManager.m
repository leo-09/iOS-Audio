//
//  CountDownManager.m
//  CellCountDown
//
//  Created by herobin on 16/9/11.
//  Copyright © 2016年 herobin. All rights reserved.
//

#import "OYCountDownManager.h"
#import "HWWeakTimer.h"

@interface OYCountDownManager ()

@property (nonatomic, weak) NSTimer *timer;

@end

@implementation OYCountDownManager

+ (instancetype)manager {
    static OYCountDownManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OYCountDownManager alloc]init];
    });
    return manager;
}

- (void)start {
    // 启动定时器
    [self timer];
}

- (void)reload {
    // 刷新只要让时间差为0即可
    _timeInterval = 0;
}

- (void)invalidate {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        self.timeInterval = 0;
    }
}

- (void)timerAction {
    // 时间差+1
    self.timeInterval++;
    
    CTXLog(@"定时器：%ld", (long)self.timeInterval);
    
    // 发出通知--可以将时间差传递出去,或者直接通知类属性取
    [[NSNotificationCenter defaultCenter] postNotificationName:kCountDownNotification object:nil userInfo:@{@"TimeInterval" : @(self.timeInterval)}];
}

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [HWWeakTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

@end
