//
//  CParkingView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "SDCycleScrollView.h"
#import "SelectView.h"
#import "OrdeDialogView.h"
#import "ParkingHomeModel.h"
#import "ParkingCarModel.h"
#import "AdvertisementModel.h"

/**
 停车服务首页View
 */
@interface CParkingView : CTXBaseView<SDCycleScrollViewDelegate, UIScrollViewDelegate> {
    BOOL isShowOrdeDialogView;  // 只提示一次欠费补缴
}

@property (weak, nonatomic) IBOutlet SelectView *searchView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cycleViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *carScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet SelectView *rechargeView;
@property (weak, nonatomic) IBOutlet SelectView *parkRecordView;
@property (weak, nonatomic) IBOutlet SelectView *arrearageView;
@property (weak, nonatomic) IBOutlet SelectView *notiView;
@property (weak, nonatomic) IBOutlet UIImageView *arrearageImageView;

@property (weak, nonatomic) IBOutlet UIView *descView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (nonatomic, retain) OrdeDialogView *ordeDialogView;

@property (nonatomic, retain) NSArray<AdvertisementModel *> *advArray;
@property (nonatomic, retain) ParkingHomeModel *model;
@property (nonatomic, retain) ParkingCarModel *currentCarModel;

@property (nonatomic, copy) ClickListener backListener;
@property (nonatomic, copy) ClickListener toGarageViewListener;                     // 去车库
@property (nonatomic, copy) ClickListener showParkingStandardListener;              // 收费标准
@property (nonatomic, copy) ClickListener selectPackinfoByCardListener;             // 当时整五分钟的时候，重新请求停车数据
@property (nonatomic, copy) ClickListener startCountDownManagerListener;            // 开启定时器
@property (nonatomic, copy) SelectCellModelListener toParkingRecordViewListener;    // 停车记录
@property (nonatomic, copy) ClickListener toSearchParkingViewListener;              // 搜索界面
@property (nonatomic, copy) ClickListener toRechargeViewListenern;                  // 充值
@property (nonatomic, copy) ClickListener toArrearageViewListener;                  // 欠费补缴
@property (nonatomic, copy) SelectCellModelListener noticeManagerListener;          // 通知收费员
@property (nonatomic, copy) ClickListener toScanCodeViewListener;                   // 扫码支付
@property (nonatomic, copy) ClickListener toParkingMapViewListener;                 // 去停车
@property (nonatomic, copy) SelectCellModelListener toAdvertisementListener;        // 轮播图

// 初始化
- (instancetype) initWithMyFrame:(CGRect)frame;

@end
