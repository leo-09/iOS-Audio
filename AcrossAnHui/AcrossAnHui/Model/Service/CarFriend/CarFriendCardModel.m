//
//  CarFriendCardModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarFriendCardModel.h"
#import "TextViewContentTool.h"
#import "DateTool.h"

@implementation CarFriendCardModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"cardID" : @"id",
              @"cityName" : @"city_name",
              @"classifyID" : @"classify_id",
              @"classifyName" : @"classify_name",
              @"commandCount" : @"command_count",
              @"createTime" : @"create_time",
              @"isBulletin" : @"is_bulletin",
              @"isDel" : @"is_del",
              @"isRecommend" : @"is_recommend",
              @"isReply" : @"is_reply",
              @"lastUdpateTime" : @"last_udpate_time",
              @"laudCount" : @"laud_count",
              @"postTime" : @"post_time",
              @"replyContents" : @"reply_contents",
              @"replyCount" : @"reply_count",
              @"replyUserID" : @"reply_user_id",
              @"replyUserName" : @"reply_user_name",
              @"userID" : @"user_id",
              @"userPhoto" : @"user_photo",
              @"nikeName" : @"nike_name",
              @"tagID" : @"tag_id",
              @"tagName" : @"tag_name"
              };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    CarFriendCardModel *model = [CarFriendCardModel modelWithDictionary:dict];
    model.imageList = [CarFriendUserCommentModel convertFromArray:model.imageList];
    model.headImageList = [CarFriendHeadImageModel convertFromArray:model.headImageList];
    
    return model;
}

- (NSString *) nikeName {
    return _nikeName ? _nikeName : @"";
}

- (NSString *) carName {
    return _carName ? _carName : @"";
}

- (NSString *) contents {
    _contents = [TextViewContentTool isContaintContent:_contents];
    return _contents ? _contents : @"";
}

- (NSString *) replyContents {
    return _replyContents ? _replyContents : @"";
}

- (NSString *) createTime {
    if (_createTime) {
        return [[DateTool sharedInstance] timeFormatWithMillisecondTimeStamp:_createTime format:YYYYMMDD_HHMMSS];
    } else {
        return @"";
    }
}

- (BOOL) isRecommend {
    if ([_laudCount intValue] > 10) {
        return YES;
    } else {
        return _isRecommend;
    }
}

- (NSString *) address {
    return [_address stringByReplacingOccurrencesOfString:@"null" withString:@""];
}

- (void) setLaudCount:(NSString *)laudCount {
    if ([laudCount intValue] < 0) {
        _laudCount = @"";
    } else {
        _laudCount = laudCount;
    }
}

- (void) setReplyCount:(NSString *)replyCount {
    if ([replyCount intValue] < 0) {
        _replyCount = @"0";
    } else {
        _replyCount = replyCount;
    }
}

#pragma mark - copy

- (instancetype) ctxCopy {
    CarFriendCardModel *model = [self copy];
    
    NSMutableArray<CarFriendHeadImageModel *> *headImageList = [[NSMutableArray alloc] init];
    for (CarFriendHeadImageModel *item in self.headImageList) {
        [headImageList addObject:[item copy]];
    }
    model.headImageList = headImageList;
    
    return model;
}

@end
