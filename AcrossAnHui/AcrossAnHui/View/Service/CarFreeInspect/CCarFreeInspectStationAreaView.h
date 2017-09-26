//
//  CCarFreeInspectStationAreaView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/29.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "AreaModel.h"

/**
 选择车检站View 的地区选择
 */
@interface CCarFreeInspectStationAreaView : CTXBaseView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) TownModel *townModel;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, copy) SelectCellModelListener selectAreaCellListener;

@end
