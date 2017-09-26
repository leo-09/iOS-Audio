//
//  CarFriendNetData.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseNetDataRequest.h"

@interface CarFriendRecordNetData : CTXBaseNetDataRequest

/**
 获取收藏 路况 话题 等个获取最新消息数量

 @param token token
 @param userId 用户ID,用于缓存的key，来区别每个人的缓存数据
 @param tag tag
 */
- (void)getallkindsofcountNewWithToken:(NSString *)token userId:(NSString *)userId tag:(NSString *)tag;

/**
 帖子列表接口(个人中心)

 @param token token
 @param userId 用户ID,用于缓存的key，来区别每个人的缓存数据
 @param page 页码
 @param tag tag
 */
- (void) getmyrecommendcardlistWithToken:(NSString *)token userId:(NSString *)userId currentPage:(int)page tag:(NSString *)tag;

/**
 删除我的评论或者话题帖子接口

 @param token token
 @param topicID 评论/话题ID
 @param tag tag
 */
- (void) deleteusercommenorcardtlistWithToken:(NSString *)token topicID:(NSString *)topicID tag:(NSString *)tag;

/**
 获取我的评论和收藏列表接口

 @param token token
 @param userId 用户ID,用于缓存的key，来区别每个人的缓存数据
 @param type 0评论；1收藏
 @param page 页码
 @param tag tag
 */
- (void) getusercommentlistWithToken:(NSString *)token userId:(NSString *)userId type:(int)type currentPage:(int)page tag:(NSString *)tag;

/**
 删除我的评论或者话题帖子接口

 @param token token
 @param commentID 评论ID
 @param tag tag
 */
- (void) deleteusercommenorcardtlistWithToken:(NSString *)token commentID:(NSString *)commentID tag:(NSString *)tag;

/**
 删除收藏

 @param token token
 @param userID 用户ID
 @param cardID 帖子ID
 @param recordID 记录ID
 @param tag tag
 */
- (void) operatinghourseWithToken:(NSString *)token userID:(NSString *)userID cardID:(NSString *)cardID recordID:(NSString *)recordID tag:(NSString *)tag;

/**
 获取上报路口的记录

 @param token token
 @param userId 用户ID,用于缓存的key，来区别每个人的缓存数据
 @param page 页码
 @param date 月份
 @param tag tag
 */
- (void)getTrafficCountWithToken:(NSString *)token userId:(NSString *)userId currentPage:(int)page date:(NSString *)date tag:(NSString *)tag;

@end
