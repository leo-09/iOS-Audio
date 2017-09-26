//
//  EventDetailModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "EventDetailModel.h"

@implementation EventDetailModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"desc" : @"description",
              @"eventID" : @"id"
              };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [EventDetailModel modelWithDictionary:dict];
}

@end

@implementation SuperEventDetailModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"superID" : @"id" };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    SuperEventDetailModel *superModel = [SuperEventDetailModel modelWithJSON:dict];
    
    superModel.labelList = [EventDetailModel convertFromArray:superModel.labelList];
    
    return superModel;
}

- (void) setIsCity:(BOOL)isCity {
    _isCity = isCity;
    for (EventDetailModel *model in _labelList) {
        model.isCity = isCity;
    }
}

@end
