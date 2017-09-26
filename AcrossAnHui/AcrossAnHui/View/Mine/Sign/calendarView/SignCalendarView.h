//
//  SignCalendarView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/11.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "LXMCalendarView.h"

typedef void (^ReturnHeightBlock)(CGFloat height);

/**
 签到有奖的日历
 */
@interface SignCalendarView : CTXBaseView

@property (nonatomic,strong) LXMCalendarView *calendarView;

@property (nonatomic,strong) UILabel *monthLabel;

@property (nonatomic,strong) ReturnHeightBlock returnHeightBlock;

@property (nonatomic,strong) NSCalendar *calendar;

@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) NSDate *netWorkDate;

- (instancetype)initWithFrame:(CGRect)frame WithBlock:(void(^)(CGFloat height))heightBlock;
- (void)setNetDateWithNetTimeStep:(NSString *)timeStep;

@end
