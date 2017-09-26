//
//  AddOrderRoadViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/5.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"
#import "OrderRoadModel.h"
#import "CoreServeNetData.h"

/**
 定制路况的 编辑 ／ 添加
 */
@interface AddOrderRoadViewController : CTXBaseTableViewController {
    BOOL isAddOrderRoad;
}

@property (nonatomic, retain) CoreServeNetData *coreServeNetData;

@property (nonatomic, retain) OrderRoadModel *model;

@property (weak, nonatomic) IBOutlet UILabel *startAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *stopAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *sureLabel;

- (instancetype) initWithStoryboard;

@end
