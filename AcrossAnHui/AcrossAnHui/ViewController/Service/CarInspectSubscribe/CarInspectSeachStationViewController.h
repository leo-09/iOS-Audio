//
//  CarInspectSeachStationViewController.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTXBaseViewController.h"
#import "CJStationInfoView.h"
#import "BoundCarModel.h"

/**
 搜索车检站界面
 */
@interface CarInspectSeachStationViewController : CTXBaseViewController

@property (nonatomic, retain) BoundCarModel *carModel;

@property (nonatomic, retain) CJStationInfoView *searchNewsInfoView;

@property (nonatomic , retain)NSString * areaID;

@end
