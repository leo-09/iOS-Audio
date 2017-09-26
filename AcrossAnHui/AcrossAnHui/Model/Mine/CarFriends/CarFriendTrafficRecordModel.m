//
//  CarFriendTrafficRecordModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarFriendTrafficRecordModel.h"
#import "DateTool.h"

@implementation CarFriendTrafficRecordModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"desc" : @"description" };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [CarFriendTrafficRecordModel modelWithDictionary:dict];
}

- (NSArray *) photos {
    if (_scenePhotos && ![_scenePhotos isEqualToString:@""]) {
        return [_scenePhotos componentsSeparatedByString:@","];
    } else {
        return @[];
    }
}

// 1 审核中; 2 已采用; 3 未采用
- (NSString *) statusDesc {
    if (_status == 1) {
        return @"审核中";
    } else if (_status == 2) {
        return @"已采用";
    } else if (_status == 3) {
        return @"未采用";
    } else {
        return @"--";
    }
}

- (NSString *) statusImagePath {
    if (_status == 1) {
        return @"sh_1";
    } else if (_status == 2) {
        return @"ycy_1";
    } else if (_status == 3) {
        return @"wcy_1";
    } else {
        return @"";
    }
}

- (NSString *)createTime {
    if (_createTime) {
        return [[DateTool sharedInstance] timeFormatWithMillisecondTimeStamp:_createTime format:YYYYMMDD_HHMM];
    } else {
        return @"";
    }
}

@end
