//
//  LDCalendarView.m
//
//  Created by lidi on 15/9/1.
//  Copyright (c) 2015年 lidi. All rights reserved.
//

#import "LDCalendarView.h"
#import "NSDate+extend.h"
#import "Masonry.h"

#define UNIT_WIDTH (35 * (CTXScreenWidth / 320.0f))
#define INTTOSTR(intNum) [@(intNum) stringValue]

// 行 列 每小格宽度 格子总数
static const NSInteger kRow = 7;
static const NSInteger kCol = 7;
static const NSInteger kTotalNum = (kRow - 1) * kCol;

@implementation LDCalendarView

#pragma mark - initView

- (id)init {
    if (self = [super init]) {
        // view的背景色
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
        // 添加子View
        [self addItemView];
        //初始化数据
        [self initData];
    }
    return self;
}

// 添加子View
- (void) addItemView {
    CGFloat height = 42 + UNIT_WIDTH * kCol + 50;
    
    // 内容区的背景
    _contentBgView = [[UIView alloc] init];
    _contentBgView.backgroundColor = [UIColor whiteColor];
    CTXViewBorderRadius(_contentBgView, 5.0, 0, [UIColor clearColor]);
    [self addSubview:_contentBgView];
    [_contentBgView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(UNIT_WIDTH * kCol));
        make.height.equalTo(height);
        make.top.equalTo((CTXScreenHeight - 64 - height) / 2);
        make.centerX.equalTo(self.centerX);
    }];
    
    // 添加头部View
    [self addHeaderView];
    
    // 显示日历的部分
    _dateBgView = [[UIView alloc] init];
    _dateBgView.userInteractionEnabled = YES;
    _dateBgView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    [_contentBgView addSubview:_dateBgView];
    [_dateBgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(_titleLab.bottom);
        make.height.equalTo(@(UNIT_WIDTH * kCol));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_dateBgView addGestureRecognizer:tap];
    
    // 添加底部View
    [self addFooterView];
}

// 添加头部View
- (void) addHeaderView {
    // 当前年月的标题
    _titleLab = [[UILabel alloc] init];
    _titleLab.textColor = UIColorFromRGB(CTXTextBlackColor);
    _titleLab.font = [UIFont systemFontOfSize:CTXTextFont];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    
    [_contentBgView addSubview:_titleLab];
    [_titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@42);
        make.top.equalTo(@0);
        make.centerX.equalTo(_contentBgView.centerX);
    }];
    
    // 日期向后退的按钮
    UIButton *leftBtn = [[UIButton alloc] init];
    [leftBtn setImage:[UIImage imageNamed:@"icon_2"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftSwitch) forControlEvents:UIControlEventTouchDown];
    [_contentBgView addSubview:leftBtn];
    [leftBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLab.centerY);
        make.right.equalTo(_titleLab.left);
        make.height.equalTo(@42);
        make.width.equalTo(@42);
    }];
    
    // 日期向前进的按钮
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setImage:[UIImage imageNamed:@"icon_1"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightSwitch) forControlEvents:UIControlEventTouchDown];
    [_contentBgView addSubview:rightBtn];
    [rightBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLab.centerY);
        make.left.equalTo(_titleLab.right);
        make.height.equalTo(@42);
        make.width.equalTo(@42);
    }];
}

// 添加底部按钮
- (void) addFooterView {
    _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_doneBtn setBackgroundColor:UIColorFromRGB(CTXThemeColor)];
    [_doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_doneBtn.titleLabel setFont:[UIFont systemFontOfSize:CTXTextFont]];
    CTXViewBorderRadius(_doneBtn, 4.0, 0, [UIColor clearColor]);
    [_doneBtn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_contentBgView addSubview:_doneBtn];
    [_doneBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(_dateBgView.bottom).offset(8);
        make.height.equalTo(@34);
        make.width.equalTo(@((UNIT_WIDTH * kCol - 36) / 2));
    }];

    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setBackgroundColor:UIColorFromRGB(CTXBLineViewColor)];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:CTXTextFont]];
    CTXViewBorderRadius(_cancelBtn, 4.0, 0, [UIColor clearColor]);
    [_cancelBtn addTarget:self action:@selector(disapperBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_contentBgView addSubview:_cancelBtn];
    [_cancelBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-12));
        make.top.equalTo(_dateBgView.bottom).offset(8);
        make.height.equalTo(@34);
        make.width.equalTo(@((UNIT_WIDTH * kCol - 36) / 2));
    }];
}

