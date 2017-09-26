//
//  ParkingHomeModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ParkingHomeModel.h"

@implementation ParkingHomeModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    ParkingHomeModel *model = [ParkingHomeModel modelWithDictionary:dict];
    model.carList = [ParkingCarModel convertFromArray:model.carList];
    
    return model;
}

@end
