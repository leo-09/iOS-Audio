//
//  CarInspectStationMapListViewController.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTXBaseViewController.h"

/**
 车检预约  车检站地图
 */
@interface CarInspectStationMapListViewController : CTXBaseViewController

@property (nonatomic,strong)NSMutableArray *stationListArray;
@property (nonatomic,assign)NSInteger  value;

@end
