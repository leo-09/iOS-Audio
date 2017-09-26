//
//  CarFriendCommentModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarFriendCommentModel.h"
#import "TextViewContentTool.h"
#import "DateTool.h"

@implementation CmsCard

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"cmsCardID" : @"id",
              @"classifyID" : @"classify_id",
              @"classifyName" : @"classify_name",
              @"commandCount" : @"command_count",
              @"createTime" : @"create_time",
              @"isBulletin" : @"is_bulletin",
              @"isDel" : @"is_del",
              @"isRecommend" : @"is_recommend",
              @"isReply" : @"is_reply",
              @"lastUdpateTime" : @"last_udpate_time",
              @"postTime" : @"post_time",
              @"laudCount" : @"laud_count",
              @"commandCount" : @"command_count"
              };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [CmsCard modelWithDictionary:dict];
}

- (NSString *) classifyName {
    if (_classifyName && ![_classifyName isEqualToString:@""]) {
        return _classifyName;
    } else {
        return @"公告";
    }
}

- (NSString *) contents {
    _contents = [TextViewContentTool isContaintContent:_contents];
    return _contents ? _contents : @"";
}

- (BOOL) isRecommend {
    if ([_laudCount intValue] > 10) {
        return YES;
    } else {
        return _isRecommend;
    }
}

@end

@implementation CarFriendCommentModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"commentID" : @"id",
              @"cardID" : @"card_id",
              @"userID" : @"user_id",
              @"commentTime" : @"comment_time",
              @"createTime" : @"create_time",
              @"cityName" : @"city_name",
              @"isDel" : @"is_del"
              };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [CarFriendCommentModel modelWithDictionary:dict];
}

- (NSString *) contents {
    _contents = [TextViewContentTool isContaintContent:_contents];
    return _contents ? _contents : @"";
}

- (NSString *)createTime {
    if (_createTime) {
        return [[DateTool sharedInstance] timeFormatWithMillisecondTimeStamp:_createTime format:YYYYMMDD_HHMM];
    } else {
        return @"";
    }
}

@end
