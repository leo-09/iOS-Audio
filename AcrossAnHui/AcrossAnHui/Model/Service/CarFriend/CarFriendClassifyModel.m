//
//  CarFriendClassifyModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarFriendClassifyModel.h"

@implementation CarFriendClassifyModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"classifyID" : @"id",
              @"isDel" : @"is_del",
              @"lastUdpateTime" : @"last_udpate_time",
              @"createTime" : @"create_time"
              };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [CarFriendClassifyModel modelWithDictionary:dict];
}

@end
