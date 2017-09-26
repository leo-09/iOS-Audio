//
//  CarInspectStationDetailView.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarInspectStationModel.h"
#import "CTXBaseView.h"

@interface CarInspectStationDetailView : CTXBaseView{
    void (^stationListener)(NSInteger value);
    void (^stationLocationListener)(id value);
}

@property(nonatomic,retain)UITableView * tableView;

@property (nonatomic, copy) SelectCellModelListener selectStationCellListener;
@property (nonatomic, copy) RefreshDataListener refreshStationListener;
@property (nonatomic, copy) LoadDataListener loadStationListener;
@property (nonatomic, copy) SelectCellModelListener selectAreaListener;

- (instancetype)initWithFrame:(CGRect)frame WithModel:(CarInspectStationModel *)model viewValue:(int)value;//value==1 车检预约  2 车检代办
- (void) setStationListener:(void (^)(NSInteger value))listener;//定义 value=1，点击车检站图片 2 查看更多 3：车检站地图
- (void) refreshDataSource:(NSArray *)data;
-(void) sertstationLocationListener:(void (^)(id value))listener;

@end
