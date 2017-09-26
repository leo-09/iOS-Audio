//
//  CarFriendTopicModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarFriendTopicModel.h"
#import "TextViewContentTool.h"
#import "DateTool.h"

@implementation CarFriendTopicModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"topicID" : @"id",
              @"cityName" : @"city_name",
              @"classifyID" : @"classify_id",
              @"classifyName" : @"classify_name",
              @"commandCount" : @"command_count",
              @"createTime" : @"create_time",
              @"laudCount" : @"laud_count",
              @"isBulletin" : @"is_bulletin",
              @"isDel" : @"is_del",
              @"isRecommend" : @"is_recommend",
              @"isReply" : @"is_reply",
              @"replyCount" : @"reply_count",
              };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    CarFriendTopicModel *model = [CarFriendTopicModel modelWithDictionary:dict];
    model.imageList = [CarFriendUserCommentModel convertFromArray:model.imageList];
    return model;
}

- (NSString *) status {
    if ([_status isEqualToString:@"0"]) {
        return @"审核中";
    } else if ([_status isEqualToString:@"1"]) {
        return @"审核通过";
    } else {
        return @"审核失败";
    }
}

- (NSString *) classifyName {
    if (_classifyName && ![_classifyName isEqualToString:@""]) {
        return _classifyName;
    } else {
        return @"公告";
    }
}

- (NSString *)createTime {
    if (_createTime) {
        return [[DateTool sharedInstance] timeFormatWithMillisecondTimeStamp:_createTime format:YYYYMMDD_HHMM];
    } else {
        return @"";
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
