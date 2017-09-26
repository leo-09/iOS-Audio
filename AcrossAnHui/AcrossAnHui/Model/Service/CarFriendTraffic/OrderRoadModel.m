//
//  OrderRoadModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/5.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "OrderRoadModel.h"

@implementation OrderRoadModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"orderRoadID" : @"id" };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [OrderRoadModel modelWithDictionary:dict];
}

- (NSArray *) originArray {
    if (self.origin && [self.origin containsString:@","]) {
        NSArray *result = [self.origin componentsSeparatedByString:@","];
        if (result.count == 2) {
            return result;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (NSArray *) destinationArray {
    if (self.destination && [self.destination containsString:@","]) {
        NSArray *result = [self.destination componentsSeparatedByString:@","];
        if (result.count == 2) {
            return result;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (NSArray *) weekArray {
    if (self.week) {
        if ([self.week containsString:@","]) {
            return [self.week componentsSeparatedByString:@","];
        } else {
            return @[ self.week ];
        }
    } else {
        return @[];
    }
}

- (NSString *)weekDesc {
    if ([self.week isEqualToString:@"周日,周一,周二,周三,周四,周五,周六"]) {
        return @"每天";
    } else if ([self.week isEqualToString:@"周一,周二,周三,周四,周五"]) {
        return @"工作日";
    } else {
        return self.week;
    }
}

- (NSString *)originAddr {
    return [_originAddr stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
}

- (NSString *) destinationAddr {
    return [_destinationAddr stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
}

@end