#pragma mark - event response

// 左：日期向后退
- (void)leftSwitch {
    if (self.month > 1) {   // 月份后退
        self.month -= 1;
    } else {
        self.month = 12;
        self.year -= 1;
    }
    
    [self refreshDateTitle];
}

// 右：日期向前进
- (void)rightSwitch {
    if (self.month < 12) {  // 月份前进
        self.month += 1;
    } else {
        self.month = 1;
        self.year += 1;
    }
    
    [self refreshDateTitle];
}

// 取消
-(void)disapperBtnClick:(UIButton*)btn {
    [self hideAnimation];
}

// 确认
-(void)doneBtnClick:(UIButton*)btn {
    if (codeSeletValue.count == 0) {
        self.complete(nil, nil);// 没有选择，则不传日期
    } else if (codeSeletValue.count == 1) {
        // 时区相差8个小时 加上这个时区即是北京时间
        NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
        NSInteger delta = [timeZone secondsFromGMT];
        
        //设定时间格式,这里可以设置成自己需要的格式
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSTimeInterval startIntervalTime = [[codeSeletValue[0] objectForKey:@"time"] doubleValue];
        NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSince1970:startIntervalTime / 1000 + delta];
        NSString *startTime = [dateFormatter stringFromDate:startDate];
        
        [self hideAnimation];
        self.complete(startTime, startTime);
    } else if (codeSeletValue.count == 2) {
        // 时区相差8个小时 加上这个时区即是北京时间
        NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
        NSInteger delta = [timeZone secondsFromGMT];
        
        //设定时间格式,这里可以设置成自己需要的格式
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSTimeInterval startIntervalTime = [[codeSeletValue[0] objectForKey:@"time"] doubleValue];
        NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSince1970:startIntervalTime / 1000 + delta];
        NSString *startTime = [dateFormatter stringFromDate:startDate];
        
        NSTimeInterval endIntervalTime = [[codeSeletValue[1] objectForKey:@"time"] doubleValue];
        NSDate *endDate = [[NSDate alloc] initWithTimeIntervalSince1970:endIntervalTime / 1000 + delta];
        NSString *endTime = [dateFormatter stringFromDate:endDate];
        
        [self hideAnimation];
        if (endIntervalTime > startIntervalTime) {
            self.complete(startTime, endTime);
        } else {
            self.complete(endTime, startTime);
        }
    }
}

#pragma mark - 更新数据、显示的日期

// 初始化数据
- (void)initData {
    _selectArray = [NSMutableArray array];
    codeSeletValue = [NSMutableArray array];
    
    _currentMonthDateArray = [NSMutableArray array];
    for (int i = 0; i < kTotalNum; i++) {
        [_currentMonthDateArray addObject:@(0)];
    }
    
    // 获取当前年月
    NSDate *currentDate = [NSDate date];
    self.month = (int32_t)currentDate.month;
    self.year = (int32_t)currentDate.year;
    
    [self refreshDateTitle];
}

// 更新日期
- (void) refreshDateTitle {
    _titleLab.text = [NSString stringWithFormat:@"%@年%@月",@(self.year),@(self.month)];
    [self showDateView];
}

