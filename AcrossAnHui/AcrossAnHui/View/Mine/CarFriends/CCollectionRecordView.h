//
//  CCollectionRecordView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "PromptView.h"

@class CarFriendCardModel;

/**
 随手拍 收藏记录View
 */
@interface CCollectionRecordView : CTXBaseView<UITableViewDelegate, UITableViewDataSource> {
    PromptView *promptView;
    int countPerPage;// 每页的个数
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataSource;

@property (nonatomic, copy) RefreshDataListener refreshNewsInfoDataListener;
@property (nonatomic, copy) LoadDataListener loadNewsInfoDataListener;
@property (nonatomic, copy) SelectCellModelListener showCarFriendInfoListener;
@property (nonatomic, copy) SelectCellModelListener deleteTopicListener;

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

// 从帖子详情页回来，更新话题内容
- (void) updateSelectModel:(CarFriendCardModel *)model;
// 删除话题后，更新TableView
- (void) updateDeleteModel;

@end
