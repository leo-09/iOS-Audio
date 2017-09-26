//
//  CarInspectStationInfoViewController.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarInspectStationModel.h"
#import "CTXBaseViewController.h"
#import "BoundCarModel.h"

/**
 车检站详情
 */
@interface CarInspectStationInfoViewController : CTXBaseViewController

@property (nonatomic , retain)CarInspectStationModel * stationModel;
@property (nonatomic, retain) BoundCarModel *carModel;

@end
