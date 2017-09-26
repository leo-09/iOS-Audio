//
//  CSignView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/10.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "SignModel.h"
#import "SignCalendarView.h"

/**
 签到有奖View
 */
@interface CSignView : CTXBaseView

@property (nonatomic, retain) SignModel *model;

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIView *contentView;

@property (nonatomic, retain) UILabel *signDayLabel;
@property (nonatomic, retain) UILabel *signPersonLabel;
@property (nonatomic, retain) SignCalendarView *calendarView;
@property (nonatomic, retain) UIButton *signBtn;
@property (nonatomic, retain) UIButton *prideBtn;
@property (nonatomic, retain) UIView *lineView;
@property (nonatomic, retain) UILabel *textLabel;

@property (nonatomic, strong) ClickListener signListener;
@property (nonatomic, strong) ClickListener prideListener;

@end
