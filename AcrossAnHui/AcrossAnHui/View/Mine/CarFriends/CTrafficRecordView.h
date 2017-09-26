//
//  CTrafficRecordView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "PromptView.h"

@class CarFriendCardModel;

/**
 随手拍 路况记录View
 */
@interface CTrafficRecordView : CTXBaseView<UITableViewDelegate, UITableViewDataSource> {
    PromptView *promptView;
    int countPerPage;// 每页的个数
}

@property (nonatomic, retain) UILabel *totalLabel;      // 本月上报
@property (nonatomic, retain) UILabel *usedLabel;       // 已采用
@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *dataSource;

@property (nonatomic, copy) RefreshDataListener refreshNewsInfoDataListener;
@property (nonatomic, copy) LoadDataListener loadNewsInfoDataListener;

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

// 本月上报 已采用
- (void) setTotalRecords:(NSString *)totalRecords usedCount:(NSString *)usedCount;

@end
