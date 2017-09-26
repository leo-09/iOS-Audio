//
//  ParkRecordModel.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/14.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ParkRecordModel.h"

@implementation ParkRecordModel
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"carid" : @"id"
              };
}
+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [ParkRecordModel modelWithDictionary:dict];
}

@end
