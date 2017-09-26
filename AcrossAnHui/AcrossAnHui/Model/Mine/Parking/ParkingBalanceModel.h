//
//  ParkingBalanceModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/24.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 停车帐号的余额
 */
@interface ParkingBalanceModel : CTXBaseModel

@property (nonatomic, assign) BOOL isDel;       // 是否删除用户数据，删除0-否1-是
@property (nonatomic, assign) BOOL payType;     // 支付类型自动支付状态0-关闭1-开启
@property (nonatomic, assign) double ubalance;  // 用户余额
@property (nonatomic, copy) NSString *userid;   // 用户id

@end
