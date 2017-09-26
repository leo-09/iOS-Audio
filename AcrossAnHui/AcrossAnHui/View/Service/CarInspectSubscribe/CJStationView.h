//
//  CJStationView.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/3.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarInspectStationModel.h"
#import "CTXBaseView.h"
#import "PromptView.h"
#import "CTXRefreshGifHeader.h"
#import "CTXRefreshGifFooter.h"

@interface CJStationView : CTXBaseView{
    UILabel * currentAddressLab;
    void (^stationListener)(NSInteger value);
    PromptView *promptView;
    void (^refreshListener)(NSString *areaID,NSInteger value);
    
    int countPerPage;// 每页的个数
}

@property(nonatomic,retain)NSString * citystring;
@property(nonatomic,retain)NSString * province;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *stationArray;
@property (nonatomic, retain) NSMutableArray *dataSource;

@property (nonatomic, copy) SelectCellModelListener selectStationCellListener;
@property (nonatomic, copy) RefreshDataListener refreshStationListener;
@property (nonatomic, copy) LoadDataListener loadStationListener;
@property (nonatomic, copy) SelectCellModelListener selectAreaListener;

- (instancetype)initWithFrame:(CGRect)frame WithCity:(NSString *)cityStr WithProvince:(NSString *)provinceStr WithAddress:(NSString *)currentAddress;

- (void) setRefreshListener:(void (^)(NSString *areaID,NSInteger value))listener;
- (void) setStationListener:(void (^)(NSInteger value))listener;

- (void) hideFooter;
- (void) removeFooter;
- (void) addFooter;
- (void) endRefreshing;

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
