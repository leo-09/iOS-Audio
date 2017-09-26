//
//  CarFriendHeadImageModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/2.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarFriendHeadImageModel.h"
#import "DateTool.h"

@implementation CarFriendHeadImageModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"nickName" : @"nick_name",
              @"headImage" : @"head_image",
              @"createTime" : @"create_time"
              };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    CarFriendHeadImageModel *model = [CarFriendHeadImageModel modelWithDictionary:dict];
    
    return model;
}

- (NSString *) createTime {
    if (_createTime) {
        return [[DateTool sharedInstance] timeFormatWithMillisecondTimeStamp:_createTime format:YYYYMMDD_HHMM];
    } else {
        return @"";
    }
}


@end
