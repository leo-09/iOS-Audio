//
//  ParkingDetailView.m
//  IntelligentParkingManagement
//
//  Created by liyy on 2017/5/3.
//  Copyright © 2017年 ahctx. All rights reserved.
//

#import "ParkingDetailView.h"
#import "PNChart.h"
#import "Masonry.h"
#import "YYKit.h"

static CGFloat distance = 10;

@interface ParkingDetailView() {
    int total;
    int free;
}

@property (nonatomic, retain) PNPieChart *pieChart;

@end

@implementation ParkingDetailView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self addButtonView];
        [self addScrollView];
        
        managerIcons = @[ @"icon_name", @"icon_dh", @"icon_rqi", @"icon_dqzt" ];
        managertitles = @[ @"姓名", @"联系电话", @"上次签到", @"当前状态" ];
        chargetitles = @[ @"收费时间", @"免费时段", @"起步价", @"起步时长", @"间隔时长", @"超出缴费", @"最高收费" ];
    }
    return self;
}

#pragma mark - 添加子View

// buttonView
- (void) addButtonView {
    _buttonView = [[UIView alloc] init];
    _buttonView.backgroundColor = UIColorFromRGB(CTXThemeColor);
    [self addSubview:_buttonView];
    [_buttonView makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(0);
        make.bottom.equalTo(self);
        make.height.equalTo(52);
    }];
    
    UIButton *roadBtn = [[UIButton alloc] init];
    roadBtn.backgroundColor = [UIColor clearColor];
    [roadBtn setTitle:@"路段" forState:UIControlStateNormal];
    roadBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [roadBtn setImage:[[UIImage imageNamed:@"icon_ld"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [roadBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 7)];
    [roadBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
    [roadBtn addTarget:self action:@selector(traffic) forControlEvents:UIControlEventTouchDown];
    [_buttonView addSubview:roadBtn];
    [roadBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.bottom.equalTo(_buttonView);
        make.width.equalTo(_buttonView).dividedBy(2);
    }];
    
    UIButton *naviBtn = [[UIButton alloc] init];
    naviBtn.backgroundColor = [UIColor clearColor];
    [naviBtn setTitle:@"导航" forState:UIControlStateNormal];
    naviBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [naviBtn setImage:[[UIImage imageNamed:@"icon_navi"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [naviBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 7)];
    [naviBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
    [naviBtn addTarget:self action:@selector(navigation) forControlEvents:UIControlEventTouchDown];
    [_buttonView addSubview:naviBtn];
    [naviBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.and.bottom.equalTo(_buttonView);
        make.width.equalTo(_buttonView).dividedBy(2);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor whiteColor];
    [_buttonView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_buttonView);
        make.width.equalTo(1);
        make.height.equalTo(25);
    }];
}

// scrollView
- (void) addScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:scrollView];
    [scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(self);
        make.bottom.equalTo(_buttonView.top);
    }];
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:_contentView];
    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.and.right.equalTo(scrollView).with.insets(UIEdgeInsetsZero);
        make.width.equalTo(scrollView);
    }];
}

