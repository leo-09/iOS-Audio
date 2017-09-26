//
//  CarInspectAgencyStationInfoViewController.h
//  AcrossAnHui
//
//  Created by ztd on 2017/8/2.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarInspectStationModel.h"
#import "CTXBaseViewController.h"
#import "BoundCarModel.h"

/**
 车检代办  车检站详情
 */
@interface CarInspectAgencyStationInfoViewController : CTXBaseViewController

@property (nonatomic , retain)CarInspectStationModel * stationModel;
@property (nonatomic, retain) BoundCarModel *carModel;
@property (nonatomic,assign)double latStr;
@property (nonatomic,assign)double lngStr;
@property (nonatomic, copy) NSString *addressStr;

@end
