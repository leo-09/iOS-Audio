//
//  CancelOrderReasonModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CancelOrderReasonModel.h"

@implementation CancelOrderReasonModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"cancelID" : @"id" };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [CancelOrderReasonModel modelWithDictionary:dict];
}

@end
