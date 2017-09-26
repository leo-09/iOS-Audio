//
//  CInvoiceRecordView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "PromptView.h"

/**
 发票申请记录View
 */
@interface CInvoiceRecordView : CTXBaseView<UITableViewDelegate, UITableViewDataSource> {
    PromptView *promptView;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIView *bottomView;
@property (nonatomic, retain) UIButton *deleteBtn;
@property (nonatomic, retain) UIButton *cancelBtn;

@property (nonatomic, retain) NSMutableArray *dataSource;

@property (nonatomic, copy) RefreshDataListener refreshParkDataListener;
@property (nonatomic, copy) LoadDataListener loadParkDataListener;
@property (nonatomic, copy) LoadDataListener cancelListener;
@property (nonatomic, copy) SelectCellModelListener deleteRecordDataListener;

- (void) hideFooter;
- (void) endRefreshing;
- (void) removeFooter;
- (void) addFooter;

- (void) addDataSource:(NSArray *)data;
- (void) refreshDataSource:(NSArray *)data;

// 全选
- (void) selectAllRecord;

// 编辑状态
- (void) showEditStatus;

@end