// 布局titleView
- (void) addTitleView {
    if (_titleView) {
        [_titleView removeAllSubviews];
    }
    
    CGFloat titleViewHeight = 185;
    // _titleView
    _titleView = [[UIView alloc] init];
    _titleView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_titleView];
    [_titleView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(distance);
        make.right.equalTo(@0);
        make.height.equalTo(titleViewHeight);
    }];
    
    // 空闲车位:使用车位
    total = _siteModel.siteTotalNumber;
    free = _siteModel.siteFreeNumber;
    NSArray *values = @[ @(free), @(total-free) ];
    
    // chartView
    // 数据源
    NSArray *items = [self getPNPieChartDataItemWithNames:@[@"空闲车位", @""] values:values];
    _pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(CTXScreenWidth-110, (titleViewHeight-105) / 2, 105, 105) items:items];
    // 设置pieChart属性
    [self setPNPieChart:_pieChart];
    [_titleView addSubview:_pieChart];
    
    // legend
    UIView *legend = [self legendFromPNPieChart:_pieChart];
    [_titleView addSubview:legend];
    [legend makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-95));
        make.bottom.equalTo(@(-30));
    }];
    
    [self addLabelViewWithPieChart:_pieChart freeCount:free totalCount:total];
    
    // 所在区域
    UILabel *areaLabel = [[UILabel alloc] init];
    areaLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    areaLabel.textColor = CTXColor(108, 108, 108);
    areaLabel.text = [NSString stringWithFormat:@"所在区域：%@", _siteModel.areaname];
    [_titleView addSubview:areaLabel];
    [areaLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(20);
        make.right.equalTo(_pieChart.left).offset(-5);
    }];
    
    // 计费车辆
    UILabel *chargeCarLabel = [[UILabel alloc] init];
    chargeCarLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    chargeCarLabel.textColor = CTXColor(108, 108, 108);
    chargeCarLabel.text = [NSString stringWithFormat:@"已开始计费车辆：%@辆", _siteModel.startBillCarNumber];
    
    [_titleView addSubview:chargeCarLabel];
    [chargeCarLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(areaLabel.bottom).offset(10);
        make.right.equalTo(_pieChart.left).offset(-5);
    }];
    
    // 所在道路
    UILabel *roadLabel = [[UILabel alloc] init];
    roadLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    roadLabel.textColor = CTXColor(108, 108, 108);
    roadLabel.numberOfLines = 2;
    roadLabel.text = [NSString stringWithFormat:@"所在道路：%@", _siteModel.sitename];
    [_titleView addSubview:roadLabel];
    [roadLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(chargeCarLabel.bottom).offset(10);
        make.right.equalTo(_pieChart.left).offset(-5);
    }];
    
    // 离我距离
    UILabel *distanceLabel = [[UILabel alloc] init];
    distanceLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    distanceLabel.textColor = CTXColor(108, 108, 108);
    distanceLabel.text = [NSString stringWithFormat:@"离我距离：%.2lf公里", _siteModel.distance];
    [_titleView addSubview:distanceLabel];
    [distanceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(roadLabel.bottom).offset(10);
        make.right.equalTo(_pieChart.left).offset(-5);
    }];
    
    // 路段类型
    UILabel *typeLabel = [[UILabel alloc] init];
    typeLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    typeLabel.textColor = CTXColor(108, 108, 108);
    typeLabel.text = [NSString stringWithFormat:@"路段类型：%@", _siteModel.category];
    [_titleView addSubview:typeLabel];
    [typeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(distanceLabel.bottom).offset(10);
        make.right.equalTo(_pieChart.left).offset(-5);
    }];
}

