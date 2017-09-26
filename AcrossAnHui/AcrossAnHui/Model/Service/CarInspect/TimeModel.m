//
//  TimeModel.m
//  AcrossAnHui
//
//  Created by ztd on 17/6/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "TimeModel.h"

@implementation MinuteModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [MinuteModel modelWithDictionary:dict];
}

@end


@implementation TimeModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    TimeModel *model = [TimeModel modelWithDictionary:dict];
    model.time = [MinuteModel convertFromArray:model.time];
    
    return model;
}

@end
