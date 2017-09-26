//
//  CarInspectAgencyRecordModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/16.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectAgencyRecordModel.h"

@implementation CarInspectAgencyRecordModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [CarInspectAgencyRecordModel modelWithDictionary:dict];
}

@end
