//
//  CConsumeRecordView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "PromptView.h"
#import "ConsumeRecordModel.h"

/**
 消费记录View
 */
@interface CConsumeRecordView : CTXBaseView<UITableViewDelegate, UITableViewDataSource> {
    PromptView *promptView;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray<ConsumeRecordCollection *> *dataSource;

@property (nonatomic, copy) RefreshDataListener refreshRecordDataListener;
@property (nonatomic, copy) LoadDataListener loadRecordDataListener;

- (void) hideFooter;
- (void) endRefreshing;
- (void) removeFooter;
- (void) addFooter;

- (void) addDataSource:(NSArray<ConsumeRecordModel *> *)records;
- (void) refreshDataSource:(NSArray<ConsumeRecordModel *> *)records;

@end
