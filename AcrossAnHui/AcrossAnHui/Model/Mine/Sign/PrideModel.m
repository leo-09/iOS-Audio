//
//  PrideModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "PrideModel.h"
#import "DateTool.h"

@implementation PrideModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"prideID" : @"id" };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    PrideModel *model = [PrideModel modelWithDictionary:dict];
    return model;
}

- (NSString *) rewardTime {
    return [[DateTool sharedInstance] timeFormatWithMillisecondTimeStamp:_rewardTime format:YYYYMMDD];
}

@end
