//
//  CCarInspectLogisticsView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/21.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "PromptView.h"
#import "CarInspectLogisticsInfo.h"

/**
 申请6年免检记录的物流 View
 */
@interface CCarInspectLogisticsView : CTXBaseView<UITableViewDelegate, UITableViewDataSource> {
    PromptView *promptView;
}

@property (nonatomic, retain) UIView *topView;                  // 寄往车检站 寄回用户
@property (nonatomic, retain) UIButton *stationBtn;
@property (nonatomic, retain) UIButton *userBtn;
@property (nonatomic, retain) UIView *infoView;                 // 物流信息
@property (nonatomic, retain) UILabel *nameLabel;               // 承运物流
@property (nonatomic, retain) UILabel *busCodeLabel;            // 订单编号
@property (nonatomic, retain) UILabel *phoneLabel;              // 官方电话
@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *dataSource;

@property (nonatomic, copy) RefreshDataListener refreshDataListener;
@property (nonatomic, copy) SelectCellListener logisticsListener;

- (void) endRefreshing;
- (void) refreshDataSource:(NSArray *)data;

- (void) setCarInspectLogisticsInfo:(CarInspectLogisticsInfo *)model;

@end
