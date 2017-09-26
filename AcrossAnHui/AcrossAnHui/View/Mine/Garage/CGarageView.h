//
//  CGarageView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/14.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "PromptView.h"
#import "BoundCarModel.h"
#import "CGarageAddCarView.h"

/**
 我的车库 View
 */
@interface CGarageView : CTXBaseView<UITableViewDelegate, UITableViewDataSource> {
    PromptView *promptView;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIView *footerView;
@property (nonatomic, retain) NSMutableArray<BoundCarModel *> *dataSource;

// 设为默认车辆／删除的view
@property (nonatomic, retain) UIView *bottomView;
@property (nonatomic, retain) UIButton *defaultCarBtn;
@property (nonatomic, retain) UIButton *deleteCarBtn;
@property (nonatomic, retain) CGarageAddCarView *addCarView;

@property (nonatomic, copy) RefreshDataListener refreshCarDataListener;     // 网络错误时的 刷新
@property (nonatomic, copy) ClickListener bindCarListener;                  // 绑定车辆
@property (nonatomic, copy) ClickListener bindOrDeleteCarListener;          // 绑定／删除车辆
@property (nonatomic, copy) SelectCellModelListener editCarListener;        // 编辑车辆
@property (nonatomic, copy) SelectCellModelListener deleteCarListener;      // 删除车辆
@property (nonatomic, copy) SelectCellModelListener parkingCarListener;     // 设为停车服务的车辆
@property (nonatomic, copy) SelectCellModelListener defaultCarListener;     // 设为默认车辆

- (void) refreshDataSource:(NSArray *)data;

- (void) showBottomView;
- (void) hideBottomView;

@end
