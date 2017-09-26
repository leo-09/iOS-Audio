//
//  CarInspectLogisticsInfo.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/21.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectLogisticsInfo.h"

@implementation CarInspectLogisticsInfo

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [CarInspectLogisticsInfo modelWithDictionary:dict];
}

// 1-顺丰2-EMS
- (NSString *)typeName {
    if ([_type isEqualToString:@"2"]) {
        return @"EMS";
    } else {
        return @"顺丰";
    }
}

@end
