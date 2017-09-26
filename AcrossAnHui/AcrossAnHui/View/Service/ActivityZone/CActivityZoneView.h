//
//  CActivityZoneView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/24.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "PromptView.h"

/**
 活动专区 view
 */
@interface CActivityZoneView : CTXBaseView<UITableViewDelegate, UITableViewDataSource> {
    PromptView *promptView;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataSource;

@property (nonatomic, copy) SelectCellModelListener selectActivityCellListener;
@property (nonatomic, copy) RefreshDataListener refreshActivityDataListener;
@property (nonatomic, copy) LoadDataListener loadActivityDataListener;

- (void) hideFooter;
- (void) endRefreshing;
- (void) removeFooter;
- (void) addFooter;

/**
 第一次加载数据

 @param data 第一页数据
 */
- (void) refreshDataSource:(NSArray *)data;

/**
 加载数据
 
 @param data 分页数据
 @param page 当前页码
 */
- (void) addDataSource:(NSArray *)data page:(int) page;

@end
