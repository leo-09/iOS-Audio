//
//  CoreServeNetData.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/4.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseNetDataRequest.h"
#import "OrderRoadModel.h"

@interface CoreServeNetData : CTXBaseNetDataRequest

/**
 实时路况事件列表查询接口
 
 @param city 城市
 @param province 省
 @param tag 标志
 */
- (void) getNewTrafficListWithCity:(NSString *)city province:(NSString *)province tag:(NSString *)tag;

/**
 获取交通事件详情
 
 @param eventId 事件ID
 @param tag 标志
 */
- (void) getNewTrafficDetailInfoWithEventId:(NSString *) eventId tag:(NSString *)tag;

/**
 路况反馈接口
 
 @param token token
 @param countId 实时路况事件ID
 @param type 1:有用; 2:无用
 @param tag 标志
 */
- (void) addTrafficCountWithToken:(NSString *)token countId:(NSString *)countId type:(NSString *)type tag:(NSString *)tag;

/**
 高速路况

 @param page 分页
 @param tag 标志
 */
- (void) getHighSpeedWithPage:(int)page tag:(NSString *)tag;

/**
 绑定极光

 @param token token
 @param tag tag
 */
- (void) bindingJpushUrlWithToken:(NSString *)token tag:(NSString *)tag;

/**
 获取推送开关

 @param token token
 @param userId 用户ID,用于缓存的key，来区别每个人的缓存数据
 @param tag tag
 */
- (void) getJpushStateWithToken:(NSString *)token userId:(NSString *)userId tag:(NSString *)tag;

/**
 更改 获取推送开关 状态

 @param token token
 @param eventState 事件订阅状态
 @param raodState 时间提醒状态
 @param tag tag
 */
- (void) updateJpushStateWithToken:(NSString *)token eventState:(BOOL)eventState raodState:(BOOL)raodState tag:(NSString *)tag;

/**
 获取定制路况接口

 @param token token
 @param userId 用户ID,用于缓存的key，来区别每个人的缓存数据
 @param tag tag
 */
- (void) getUserCustomRoadListWithToken:(NSString *)token userId:(NSString *)userId tag:(NSString *)tag;

/**
 删除定制路况

 @param roadID 路况ID
 @param token token
 @param tag tag
 */
- (void) delCustomRoadWithRoadID:(NSString *)roadID token:(NSString *)token tag:(NSString *)tag;

/**
 增加定制路况接口

 @param token token
 @param roadModel OrderRoadModel
 @param tag tag
 */
- (void) addCustomRoadWithToken:(NSString *)token orderRoadModel:(OrderRoadModel *)roadModel tag:(NSString *)tag;

/**
 编辑定制路况

 @param token token
 @param roadModel OrderRoadModel
 @param tag tag
 */
- (void) updateCustomRoadWithToken:(NSString *)token orderRoadModel:(OrderRoadModel *)roadModel tag:(NSString *)tag;

/**
 获取事件订阅的 城市
 
 @param token token
 @param userId 用户ID,用于缓存的key，来区别每个人的缓存数据
 @param tag tag
 */
- (void) getEventWithToken:(NSString *)token userId:(NSString *)userId tag:(NSString *)tag;

/**
 路况标签

 @param isOnlyCache 仅显示缓存
 @param tag tag
 */
- (void) getTrafficLabelWithOnlyCache:(BOOL) isOnlyCache tag:(NSString *)tag;

/**
 获取随手拍标签
 
 @param isOnlyCache 仅显示缓存
 @param tag tag
 */
- (void) getclassfifytagnameWithOnlyCache:(BOOL) isOnlyCache tag:(NSString *)tag;

/**
 事件订阅

 @param token token
 @param city  城市
 @param label 标签
 @param tag tag
 */
- (void) addEventWithToken:(NSString *)token city:(NSString *)city label:(NSString *)label tag:(NSString *)tag;

/**
 获取分类列表信息

 @param tag tag
 */
- (void) getClassifyListWithTag:(NSString *)tag;

/**
 公告列表

 @param isBulletin  是否公告贴：1-是，0-否
 @param tag tag
 */
