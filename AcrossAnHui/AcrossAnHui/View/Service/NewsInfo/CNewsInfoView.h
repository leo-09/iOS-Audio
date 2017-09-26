//
//  CNewsInfoView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "PromptView.h"

/**
 新闻资讯 View
 */
@interface CNewsInfoView : CTXBaseView<UITableViewDelegate, UITableViewDataSource> {
    PromptView *promptView;
    int countPerPage;// 每页的个数
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataSource;

@property (nonatomic, copy) SelectCellModelListener selectNewsInfoCellListener;
@property (nonatomic, copy) RefreshDataListener refreshNewsInfoDataListener;
@property (nonatomic, copy) LoadDataListener loadNewsInfoDataListener;

- (void) hideFooter;
- (void) endRefreshing;
- (void) removeFooter;
- (void) addFooter;

/**
 第一次加载数据
 
 @param data 第一页数据
 @param nilDataTint 空数据的提示
 */
- (void) refreshDataSource:(NSArray *)data nilDataTint:(NSString *)nilDataTint;

/**
 加载数据

 @param data 分页数据
 @param page 当前页码
 */
- (void) addDataSource:(NSArray *)data page:(int) page;

@end
