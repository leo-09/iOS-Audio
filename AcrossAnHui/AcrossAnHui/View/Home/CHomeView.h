//
//  CHomeView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "SDCycleScrollView.h"
#import "AdvertisementModel.h"
#import "NewsInfoModel.h"
#import "CarIllegalInfoModel.h"
#import "ServeModel.h"
#import "CHomeCarCell.h"

@interface CHomeView : CTXBaseView<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) SDCycleScrollView *cycleScrollView;

// headView轮播图的数据
@property (nonatomic, retain) NSArray<AdvertisementModel *> *advertisements;

// 第1个cell的数据
@property (nonatomic, retain) NSArray<CarIllegalInfoModel *> *carIllegals;
// 第2个cell的数据
@property (nonatomic, retain) NSArray<ServeModel *> *serveModels;
// 第3个cell的数据
// 剩余的cell的数据
@property (nonatomic, retain) NSArray<NewsInfoModel *> *newsInfos;

@property (nonatomic, assign) BOOL isNewsInfoModelCorrect;

@property (nonatomic, copy) RefreshDataListener refreshHomeDataListener;        // 刷新
@property (nonatomic, copy) SelectCellModelListener clickADVListener;           // 点击广告
@property (nonatomic, copy) SelectCellModelListener selectCarListener;          // 点击汽车
@property (nonatomic, copy) SelectCellModelListener selectServeListener;        // 点击服务
@property (nonatomic, copy) ClickListener moreNewsInfoClickListener;            // 查看更多
@property (nonatomic, copy) SelectCellModelListener selectNewsInfoCellListener; // 点击新闻

- (void) endRefreshing;

@end
