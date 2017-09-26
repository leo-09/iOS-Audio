//
//  StationOrderTime.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "StationOrderTime.h"

@implementation StationOrderTime

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [StationOrderTime modelWithDictionary:dict];
}

@end
