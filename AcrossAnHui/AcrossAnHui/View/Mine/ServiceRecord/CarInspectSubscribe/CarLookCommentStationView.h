//
//  CCarLookCommentStationView.h
//  AcrossAnHui
//
//  Created by ztd on 2017/8/10.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "StationCommentModel.h"

@interface CarLookCommentStationView : CTXBaseView{
    void (^freshListener)();
    void (^refreshListener)();
}

@property (nonatomic ,strong)SelectCellListener selectBtnListener;
@property (nonatomic, copy) RefreshDataListener refreshParkingRecordDataListener;

- (void) setFreshListener:(void (^)())listener;//上拉加载
- (void) setRefreshListener:(void (^)())listener;//下拉刷新
-(void)refreshData:(NSArray *)dataArr;
-(void)cancelRefresh;
-(void)refreshCommentTotal:(NSString *)allTotal photoTotal:(NSString *)photoTotal badTotal:(NSString *)badTotal;

@end
