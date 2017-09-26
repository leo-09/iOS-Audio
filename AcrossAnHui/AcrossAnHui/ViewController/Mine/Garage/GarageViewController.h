//
//  GarageViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import "BoundCarModel.h"

/**
 我的车库
 */
@interface GarageViewController : CTXBaseViewController

@property (nonatomic, retain) NSMutableArray<BoundCarModel *> *dataSource;
@property (nonatomic, retain) NSMutableArray<BoundCarModel *> *parkingCars;

@end
