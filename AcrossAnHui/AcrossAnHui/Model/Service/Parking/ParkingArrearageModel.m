//
//  ParkingArrearageModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ParkingArrearageModel.h"

@implementation ArrearageInfoModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    ArrearageInfoModel *model = [ArrearageInfoModel modelWithDictionary:dict];
    
    return model;
}


@end

@implementation ParkingArrearageModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    ParkingArrearageModel *model = [ParkingArrearageModel modelWithDictionary:dict];
    
    model.odueList = [ArrearageInfoModel convertFromArray:model.odueList];
    
    return model;
}

@end
