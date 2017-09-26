//
//  CarInspectLogistics.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/21.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectLogistics.h"

@implementation CarInspectLogistics

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [CarInspectLogistics modelWithDictionary:dict];
}

@end
