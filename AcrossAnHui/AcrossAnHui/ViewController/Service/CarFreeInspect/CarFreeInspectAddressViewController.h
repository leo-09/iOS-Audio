//
//  CarFreeInspectAddressViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/28.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import "AreaModel.h"

/**
 选择地址
 */
@interface CarFreeInspectAddressViewController : CTXBaseViewController

@property (nonatomic, retain) CarFreeInspectAddressModel *model;
@property (nonatomic, copy) NSString *fetchAddress;  // 取件地址／收件地址

@end