// 布局chargeRuleView
- (void) addChargeRuleView {
    if (_chargeRuleView) {
        [_chargeRuleView removeAllSubviews];
    }
    
    // 计算高度
    CGFloat titleHeight = 50;
    CGFloat tableRowHeight = 32;
    
    // _chargePeriodView
    _chargeRuleView = [[UIView alloc] init];
    _chargeRuleView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_chargeRuleView];
    [_chargeRuleView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(_titleView.bottom).offset(10);
    }];
    
    // 收费标准
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"收费标准";
    [_chargeRuleView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.equalTo(_chargeRuleView);
        make.left.equalTo(15);
        make.height.equalTo(titleHeight);
    }];
    
    // 各个车型的收费 的列表
    UIView *lastTableView;
    for (int index = 0; index < _sitefeeModels.count; index++) {
        // 各个车型的收费的表格
        UIView *tableView = [[UIView alloc] init];
        tableView.backgroundColor = [UIColor clearColor];
        [_chargeRuleView addSubview:tableView];
        [tableView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.right.equalTo(-15);
            
            if (lastTableView) {
                make.top.equalTo(lastTableView.bottom).offset(10);
            } else {
                make.top.equalTo(titleLabel.bottom);
            }
            
        }];
        lastTableView = tableView;
        
        // 车型对应的具体收费标准(路段详情的业务逻辑处理,应该放到业务逻辑层,不应该放在View层)
        SitefeeModel *sitefeeModel = _sitefeeModels[index];
        
        NSString *chargeTime = [NSString stringWithFormat:@"%@-%@", sitefeeModel.startWorkTime, sitefeeModel.endWorkTime];
        NSString *freeTimeSeg = [NSString stringWithFormat:@"%@分钟", sitefeeModel.freeTimeSeg];
        NSString *minPayment = [NSString stringWithFormat:@"%.1f元", sitefeeModel.minPayment];
        NSString *chargeTimeSeg = [NSString stringWithFormat:@"%@分钟", sitefeeModel.firstChargingTimeSeg];
        NSString *normalChargingTimeSeg = [NSString stringWithFormat:@"%@分钟", sitefeeModel.normalChargingTimeSeg];
        NSString *normalChargingPrice = [NSString stringWithFormat:@"%.1f元", sitefeeModel.normalChargingPrice];
        NSString *maxPayment = [NSString stringWithFormat:@"%.1f元", sitefeeModel.maxPayment];
        NSArray *chargeRuleInfo = @[ chargeTime,
                                     freeTimeSeg,
                                     minPayment,
                                     chargeTimeSeg,
                                     normalChargingTimeSeg,
                                     normalChargingPrice,
                                     maxPayment ];
        
        // 车型的名称
        UILabel *workLabel = [[UILabel alloc] init];
        workLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        workLabel.textColor = CTXColor(108, 108, 108);
        workLabel.text = sitefeeModel.pname;
        workLabel.textAlignment = NSTextAlignmentCenter;
        workLabel.backgroundColor = CTXColor(242, 243, 248);
        [tableView addSubview:workLabel];
        [workLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.and.right.equalTo(0);
            make.height.equalTo(tableRowHeight);
        }];
        
        // workLabel右下的线
        UIView *workRightLine = [[UIView alloc] init];
        workRightLine.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [tableView addSubview:workRightLine];
        [workRightLine makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(workLabel.right);
            make.top.equalTo(workLabel.top);
            make.height.equalTo(workLabel.height);
            make.width.equalTo(@0.5);
        }];
        UIView *workBottomLine = [[UIView alloc] init];
        workBottomLine.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [tableView addSubview:workBottomLine];
        [workBottomLine makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(workLabel.left);
            make.bottom.equalTo(workLabel.bottom);
            make.width.equalTo(workLabel.width);
            make.height.equalTo(@0.5);
        }];
        
        // 具体收费时段的内容
        UILabel *lastTimeLabel;
        for (int j = 0; j < chargetitles.count; j++) {
            // 时间段
            UILabel *timeLabel = [[UILabel alloc] init];
            timeLabel.font = [UIFont systemFontOfSize:CTXTextFont];
            timeLabel.textColor = CTXColor(108, 108, 108);
            timeLabel.text = chargetitles[j];
            timeLabel.textAlignment = NSTextAlignmentCenter;
            [tableView addSubview:timeLabel];
            [timeLabel makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(0);
                make.top.equalTo(tableRowHeight * (j+1));
                make.width.equalTo(tableView).dividedBy(2);
                make.height.equalTo(tableRowHeight);
            }];
            // 记录最后一个UILabel
            lastTimeLabel = timeLabel;
            
            // timeLabel右下的线
            UIView *timeRightLine = [[UIView alloc] init];
            timeRightLine.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
            [tableView addSubview:timeRightLine];
            [timeRightLine makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(timeLabel.right);
                make.top.equalTo(timeLabel.top);
                make.height.equalTo(timeLabel.height);
                make.width.equalTo(@0.5);
            }];
            UIView *timeBotomLine = [[UIView alloc] init];
            timeBotomLine.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
            [tableView addSubview:timeBotomLine];
            [timeBotomLine makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(timeLabel.left);
                make.bottom.equalTo(timeLabel.bottom);
                make.width.equalTo(timeLabel.width);
                make.height.equalTo(@0.5);
            }];
            
            // 免费／收费
            UILabel *freeLabel = [[UILabel alloc] init];
            freeLabel.text = chargeRuleInfo[j];
            freeLabel.font = [UIFont systemFontOfSize:CTXTextFont];
            freeLabel.textAlignment = NSTextAlignmentCenter;
            
            if (j < (chargetitles.count-2)) {
                freeLabel.textColor = CTXColor(108, 108, 108);
            } else {
                freeLabel.textColor = UIColorFromRGB(CTXThemeColor);
            }
            [tableView addSubview:freeLabel];
            [freeLabel makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(0);
                make.top.equalTo(tableRowHeight * (j+1));
                make.width.equalTo(tableView).dividedBy(2);
                make.height.equalTo(tableRowHeight);
            }];
            
            // freeLabel右下的线
            UIView *freeRightLine = [[UIView alloc] init];
            freeRightLine.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
            [tableView addSubview:freeRightLine];
            [freeRightLine makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(freeLabel.right);
                make.top.equalTo(freeLabel.top);
                make.height.equalTo(freeLabel.height);
                make.width.equalTo(@0.5);
            }];
            UIView *freeBottomLine = [[UIView alloc] init];
            freeBottomLine.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
            [tableView addSubview:freeBottomLine];
            [freeBottomLine makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(freeLabel.left);
                make.bottom.equalTo(freeLabel.bottom);
                make.width.equalTo(freeLabel.width);
                make.height.equalTo(@0.5);
            }];
        }
        
        // 每个表格的最终高度
        [tableView updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastTimeLabel);
        }];
        
        // 左上的线
        UIView *leftLine = [[UIView alloc] init];
        leftLine.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [_chargeRuleView addSubview:leftLine];
        [leftLine makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tableView.left);
            make.top.equalTo(tableView.top);
            make.height.equalTo(tableView.height);
            make.width.equalTo(@0.5);
        }];
        UIView *topLine = [[UIView alloc] init];
        topLine.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [_chargeRuleView addSubview:topLine];
        [topLine makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tableView.left);
            make.top.equalTo(tableView.top);
            make.width.equalTo(tableView.width);
            make.height.equalTo(@0.5);
        }];
    }
    
    // _chargePeriodView的底部
    if (lastTableView) {
        [_chargeRuleView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastTableView).offset(20);
        }];
    } else {
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zanw_tz"]];
        iv.contentMode = UIViewContentModeCenter;
        [_chargeRuleView addSubview:iv];
        [iv makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.bottom);
            make.right.equalTo(-15);
            make.left.equalTo(30);
        }];
        
        
        UILabel *infoLabel = [[UILabel alloc] init];
        infoLabel.font = [UIFont systemFontOfSize:14];
        infoLabel.textColor = [UIColor grayColor];
        infoLabel.textAlignment = NSTextAlignmentCenter;
        infoLabel.text = @"暂无收费标准";
        [_chargeRuleView addSubview:infoLabel];
        [infoLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iv.bottom);
            make.right.equalTo(-15);
            make.left.equalTo(30);
            make.height.equalTo(titleHeight);
        }];
        
        [_chargeRuleView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(infoLabel);
        }];
    }
}

