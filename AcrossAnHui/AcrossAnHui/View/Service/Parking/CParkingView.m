//
//  CParkingView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CParkingView.h"
#import "CParkingCarView.h"

@implementation CParkingView

- (instancetype) initWithMyFrame:(CGRect)frame {
    NSArray* nibArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self = [nibArray objectAtIndex:0];
    if (self) {
        self.frame = frame;
        
        isShowOrdeDialogView = NO;
        // cycleScrollView
        _cycleScrollView.delegate = self;
        
        // cycleScrollView
        _cycleScrollView.delegate = self;
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"banner_b"];
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView.pageControlDotSize = CGSizeMake(6, 6);
        _cycleScrollView.currentPageDotColor = UIColorFromRGB(0xFFFFFF);
        _cycleScrollView.pageDotColor = UIColorFromRGB(CTXBackGroundColor);
        _cycleScrollView.autoScrollTimeInterval = 5.0f;
        _cycleScrollView.backgroundColor = CTXColor(244, 244, 244);
        
        CGFloat cycleViewHeight = CTXScreenWidth * 189.0 / 375.0;
        self.cycleViewHeightConstraint.constant = cycleViewHeight;
        self.contentViewHeightConstraint.constant = 471 + cycleViewHeight;
        
        CTXViewBorderRadius(_searchView, 4.0, 0, [UIColor clearColor]);
        CTXViewBorderRadius(_rechargeView, 3.0, 0, [UIColor clearColor]);
        CTXViewBorderRadius(_parkRecordView, 3.0, 0, [UIColor clearColor]);
        CTXViewBorderRadius(_arrearageView, 3.0, 0, [UIColor clearColor]);
        CTXViewBorderRadius(_notiView, 3.0, 0, [UIColor clearColor]);
        CTXViewBorderRadius(_descView, 5.0, 0, [UIColor clearColor]);
        self.arrearageImageView.hidden = YES;
        
        _carScrollView.delegate = self;
        [self addCycleScrollViewContent];
        [self setEventResponse];
    }
    return self;
}

#pragma mark - addView

- (void) addCycleScrollViewContent {
    [_carScrollView removeAllSubviews];
    
    // 首次进入还没有数据，可这是默认值
    if (!self.model) {
        self.model = [[ParkingHomeModel alloc] init];
        self.model.packfree = @"0";
        self.model.carList = [[NSMutableArray alloc] init];
    }
    
    if (self.model.carList.count < 3) {
        // 如果停车车辆少于3个，可以显示 添加停车 按钮
        ParkingCarModel *model = [[ParkingCarModel alloc] init];
        [self.model.carList addObject:model];
    }
    
    // 默认第一个
    self.currentCarModel = self.model.carList.firstObject;
    
    // pageControl
    _pageControl.numberOfPages = self.model.carList.count;
    _pageControl.pageIndicatorTintColor = UIColorFromRGB(CTXBaseFontColor);
    _pageControl.currentPageIndicatorTintColor = UIColorFromRGB(CTXThemeColor);
    
    CGFloat x = 0;
    for (int i = 0; i < self.model.carList.count; i++) {
        ParkingCarModel *model = self.model.carList[i];
        
        // 如果有车正在停车，则启动倒计时管理
        if (model.isbusy) {
            if (self.startCountDownManagerListener) {
                self.startCountDownManagerListener();
            }
        }
        
        CGRect frame = CGRectMake(x, 0, CTXScreenWidth, 150);
        CParkingCarView *view = [[CParkingCarView alloc] initWithFrame:frame];
        view.model = model;
        
        [view setAddCarListener:^ {
            if (self.toGarageViewListener) {
                self.toGarageViewListener();
            }
        }];
        
        [view setShowParkingStandardListener:^ {
            // 停车收费标准
            if (self.showParkingStandardListener) {
                self.showParkingStandardListener();
            }
        }];
        
        // 当时整五分钟的时候，重新请求停车数据
        [view setQueryParkingDataListener:^ {
            if (self.selectPackinfoByCardListener) {
                self.selectPackinfoByCardListener();
            }
        }];
        
        [_carScrollView addSubview:view];
        
        x += _carScrollView.frame.size.width;
    }
    
    _carScrollView.showsHorizontalScrollIndicator = NO;
    _carScrollView.pagingEnabled = YES;
    _carScrollView.contentSize = CGSizeMake(CTXScreenWidth * self.model.carList.count, 150);
}

