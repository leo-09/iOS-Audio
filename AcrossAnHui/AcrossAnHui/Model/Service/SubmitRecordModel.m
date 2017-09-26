//
//  SubmitRecordModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "SubmitRecordModel.h"
#import "DateTool.h"

@implementation SubmitRecordModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"carTime" : @"carTime",
              @"carType" : @"carType",
              @"city" : @"city",
              @"createTime" : @"createTime",
              @"del" : @"del",
              @"recordID" : @"id",
              @"mileage" : @"mileage",
              @"name" : @"name",
              @"phone" : @"phone",
              @"userId" : @"userId"
              };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [SubmitRecordModel modelWithDictionary:dict];
}

- (NSString *)dataTime {
    return [[DateTool sharedInstance] timeFormatWithMillisecondTimeStamp:self.createTime format:YYYYMMDD_HHMM];
}

@end