#pragma make - public mehod

- (void) addSiteModel:(SiteModel *) siteModel sitefeeModels:(NSArray *) sitefeeModels {
    _siteModel = siteModel;
    _sitefeeModels = sitefeeModels;
    
    if (!_siteModel) {
        [self addNilDataView];
        [promptView setRequestFailureImageView];
        return;
    } else {
        if (promptView) {
            [promptView removeFromSuperview];
            promptView = nil;
        }
    }
    
    [self addTitleView];
    [self addChargeRuleView];
    
    // 设置过渡视图的底边距（此设置将影响到scrollView的contentSize）
    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_chargeRuleView.bottom);
    }];
}

- (void) addNilDataView {
    if (!promptView) {
        promptView = [[PromptView alloc] init];
        
        @weakify(self)
        [promptView setPromptRefreshListener:^{
            @strongify(self)
            if (self.refreshParkInfoListener) {
                self.refreshParkInfoListener(YES);
            }
        }];
    }
    
    [self addSubview:promptView];
    [promptView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void) setShowTrafficListener:(void(^)())listener {
    showTrafficListener = listener;
}

- (void) setShowNavigationListener:(void(^)(double latitude, double longitude))listener {
    showNavigationListener = listener;
}

#pragma mark - private method

- (void) traffic {
    if (showTrafficListener) {
        showTrafficListener();
    }
}

- (void) navigation {
    if (showNavigationListener) {
        double latitude = _siteModel.latitude;
        double longitude = _siteModel.longitude;
        showNavigationListener(latitude, longitude);
    }
}

#pragma mark - PieChartView private method

// 在中间显示 比例view
- (void) addLabelViewWithPieChart:(PNPieChart *) pieChart freeCount:(int)freeCount totalCount:(int) totalCount {
    UIView *innerView = [pieChart getInnerContentView];
    
    NSString *freeText = [NSString stringWithFormat:@"%d", freeCount];
    NSString *totalText = [NSString stringWithFormat:@"%d", totalCount];
    NSString *contentStr = [NSString stringWithFormat:@"%@/%@", freeText, totalText];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:(contentStr ? contentStr : @"")];
    text.color = UIColorFromRGB(0x3676D6);
    text.font = [UIFont systemFontOfSize:16.0f];
    // 总计车位 标淡色
    NSRange range = [contentStr rangeOfString:(totalText ? totalText : @"") options:NSBackwardsSearch];
    [text setColor:UIColorFromRGB(CTXThemeColor) range:range];
    [text setFont:[UIFont systemFontOfSize:CTXTextFont] range:range];
    
    YYLabel *label = [[YYLabel alloc] initWithFrame:innerView.bounds];
    label.backgroundColor = [UIColor clearColor];
    label.attributedText = text;
    label.textAlignment = NSTextAlignmentCenter;
    
    [innerView addSubview:label];
}

