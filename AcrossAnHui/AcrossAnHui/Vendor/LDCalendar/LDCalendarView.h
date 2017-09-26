//
//  LDCalendarView.h
//
//  Created by lidi on 15/9/1.
//  Copyright (c) 2015年 lidi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ParttimeComplete)(NSString *time,NSString *time1);

/**
 日历选择器
 */
@interface LDCalendarView : UIView<CAAnimationDelegate> {
    NSMutableArray *_currentMonthDateArray;
    NSMutableArray *_selectArray;
    NSMutableArray * codeSeletValue;
    
    CGRect _touchRect;              // 可操作区域
}

// 是否可以选择今天之后的日期
@property (nonatomic, assign) BOOL isCanSelectLaterDate;

@property (nonatomic, strong) NSDate *today;        // 今天0点的时间

@property (nonatomic, assign) int32_t month;
@property (nonatomic, assign) int32_t year;

@property (nonatomic, retain) UIView *superView;        // 当前view的父view
@property (nonatomic, retain) UIView *contentBgView;    // 背景View
@property (nonatomic, retain) UILabel *titleLab;        // 头部标题
@property (nonatomic, retain) UIView *dateBgView;       // 日期的背景
@property (nonatomic, retain) UIButton *doneBtn;        // 确定按钮
@property (nonatomic, retain) UIButton *cancelBtn;      // 取消按钮

// 选择完日期后的回调
@property (nonatomic, copy) ParttimeComplete complete;

- (void)showWithSuperView:(UIView *)view;

@end
