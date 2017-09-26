//
//  MessageContentModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "MessageContentModel.h"
#import "DateTool.h"

@implementation MessageContentModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"messageID" : @"id" };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    MessageContentModel *model = [MessageContentModel modelWithDictionary:dict];
    return model;
}

- (NSString *)dataTime {
    if (self.createTime) {
        return [[DateTool sharedInstance] timeFormatWithMillisecondTimeStamp:self.createTime format:YYYYMMDD_HHMM];
    } else {
        return self.time;
    }
}

@end
