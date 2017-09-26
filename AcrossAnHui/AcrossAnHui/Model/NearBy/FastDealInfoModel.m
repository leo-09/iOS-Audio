//
//  FastDealInfoModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/31.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "FastDealInfoModel.h"

@implementation FastDealInfoModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"fastDealInfoID" : @"id"
              };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [FastDealInfoModel modelWithDictionary:dict];
}

@end