// 根据日期数据，重新布局
- (void)showDateView {
    // 移除之前子视图
    [_dateBgView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    // 日期的区域
    CGFloat offX = 0.0;
    CGFloat offY = 0.0;
    CGFloat w = UNIT_WIDTH;
    CGFloat h = UNIT_WIDTH;
    CGRect baseRect = CGRectMake(offX,offY, w, h);
    
    // 显示星期
    NSArray *tmparr = @[ @"日", @"一", @"二", @"三", @"四", @"五", @"六" ];
    for(int i = 0 ; i < tmparr.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:baseRect];
        lab.textColor = UIColorFromRGB(CTXThemeColor);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:CTXTextFont];
        lab.backgroundColor = [UIColor clearColor];
        lab.text = [tmparr objectAtIndex:i];
        [_dateBgView addSubview:lab];
        
        baseRect.origin.x += baseRect.size.width;
    }
    
    // 设定时间格式,这里可以设置成自己需要的格式
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    // 字符串转换为日期
    NSDate *firstDay = [dateFormat dateFromString:[NSString stringWithFormat:@"%@-%@-%@", @(self.year), @(self.month), @(1)]];
    
    CGFloat startDayIndex = [NSDate acquireWeekDayFromDate:firstDay];
    if (startDayIndex == 1) {   // 第一天是今天，特殊处理
        startDayIndex = 0;      // 星期天（对应一）
    } else {
        startDayIndex -= 1;     // 周一到周六（对应2-7）
    }
    
    baseRect.origin.x = w * startDayIndex;
    baseRect.origin.y += (baseRect.size.height);
    NSInteger baseTag = 100;
    
    for(int i = startDayIndex; i < kTotalNum; i++) {
        if (i % kCol == 0 && i!= 0) {
            baseRect.origin.y += (baseRect.size.height);
            baseRect.origin.x = offX;
        }
        
        //设置触摸区域
        if (i == startDayIndex) {
            _touchRect.origin = baseRect.origin;
            _touchRect.origin.x = 0;
            _touchRect.size.width = kCol * w;
            _touchRect.size.height = kRow * h;
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = baseTag + i;
        [btn setFrame:baseRect];
        btn.userInteractionEnabled = NO;
        btn.backgroundColor = [UIColor clearColor];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:CTXTextFont]];
        
        NSDate * date = [firstDay dateByAddingTimeInterval:(i - startDayIndex) *24*60*60];
        _currentMonthDateArray[i] = @(([date timeIntervalSince1970]) * 1000);
        NSString *title = INTTOSTR(date.day);
        
        if ([date isToday]) {       // 今天
            title = @"今天";
            CTXViewBorderRadius(btn, 3.0, 1.0, UIColorFromRGB(CTXThemeColor));
        } else if(date.day == 1) {  // 是1号
            // 在下面标一下月份
            CGRect monthLabFrame = CGRectMake(baseRect.origin.x, baseRect.origin.y + baseRect.size.height - 7, baseRect.size.width, 7);
            UILabel *monthLab = [[UILabel alloc] initWithFrame:monthLabFrame];
            monthLab.backgroundColor = [UIColor clearColor];
            monthLab.textAlignment = NSTextAlignmentCenter;
            monthLab.font = [UIFont systemFontOfSize:7];
            monthLab.textColor = UIColorFromRGB(0xc0c0c0);
            monthLab.text = [NSString stringWithFormat:@"%@月",@(date.month)];
            [_dateBgView addSubview:monthLab];
        }
        
        if ([self.today compare:date] < 0) {    // 时间比今天大,同时是当前月
            [btn setTitleColor:UIColorFromRGB(CTXBaseFontColor) forState:UIControlStateNormal];
        } else {
            [btn setTitleColor:UIColorFromRGB(CTXTextBlackColor) forState:UIControlStateNormal];
        }
        
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor clearColor]];
        
        [_dateBgView addSubview:btn];
        [_dateBgView sendSubviewToBack:btn];
        
        baseRect.origin.x += (baseRect.size.width);
    }
    
    // 高亮选中的
    [self refreshDateView];
}

