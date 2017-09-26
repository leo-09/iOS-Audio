//
//  HighTraficModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/4.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "HighTraficModel.h"
#import "DateTool.h"

@implementation HighTraficModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [HighTraficModel modelWithDictionary:dict];
}

- (NSString *) time {
    return [[DateTool sharedInstance] timeFormatWithMillisecondTimeStamp:self.createTime format:YYYYMMDD_HHMM];
}

@end
