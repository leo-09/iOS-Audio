//
//  CarFriendUserCommontModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarFriendUserCommentModel.h"
#import "TextViewContentTool.h"
#import "DateTool.h"

@implementation CarFriendUserCommentModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"createTime" : @"create_time",
              @"headImage" : @"head_image",
              @"cardID" : @"card_id",
              @"commentTime" : @"comment_time",
              @"commontID" : @"id",
              @"isDel" : @"is_del",
              @"laudCount" : @"laud_count",
              @"userID" : @"user_id",
              @"userPhoto" : @"user_photo",
              @"lastUdpateTime" : @"last_udpate_time",
              @"nickName" : @"nick_name",
              @"nikeName" : @"nike_name"
              };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [CarFriendUserCommentModel modelWithDictionary:dict];
}

- (NSString *) createTime {
    if (_createTime) {
        return [[DateTool sharedInstance] timeFormatWithMillisecondTimeStamp:_createTime format:YYYYMMDD_HHMMSS];
    } else {
        return @"";
    }
}

- (void) setLaudCount:(NSString *)laudCount {
    if ([laudCount intValue] < 0) {
        _laudCount = @"";
    } else {
        _laudCount = laudCount;
    }
}

- (NSString *) nickName {
    return _nickName ? _nickName : @"";
}

- (NSString *) carName {
    return _carName ? _carName : @"";
}

- (NSString *) contents {
    _contents = [TextViewContentTool isContaintContent:_contents];
    return _contents ? _contents : @"";
}

@end