// 高亮选中的
- (void)refreshDateView {
    if (codeSeletValue.count == 2) {
        int month1 = [[codeSeletValue[0] objectForKey:@"month"] intValue];;
        int month2 = [[codeSeletValue[1] objectForKey:@"month"] intValue];;
        int index1 = [[codeSeletValue[0] objectForKey:@"index"] intValue];;
        int index2 = [[codeSeletValue[1] objectForKey:@"index"] intValue];;
        
        if (month1 > month2) {
            if (self.month == month1) {
                for (int i = 0; i <= index1; i++) {
                    UIButton *btn1 = (UIButton *)[_dateBgView viewWithTag:100 + i];
                    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btn1 setBackgroundColor:UIColorFromRGB(CTXThemeColor)];
                }
            } else if (self.month == month2) {
                for (int i = index2; i <= kTotalNum; i++) {
                    UIButton *btn1 = (UIButton *)[_dateBgView viewWithTag:100 + i];
                    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btn1 setBackgroundColor:UIColorFromRGB(CTXThemeColor)];
                }
            } else if (self.month > month2 && self.month < month1) {
                for (int i = 0; i <= kTotalNum; i++) {
                    UIButton *btn1 = (UIButton *)[_dateBgView viewWithTag:100 + i];
                    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btn1 setBackgroundColor:UIColorFromRGB(CTXThemeColor)];
                }
            }
        } else if (month1 < month2) {
            if (self.month == month1) {
                for (int i = index1; i <= kTotalNum; i++) {
                    UIButton *btn1 = (UIButton *)[_dateBgView viewWithTag:100 + i];
                    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btn1 setBackgroundColor:UIColorFromRGB(CTXThemeColor)];
                }
            } else if (self.month == month2) {
                for (int i = 0; i <= index2; i++) {
                    UIButton *btn1 = (UIButton *)[_dateBgView viewWithTag:100 + i];
                    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btn1 setBackgroundColor:UIColorFromRGB(CTXThemeColor)];
                }
            } else if (self.month > month1 && self.month < month2) {
                for (int i = 0; i <= kTotalNum; i++) {
                    UIButton *btn1 = (UIButton *)[_dateBgView viewWithTag:100 + i];
                    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btn1 setBackgroundColor:UIColorFromRGB(CTXThemeColor)];
                }
            }
        }
        
        for (int i = 0; i < kTotalNum; i++) {
            UIButton *btn = (UIButton *)[_dateBgView viewWithTag:100 + i];
            NSNumber *interval = [_currentMonthDateArray objectAtIndex:i];
            
            if (i < [_currentMonthDateArray count] && btn) {
                if ([_selectArray containsObject:interval]) {
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btn setBackgroundColor:UIColorFromRGB(CTXThemeColor)];
                }
            }
        }
        
    }
}

#pragma mark - 日期的手势操作

-(void)tap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:_dateBgView];
    
    if (CGRectContainsPoint(_touchRect, point)) {
        CGFloat w = (CGRectGetWidth(_dateBgView.frame)) / kCol;
        CGFloat h = (CGRectGetHeight(_dateBgView.frame)) / kRow;
        int row = (int)((point.y - _touchRect.origin.y) / h);
        int col = (int)((point.x) / w);
        
        NSInteger index = row * kCol + col;
        [self clickForIndex:index];
    }
}

- (void)clickForIndex:(NSInteger)index {
    if (index < [_currentMonthDateArray count]) {
        NSNumber *interval = [_currentMonthDateArray objectAtIndex:index];
        NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:interval.doubleValue / 1000.0];
        
        // 时间比今天大
        if ([self.today compare:date1] < 0 && !self.isCanSelectLaterDate) {
            return;
        }
        
        UIButton *btn = (UIButton *)[_dateBgView viewWithTag:100 + index];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:UIColorFromRGB(CTXThemeColor)];
        
        // 添加选择的时间点
        if (![_selectArray containsObject:interval]) {
            [_selectArray addObject:interval];
            NSString * month = [NSString stringWithFormat:@"%ld", (long)self.month];
            NSDictionary * dic = @{ @"month" : month,
                                    @"index" : @(index),
                                    @"time" : interval };
            [codeSeletValue addObject:dic];
        }
        
        if (codeSeletValue.count == 2) {
            int month1 = [[codeSeletValue[0] objectForKey:@"month"] intValue];;
            int month2 = [[codeSeletValue[1] objectForKey:@"month"] intValue];;
            
            int value1 = [[codeSeletValue[0] objectForKey:@"index"] intValue];;
            int value2 = [[codeSeletValue[1] objectForKey:@"index"] intValue];;
            
            if (month1 == month2) {
                if (value1 >= value2 ) {
                    for (int i = value2; i<value1; i++) {
                        UIButton *btn1 = (UIButton *)[_dateBgView viewWithTag:100 + i];
                        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [btn1 setBackgroundColor:UIColorFromRGB(CTXThemeColor)];
                    }
                } else {
                    for (int i = value1; i<value2; i++) {
                        UIButton *btn1 = (UIButton *)[_dateBgView viewWithTag:100 + i];
                        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [btn1 setBackgroundColor:UIColorFromRGB(CTXThemeColor)];
                    }
                }
            } else if (month2 > month1) {
                for (int i = 0; i<=value2; i++) {
                    UIButton *btn1 = (UIButton *)[_dateBgView viewWithTag:100 + i];
                    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btn1 setBackgroundColor:UIColorFromRGB(CTXThemeColor)];
                }
            } else {
                for (int i = value2; i<=kTotalNum; i++) {
                    UIButton *btn1 = (UIButton *)[_dateBgView viewWithTag:100 + i];
                    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btn1 setBackgroundColor:UIColorFromRGB(CTXThemeColor)];
                }
            }
        }
        
        if (codeSeletValue.count > 2) {
            for (int a = 0; a < _currentMonthDateArray.count; a++) {
                if (a == index) {
                    UIButton *btn1 = (UIButton *)[_dateBgView viewWithTag:100 + a];
                    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btn1 setBackgroundColor:UIColorFromRGB(CTXThemeColor)];
                } else {
                    UIButton *btn1 = (UIButton *)[_dateBgView viewWithTag:100 + a];
                    [btn1 setBackgroundColor:[UIColor clearColor]];
                    if ([self.today compare:date1] < 0) {    // 时间比今天大,同时是当前月
                        [btn1 setTitleColor:UIColorFromRGB(CTXBaseFontColor) forState:UIControlStateNormal];
                    } else {
                        [btn1 setTitleColor:UIColorFromRGB(CTXTextBlackColor) forState:UIControlStateNormal];
                    }
                }
            }
            
            [_selectArray removeAllObjects];
            [codeSeletValue removeAllObjects];
            [_selectArray addObject:interval];
            
            NSString * month = [NSString stringWithFormat:@"%ld", (long)self.month];
            NSDictionary * dic = @{ @"month" : month,
                                    @"index" : @(index),
                                    @"time" : interval };
            [codeSeletValue addObject:dic];
        }
    }
}

