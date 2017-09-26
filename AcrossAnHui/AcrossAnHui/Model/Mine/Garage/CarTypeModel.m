
//
//  CarTypeModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/14.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarTypeModel.h"

@implementation CBModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"CBID" : @"id" };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [CBModel modelWithDictionary:dict];
}

@end

@implementation CarTypeModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    CarTypeModel *model = [CarTypeModel modelWithDictionary:dict];
    
    NSArray<CBModel *> *cs = [CBModel convertFromArray:model.cs];
    model.cs = cs;
    
    return model;
}

@end
