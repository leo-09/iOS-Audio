//
//  ParkingAreaModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ParkingAreaModel.h"

@implementation ParkingAreaModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    ParkingAreaModel *model = [ParkingAreaModel modelWithDictionary:dict];
    model.siteList = [ParkingRoadModel convertFromArray:model.siteList];
    
    return model;
}

@end
