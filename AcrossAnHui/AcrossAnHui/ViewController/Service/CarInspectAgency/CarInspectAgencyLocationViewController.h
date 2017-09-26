//
//  CarInspectAgencyLocationViewController.h
//  AcrossAnHui
//
//  Created by ztd on 2017/8/2.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTXBaseViewController.h"

typedef void(^CallBackBlcok) (NSString *text,NSString *lat,NSString *lng);

/**
 车检代办  选取地图位置
 */
@interface CarInspectAgencyLocationViewController : CTXBaseViewController

@property (nonatomic, copy) NSString               *currentAddress;
@property (nonatomic, copy) NSString               *city;
@property (nonatomic,copy)CallBackBlcok callBackBlock;//2

@end