// 显示欠费提醒
- (void) showOdueView {
    if (isShowOrdeDialogView) { // 只提示一次欠费补缴
        return;
    }
    
    if (self.model.totalOdue > 0) {
        NSString *content = [NSString stringWithFormat:@"您有%d单停车未缴费记录，请及时缴费，以免影响个人征信。", self.model.totalOdue];
        
        if (!self.ordeDialogView) {
            self.ordeDialogView = [[OrdeDialogView alloc] init];
            [self.ordeDialogView setTitle:@"未缴费提醒" content:content];
            [self.ordeDialogView setLeftBtnTitle:@"去缴费" rightBtnTitle:@"稍后再说"];
            
            @weakify(self)
            [self.ordeDialogView setBtnListener:^ {
                @strongify(self)
                
                if (self.toParkingRecordViewListener) {
                    self.toParkingRecordViewListener(@"");
                }
            }];
        }
        
        isShowOrdeDialogView = YES;
        [self.ordeDialogView showView];
    }
}

#pragma mark - public method

- (void) setModel:(ParkingHomeModel *)model {
    _model = model;
    
    // 添加车辆信息
    [self addCycleScrollViewContent];
    
    // 设置剩余停车位
    NSString *packfree = (self.model.packfree ? self.model.packfree : @"0");
    self.descLabel.text = [NSString stringWithFormat:@"附近停车位剩余%@位,去停车", packfree];
    
    // 欠费的标示
    if (self.model.isOdue) {
        self.arrearageImageView.hidden = NO;
    } else {
        self.arrearageImageView.hidden = YES;
    }
    
    [self showOdueView];
}

- (void) setAdvArray:(NSArray<AdvertisementModel *> *)advArray {
    _advArray = advArray;
    
    // 取出图片路径
    NSMutableArray *imagePaths = [[NSMutableArray alloc] init];
    for (AdvertisementModel *model in _advArray) {
        [imagePaths addObject:model.img];
    }
    
    self.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.cycleScrollView.imageURLStringsGroup = imagePaths;
}

#pragma mark - event response

- (void) setEventResponse {
    // 搜索
    [_searchView setDefaultColor:0xB0BAD2];
    [_searchView setSelectColor:0xB0BAD2];
    
    @weakify(self)
    [_searchView setClickListener:^(id sender) {
        @strongify(self)
        
        if (self.toSearchParkingViewListener) {
            self.toSearchParkingViewListener();
        }
    }];
    
    // 帐号充值
    [_rechargeView setClickListener:^(id sender) {
        @strongify(self)
        
        if (self.toRechargeViewListenern) {
            self.toRechargeViewListenern();
        }
    }];
    
    // 停车服务记录
    [_parkRecordView setClickListener:^(id sender) {
        @strongify(self)
        
        if (self.toParkingRecordViewListener) {
            self.toParkingRecordViewListener(nil);
        }
    }];
    
    // 欠费补缴
    [_arrearageView setClickListener:^(id sender) {
        @strongify(self)
        
        if (self.toArrearageViewListener) {
            self.toArrearageViewListener();
        }
    }];
    
    // 通知收费员
    [_notiView setClickListener:^(id sender) {
        @strongify(self)
        
        if (self.noticeManagerListener) {
            self.noticeManagerListener(self.currentCarModel.siteId);
        }
    }];
}

// 返回
- (IBAction)back:(id)sender {
    if (self.backListener) {
        self.backListener();
    }
}

// 扫码支付
- (IBAction)scanCode:(id)sender {
    if (self.toScanCodeViewListener) {
        self.toScanCodeViewListener();
    }
}

// 去停车
- (IBAction)toPark:(id)sender {
    if (self.toParkingMapViewListener) {
        self.toParkingMapViewListener();
    }
}

#pragma mark - SDCycleScrollViewDelegate

// 点击图片回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    // 显示轮播图
    if (index < self.advArray.count) {
        AdvertisementModel * model = self.advArray[index];
        
        if (self.toAdvertisementListener) {
            self.toAdvertisementListener(model);
        }
    }
}

#pragma mark - UIScrollViewDelegate

// 在一次拖动滑动中最后被调用，在scrollViewDidScroll之后
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.carScrollView) {
        // carScrollView的滚动距离
        
        CGPoint point = scrollView.contentOffset;
        int currentIndex = point.x / scrollView.frame.size.width;;
        _pageControl.currentPage = currentIndex;
        
        if (self.model.carList.count > currentIndex) {
            _currentCarModel = self.model.carList[currentIndex];
        } else {
            _currentCarModel = nil;
        }
    }
}

@end
