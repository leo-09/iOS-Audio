//
//  NewsInfoModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "NewsInfoModel.h"
#import "DateTool.h"

@implementation NewsInfoModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"newsInfoID" : @"id",        // 首页的今日头条的id是  contentid
              @"name" : @"name",
              @"addtime" : @"addtime",
              @"typeimg" : @"typeimg",
              @"title" : @"title",
              @"appNewsUrl" : @"appNewsUrl"
            };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [NewsInfoModel modelWithDictionary:dict];
}

- (NSString *)dataTime {
    return [[DateTool sharedInstance] timeFormatWithSecondTimeStamp:self.addtime format:YYYYMMDD_HHMM];
}

- (NSString *) title {
    return (_title ? _title : @"");
}

@end
