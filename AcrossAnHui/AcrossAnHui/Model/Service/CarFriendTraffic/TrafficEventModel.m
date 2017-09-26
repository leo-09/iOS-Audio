//
//  TrafficEventModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/4.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "TrafficEventModel.h"

@implementation TrafficEventModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"desc" : @"description",
              @"eventID" : @"id"
            };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [TrafficEventModel modelWithDictionary:dict];
}

- (NSArray *) sceneImagePaths {
    if ([self.scenePhotos containsString:@","]) {
        NSArray *result = [self.scenePhotos componentsSeparatedByString:@","];
        if (result.count == 0) {
            return nil;
        } else {
            return result;
        }
    } else {
        return nil;
    }
}

@end
