//
//  ParkingRoadModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ParkingRoadModel.h"

@implementation ParkingRoadModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"roadID" : @"id" };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    ParkingRoadModel *model = [ParkingRoadModel modelWithDictionary:dict];
    
    return model;
}

@end
