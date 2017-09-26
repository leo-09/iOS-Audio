//
//  CSubmitRecordView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "PromptView.h"

/**
 提交记录 View
 */
@interface CSubmitRecordView : CTXBaseView<UITableViewDataSource> {
    PromptView *promptView;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataSource;

@property (nonatomic, copy) RefreshDataListener refreshSubmitRecordDataListener;
@property (nonatomic, copy) LoadDataListener loadSubmitRecordDataListener;

- (void) hideFooter;
- (void) endRefreshing;
- (void) removeFooter;
- (void) addFooter;

- (void) addDataSource:(NSArray *)data;
- (void) refreshDataSource:(NSArray *)data;

@end
