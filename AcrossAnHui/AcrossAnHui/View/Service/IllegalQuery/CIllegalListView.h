//
//  CIllegalListView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "CarIllegalInfoModel.h"
#import "PromptView.h"

/**
 违章信息列表View
 */
@interface CIllegalListView : CTXBaseView<UITableViewDelegate, UITableViewDataSource> {
    PromptView *promptView;
}

@property (nonatomic, retain) CarIllegalInfoModel *model;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, copy) SelectCellModelListener selectCarIllegalInfoCellListener;

@end