- (void) getannouncementcardlistWithIsBulletin:(BOOL) isBulletin tag:(NSString *)tag;

/**
 帖子列表

 @param token       token
 @param userId 用户ID,用于缓存的key，来区别每个人的缓存数据
 @param classifyID  帖子类型id 1：推荐，2：问小畅 3：随手拍 4：老司机
 @param offset      页码
 @param tag         tag
 */
- (void) getislaudrecommendcardlistWithToken:(NSString *)token userId:(NSString *)userId classifyID:(int)classifyID offset:(int) offset tag:(NSString *)tag;

/**
 点赞和取消点赞接口

 @param token           token
 @param laudType        类型：0 说明是点赞帖子 1：说明是点赞评论 2：说明点赞的是小畅回复
 @param operateID       点赞帖子或者帖子回复，都是传帖子的id
 @param isRecommend     是否是推荐：1-是，0-否
 @param tag             tag
 */
- (void) operatingpointlaudWithToken:(NSString *)token laudType:(int)laudType operateID:(NSString *)operateID isRecommend:(NSString *)isRecommend tag:(NSString *)tag;

/**
 收藏和取消收藏

 @param token token
 @param cardID 帖子id
 @param tag tag
 */
- (void) operatinghourseWithToken:(NSString *)token cardID:(NSString *)cardID tag:(NSString *)tag;

/**
 发布话题评论接口
 
 @param token token
 @param cardID 帖子id
 @param contents 回复内容
 @param tag tag
 */
- (void) publishreplyWithToken:(NSString *)token cardID:(NSString *)cardID contents:(NSString *)contents tag:(NSString *)tag;

/**
 获取评论列表信息

 @param token token
 @param cardID 帖子ID
 @param page 页码
 @param tag tag
 */
- (void) getmorecardcommentWithToken:(NSString *)token cardID:(NSString *)cardID currentPage:(int)page tag:(NSString *)tag;

/**
 帖子详情接口

 @param token token
 @param cardID 帖子ID
 @param tag tag
 */
- (void) getmycarddetailWithToken:(NSString *)token cardID:(NSString *)cardID tag:(NSString *)tag;

/**
 获取更多点赞信息

 @param cardID 帖子ID
 @param page 页码
 @param tag tag
 */
- (void) getmorecardlauduserphotoWithCardID:(NSString *)cardID currentPage:(int)page tag:(NSString *)tag;

/**
 多图上传

 @param dataArray UIImage 转换为 NSData数组
 @param tag tag
 */
- (void) fileUploadswithDataArray:(NSArray *)dataArray tag:(NSString *)tag;

/**
 发布帖子话题接口

 @param token token
 @param classifyID 话题ID
 @param tagID 标签ID
 @param contents 内容
 @param address 地址
 @param imgURL 上传图片的地址
 @param tag tag
 */

/**
 发布帖子话题接口

 @param token token
 @param userID  当前用户ID
 @param classifyID 话题ID
 @param tagID 标签ID
 @param contents 内容
 @param cityName  城市名
 @param address 地址
 @param imgURL 上传图片的地址
 @param province  省
 @param town 地区
 @param latitude 经纬度
 @param longitude 经纬度
 @param tag tag
 */
- (void)publishpostWithToken:(NSString *)token userID:(NSString *)userID classifyID:(NSString *)classifyID tagID:(NSString *)tagID contents:(NSString *)contents cityName:(NSString *)cityName address:(NSString *)address imgURL:(NSString *)imgURL province:(NSString *)province town:(NSString *)town latitude:(double) latitude longitude:(double) longitude tag:(NSString *)tag;

/**
 路况信息接口

 @param token token
 @param province 省
 @param city 市
 @param addr 地址
 @param latitude 经纬度
 @param longitude 经纬度
 @param tagName 标签
 @param contents 内容
 @param imgURL 上传图片的地址
 @param tag tag
 */
- (void) addTrafficUpWithToken:(NSString *)token province:(NSString *)province city:(NSString *)city addr:(NSString *)addr
                      latitude:(double) latitude longitude:(double)longitude tagName:(NSString *)tagName
                      contents:(NSString *)contents imgURL:(NSString *)imgURL tag:(NSString *)tag;

@end
