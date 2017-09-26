//
//  ParkingBalanceModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/24.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ParkingBalanceModel.h"

@implementation ParkingBalanceModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [ParkingBalanceModel modelWithDictionary:dict];
}

@end
