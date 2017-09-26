//
//  CSelectBindedCarView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "CarIllegalInfoModel.h"

/**
 选择车辆 进行 六年免检、车检代办、车检预约 View
 */
@interface CSelectBindedCarView : CTXBaseView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSArray<CarIllegalInfoModel *> *carIllegals;

@property (nonatomic, copy) ClickListener submitCarInfoListener;
@property (nonatomic, copy) SelectCellModelListener selectCarCellListener;

@end
