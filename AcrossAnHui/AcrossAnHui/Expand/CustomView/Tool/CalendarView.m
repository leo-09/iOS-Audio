//
//  CalendarView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CalendarView.h"
#import "AppDelegate.h"
#import "DateTool.h"

@implementation CalendarView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
        
        [self addItemView];
    }
    
    return self;
}

- (void) addItemView {
    _calendar = [[BSLCalendar alloc] init];
    [_calendar selectDateOfMonth:^(NSInteger year, NSInteger month, NSInteger day) {
        NSString *monthStr = [self monthDayTool:month];
        NSString *dayStr = [self monthDayTool:day];
        
        if (self.isLater) {
            // 需要判断选择的日期 大于 当前日期
            int currentYear = [[DateTool sharedInstance] getCurrentYear];
            NSString *currentMonth = [self monthDayTool:[[DateTool sharedInstance] getCurrentMonth]];
            NSString *currentDay = [self monthDayTool:[[DateTool sharedInstance] getCurrentDay]];
            
            int currentDate = [[NSString stringWithFormat:@"%d%@%@", currentYear, currentMonth, currentDay] intValue];
            int selectDate = [[NSString stringWithFormat:@"%ld%@%@", (long)year, monthStr, dayStr] intValue];
            
            if (currentDate > selectDate) {// 小于当前日期
                [self showTextHubWithContent:@"请选择今天之后的日期"];
                return ;
            } else {
                [self selectDateWithYear:year monthStr:monthStr dayStr:dayStr];
            }
        } else {
            [self selectDateWithYear:year monthStr:monthStr dayStr:dayStr];
        }
    }];
    
    [self addSubview:_calendar];
    [_calendar makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.center);
        make.width.equalTo(CTXScreenWidth - 40);
        make.height.equalTo(300);
    }];
}

- (void) selectDateWithYear:(NSInteger)year monthStr:(NSString *)monthStr dayStr:(NSString *)dayStr {
    if (self.selectDateListener) {
        NSString *date = [NSString stringWithFormat:@"%ld-%@-%@", (long)year, monthStr, dayStr];
        self.selectDateListener(date);
        
        [self hideAnimation];
    }
}

- (NSString *) monthDayTool:(NSInteger) monthDay {
    NSString *monthDayStr;
    if (monthDay < 10) {
        monthDayStr = [NSString stringWithFormat:@"0%ld", (long)monthDay];
    } else {
        monthDayStr = [NSString stringWithFormat:@"%ld", (long)monthDay];
    }
    
    return monthDayStr;
}

- (void) showView {
    UIWindow *window = [AppDelegate sharedDelegate].window;
    [window addSubview:self];
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    [self showAnimation];
}

#pragma mark - 动画

- (void) hideAnimation {
    if (self.calendar.isHidden) {
        return;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    animation.duration = 0.2; // 持续时间
    animation.delegate = self;
    // 起始帧和终了帧的设定
    animation.fromValue = [NSValue valueWithCGPoint:self.calendar.center];
    
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.calendar.center.x, self.calendar.center.y + CTXScreenHeight)];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.calendar.layer removeAllAnimations];
    [self.calendar.layer addAnimation:animation forKey:@"hide-layer"];
}

- (void) showAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    animation.duration = 0.3;
    animation.delegate = self;
    // 起始帧和终了帧的设定
    CGPoint center = [AppDelegate sharedDelegate].window.center;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(center.x, center.y + CTXScreenHeight / 2)];
    animation.toValue = [NSValue valueWithCGPoint:center];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.calendar.layer removeAllAnimations];
    [self.calendar.layer addAnimation:animation forKey:@"show-layer"];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim.duration == 0.2) {
        [self removeFromSuperview];
    }
}


@end
