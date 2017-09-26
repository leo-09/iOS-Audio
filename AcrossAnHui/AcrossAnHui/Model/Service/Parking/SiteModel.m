//
//  SiteModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/20.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "SiteModel.h"

@implementation SiteModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"siteID" : @"id" };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    SiteModel *model = [SiteModel modelWithDictionary:dict];
    
    return model;
}

@end
