//
//  CarInspectTimeView.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"

@interface CarInspectTimeView : CTXBaseView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic ,retain) UITableView * tableView;
@property (nonatomic, copy) ClickListener backListener;
@property (nonatomic, copy) SelectCellModelListener searchListener;
@property (nonatomic, copy) ClickListener clearRecordListener;
@property (nonatomic, copy) SelectCellModelListener selectStationCellListener;

- (void) refreshDataSource:(NSArray *)data;
- (instancetype)initWithFrame:(CGRect)frame arr:(NSArray *)arr;

@end