#pragma mark - getter/setter

- (NSDate *)today {
    if (!_today) {
        NSDate *currentDate = [NSDate date];
        NSInteger tYear = currentDate.year;
        NSInteger tMonth = currentDate.month;
        NSInteger tDay = currentDate.day;
        
        // 实例化一个NSDateFormatter对象
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        
        //字符串转换为日期
        _today = [dateFormat dateFromString:[NSString stringWithFormat:@"%@-%@-%@",@(tYear),@(tMonth),@(tDay)]];
    }
    
    return _today;
}

- (int)getDaysInMonth:(int)year month:(int)imonth {
    // imonth == 0的情况是应对在CourseViewController里month-1的情况
    if( (imonth == 0) ||
       (imonth == 1) || (imonth == 3) || (imonth == 5) || (imonth == 7) ||
       (imonth == 8) || (imonth == 10) || (imonth == 12) ) {
        return 31;
    } else if( (imonth == 4)||(imonth == 6)||(imonth == 9)||(imonth == 11) ) {
        return 30;
    } else {        // imonth == 2
        if(( (year % 4 == 0) && (year % 100 != 0) ) || year % 400 == 0) {  // 闰年
            return 29;
        } else {    // 非闰年
            return 28;
        }
    }
}

#pragma mark - public method

- (void)showWithSuperView:(UIView *)view {
    self.superView = view;
    
    [view addSubview:self];
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.superView);
    }];
    
    [self showAnimation];
}

#pragma mark - 动画

- (void) showAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    animation.duration = 0.3;
    animation.delegate = self;
    
    // 起始帧和终了帧的设定
    CGPoint center = CGPointMake(CTXScreenWidth / 2, (CTXScreenHeight - 64) / 2);
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(center.x, center.y + CTXScreenHeight / 2)];
    animation.toValue = [NSValue valueWithCGPoint:center];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.contentBgView.layer removeAllAnimations];
    [self.contentBgView.layer addAnimation:animation forKey:@"show-layer"];
}

- (void) hideAnimation {
    if (self.contentBgView.isHidden) {
        return;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    animation.duration = 0.2; // 持续时间
    animation.delegate = self;
    
    // 起始帧和终了帧的设定
    animation.fromValue = [NSValue valueWithCGPoint:self.contentBgView.center];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.contentBgView.center.x, self.contentBgView.center.y + CTXScreenHeight)];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.contentBgView.layer removeAllAnimations];
    [self.contentBgView.layer addAnimation:animation forKey:@"hide-layer"];
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
