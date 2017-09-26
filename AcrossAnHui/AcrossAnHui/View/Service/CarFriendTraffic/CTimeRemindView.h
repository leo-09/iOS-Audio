//
//  CTimeRemindView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/5.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "PromptView.h"

/**
  时间提醒 (定制路况) View
 */
@interface CTimeRemindView : CTXBaseView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) PromptView *promptView;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataSource;

@property (nonatomic, copy) ClickListener refreshRoadInfoCellListener;
@property (nonatomic, copy) ClickListener addRoadInfoCellListener;
@property (nonatomic, copy) SelectCellModelListener showRoadInfoCellListener;
@property (nonatomic, copy) SelectCellModelListener editRoadInfoCellListener;
@property (nonatomic, copy) SelectCellModelListener deleteRoadInfoCellListener;

- (void) refreshDataSource:(NSArray *)data;

@end
