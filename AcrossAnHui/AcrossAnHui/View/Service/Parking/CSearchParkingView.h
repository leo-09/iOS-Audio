//
//  CSearchParkingView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "PromptView.h"

/**
 搜索停车位View
 */
@interface CSearchParkingView : CTXBaseView<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    PromptView *promptView;
}

@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataSource;

@property (nonatomic, copy) LoadDataListener backListener;
@property (nonatomic, copy) SelectCellModelListener searchSiteListener;
@property (nonatomic, copy) RefreshDataListener refreshParkDataListener;
@property (nonatomic, copy) LoadDataListener loadParkDataListener;
@property (nonatomic, copy) SelectCellModelListener selectListener;
@property (nonatomic, copy) LoadDataListener cleanRecordListener;

- (void) hideFooter;
- (void) endRefreshing;
- (void) removeFooter;
- (void) addFooter;

/**
 第一次加载数据

 @param data 第一页数据
 @param isRecord 是否是记录的数据
 */
- (void) refreshDataSource:(NSArray *)data isRecord:(BOOL) isRecord;

// 加载数据
- (void) addDataSource:(NSArray *)data;

@end
