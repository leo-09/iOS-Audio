//
//  MessageCenterModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "MessageCenterModel.h"
#import "DateTool.h"

@implementation MessageCenterModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"messageID" : @"id" };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [MessageCenterModel modelWithDictionary:dict];
}

- (NSString *)dataTime {
    return [[DateTool sharedInstance] timeFormatWithMillisecondTimeStamp:self.createTime format:YYYYMMDD_HHMM];
}

@end