//
//  CIllegalQueryView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "CarIllegalInfoModel.h"
#import "PromptView.h"

/**
 违章查询 View
 */
@interface CIllegalQueryView : CTXBaseView<UITableViewDelegate, UITableViewDataSource> {
    PromptView *promptView;
}

@property (nonatomic, retain) NSMutableArray<CarIllegalInfoModel *> *dataSource;
@property (nonatomic, assign) int currentIndex;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, copy) SelectCellModelListener selectCarIllegalInfoCellListener;
@property (nonatomic, copy) RefreshDataListener refreshCarIllegalInfoDataListener;
@property (nonatomic, copy) ClickListener bindCarListener;
@property (nonatomic, copy) SelectCellModelListener editCarListener;
@property (nonatomic, copy) SelectCellModelListener showIllegalListListener;        // 历史违章

/**
 编辑此车

 @param note 备注
 @param name 车型名字
 @param carType 车型类型
 */
- (void) setEditCarNote:(NSString *)note name:(NSString *)name carType:(NSString *)carType;

/**
 设置滑动的index

 @param index index
 */
- (void) setSelectedIndex:(int)index;

/**
 数据源

 @param dataSource 数据源
 @param index index
 */
- (void) setDataSource:(NSArray<CarIllegalInfoModel *> *)dataSource selectedIndex:(int)index;

@end
