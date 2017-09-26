//
//  CarFriendTrafficModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/2.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarFriendTrafficModel.h"

@implementation CarFriendTrafficModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"trafficID" : @"id" };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [CarFriendTrafficModel modelWithDictionary:dict];
}

- (NSString *) imageName {
    if ([self.type isEqualToString:faultType]) {
        return  @"guzhang";
    } else if ([self.type isEqualToString:controlType]) {
        return  @"guanzhi";
    } else if ([self.type isEqualToString:constructionType]) {
        return  @"shigong";
    } else if ([self.type isEqualToString:traffiJamType]) {
        return  @"yongdu";
    } else if ([self.type isEqualToString:waterType]) {
        return  @"jishui";
    } else if ([self.type isEqualToString:accidentType]) {
        return  @"shigu";
    } else if ([self.type isEqualToString:otherType]) {
        return  @"qita";
    } else if ([self.type isEqualToString:policeType]) {
        return  @"jc_1";
    } else if ([self.type isEqualToString:signType]) {
        return  @"bz_1";
    } else {
        return @"bx_1";
    }
}

@end
