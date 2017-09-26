//
//  SignCalendarView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/11.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "SignCalendarView.h"

@implementation SignCalendarView

- (instancetype)initWithFrame:(CGRect)frame WithBlock:(void(^)(CGFloat height))heightBlock {
    if (self = [super initWithFrame:frame]) {
        self.returnHeightBlock = heightBlock;
        [self setUI];
        
        CTXViewBorderRadius(self, 5.0, 0, [UIColor clearColor]);
    }
    return self;
}

// 网络获取的时间
- (void)setNetDateWithNetTimeStep:(NSString *)timeStep {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStep doubleValue] / 1000];
    self.netWorkDate = date;
    NSDateComponents *dateComponents = [[NSDateComponents alloc]init];
    dateComponents.day = date.day;
    dateComponents.month = date.month;
    dateComponents.year = date.year;
    dateComponents.weekday = date.weekday;
    
    [self.calendarView setupWithMonthDateComponents:dateComponents];
    
    //更新日历的布局
    [self updateClanlendarFrameWithdateComponents:dateComponents];
}

- (void)setUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.headerView];
    [self.headerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.height.mas_equalTo(45);
    }];
    
    [self.headerView addSubview:self.monthLabel];
    [self.monthLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.headerView.center);
    }];
    
    //初始化本机时间
    NSDateComponents *dateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    [self.calendarView setupWithMonthDateComponents:dateComponents];
    [self addSubview:self.calendarView];
    [self.calendarView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(275);
        make.top.equalTo(self.headerView.mas_bottom).offset(10);
    }];
}

#pragma mark - getter/setter

- (UILabel *)monthLabel {
    if (_monthLabel == nil) {
        _monthLabel = [[UILabel alloc]init];
        _monthLabel.textColor = [UIColor whiteColor];
        [_monthLabel setTextAlignment:NSTextAlignmentCenter];
    }
    
    return _monthLabel;
}

- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc]init];
        _headerView.backgroundColor = CTXColor(80, 209, 241);
    }
    
    return _headerView;
}

- (void)updateClanlendarFrameWithdateComponents:(NSDateComponents *)dateComponents{
    if (([self getWeekdayWithCurrentDay:dateComponents.day WithWeek:dateComponents.weekday] >= 5) &&
        ([self is31daysCountWithMonth:dateComponents.month])) {
        
        [self.calendarView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.height.mas_equalTo(275 + 45);
            make.top.equalTo(self.headerView.mas_bottom).offset(10);
        }];
        [self.calendarView needsUpdateConstraints];
        
        // 更新collectionView高度
        if (self.returnHeightBlock) {
            self.returnHeightBlock(275+45);
        }
    } else {
        [self.calendarView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.height.mas_equalTo(275);
            make.top.equalTo(self.headerView.mas_bottom).offset(10);
        }];
        [self.calendarView needsUpdateConstraints];
        
        //更新collectionView高度
        if (self.returnHeightBlock) {
            self.returnHeightBlock(275);
        }
    }
}

- (LXMCalendarView *)calendarView {
    if (_calendarView == nil) {
        //初始化本机时间
        NSDateComponents *dateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:[NSDate date]];
        
        if (([self getWeekdayWithCurrentDay:dateComponents.day WithWeek:dateComponents.weekday] >= 5) &&
            ([self is31daysCountWithMonth:dateComponents.month])) {
            
            _calendarView = [[LXMCalendarView alloc] initWithFrame:CGRectMake(0, 10, CTXScreenWidth - 60, 275+45)];
            if (self.returnHeightBlock) {
                self.returnHeightBlock(275 + 45);
            }
        } else {
            _calendarView = [[LXMCalendarView alloc] initWithFrame:CGRectMake(0, 10, CTXScreenWidth - 60, 275)];
            if (self.returnHeightBlock) {
                self.returnHeightBlock(275);
            }
        }
    }
    
    return _calendarView;
}

- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
        _calendar.firstWeekday = 1;
        _calendar.minimumDaysInFirstWeek = 1;
    }
    
    return _calendar;
}

// 判断31天的月份
- (BOOL)is31daysCountWithMonth:(NSInteger)month {
    if (month == 1 || month == 3 || month == 5 || month == 7 ||
        month == 8 || month == 10 || month == 12) {
        return true;
    }
    
    return false;
}

// 判断月初第一天是周几
- (NSInteger)getWeekdayWithCurrentDay:(NSInteger)day WithWeek:(NSInteger)week {
    NSInteger yCount = day % 7;
    
    if (week < yCount) {
        return week + 7 - yCount;
    }
    
    return week - yCount;
}

@end
