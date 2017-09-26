//
//  CFriendListView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "PromptView.h"

/**
 好友列表View
 */
@interface CFriendListView : CTXBaseView<UITableViewDelegate, UITableViewDataSource> {
    PromptView *promptView;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataSource;

@property (nonatomic, copy) RefreshDataListener refreshFriendDataListener;
@property (nonatomic, copy) LoadDataListener loadFriendDataListener;

- (void) hideFooter;
- (void) endRefreshing;
- (void) removeFooter;
- (void) addFooter;

- (void) addDataSource:(NSArray *)data;
- (void) refreshDataSource:(NSArray *)data;

@end
