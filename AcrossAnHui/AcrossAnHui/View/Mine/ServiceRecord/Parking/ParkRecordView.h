//
//  ParkRecordView.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkRecordModel.h"
#import "CTXBaseView.h"

@interface ParkRecordView : CTXBaseView {
    void (^selectCellListener)(ParkRecordModel * model);
    void (^freshListener)();
    void (^refreshListener)();
}

@property (retain, nonatomic)ParkRecordModel * model;
@property (nonatomic, copy) RefreshDataListener refreshParkingRecordDataListener;

- (void) setSelectCellListener:(void (^)(ParkRecordModel * model))listener;
- (void) setFreshListener:(void (^)())listener;//上拉加载
- (void) setRefreshListener:(void (^)())listener;//下拉刷新

-(void)refreshData:(NSArray *)dataArr;
-(void)cancelRefresh;
-(void)removeFoodView;

@end