// 获取数据源
- (NSMutableArray *) getPNPieChartDataItemWithNames:(NSArray *)names values:(NSArray *)values {
    NSArray *colors = @[UIColorFromRGB(0x3676D6), UIColorFromRGB(CTXThemeColor) ];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (int i = 0; i < names.count; i++) {
        double value = [values[i] doubleValue];
        [items addObject:[PNPieChartDataItem dataItemWithValue:value color:colors[i] description:names[i]]];
    }
    
    return items;
}

// 设置pieChart 属性
- (void) setPNPieChart:(PNPieChart *) pieChart {
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    pieChart.descriptionTextShadowColor = [UIColor clearColor];
    pieChart.showAbsoluteValues = NO;
    pieChart.hideValuesAndNames = YES;
    pieChart.innerCircleRadius = 105 / 3;
    pieChart.isShowHalo = NO;
    pieChart.displayAnimated = NO;
    [pieChart strokeChart];
}

// legend
- (UIView *) legendFromPNPieChart:(PNPieChart *) pieChart {
    // legend
    pieChart.legendStyle = PNLegendItemStyleSerial;
    pieChart.legendFont = [UIFont systemFontOfSize:14.0f];
    pieChart.legendFontColor = UIColorFromRGB(0x9e9e9e);
    
    UIView *legend = [pieChart getLegendWithMaxWidth:pieChart.frame.size.width];
    return legend;
}

@end
