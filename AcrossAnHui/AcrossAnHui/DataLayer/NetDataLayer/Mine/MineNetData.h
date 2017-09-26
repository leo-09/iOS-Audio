//
//  MineNetData.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/11.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseNetDataRequest.h"
#import "BoundCarModel.h"

@interface MineNetData : CTXBaseNetDataRequest

/**
 获取所有车型

 @param tag tag
 */
- (void) getCarTypeWithTag:(NSString *)tag;

/**
 意见反馈接口

 @param token token
 @param content 内容
 @param tag tag
 */
- (void)addFeedBackWithToken:(NSString *)token content:(NSString *)content tag:(NSString *)tag;

/**
 帮助中心接口

 @param tag tag
 */
- (void) getHelpListWithTag:(NSString *)tag;

/**
 绑定车辆列表接口

 @param token token
 @param userId 用户ID,用于缓存的key，来区别每个人的缓存数据
 @param tag tag
 */
- (void) getBoundCarListWithToken:(NSString *)token userId:(NSString *)userId tag:(NSString *)tag;

/**
 解绑车辆接口

 @param token token
 @param carID 车ID
 @param tag tag
 */
- (void) unbindCarWithToken:(NSString *)token carID:(NSString *)carID tag:(NSString *)tag;

/**
 绑定 or 编辑车辆

 @param token token
 @param carModel 汽车实体
 @param tag tag
 */
- (void) bindCarWithToken:(NSString *)token boundCarModel:(BoundCarModel *)carModel tag:(NSString *)tag;

/**
 默认车辆接口

 @param token token
 @param carID 车ID
 @param tag tag
 */
- (void) setDefaultCarWithToken:(NSString *)token carID:(NSString *)carID tag:(NSString *)tag;

/**
 获取最新消息数量

 @param token token
 @param tag tag
 */
- (void) getMsgCountWithToken:(NSString *)token tag:(NSString *)tag;

/**
 消息列表

 @param token  token
 @param userId 用户ID,用于缓存的key，来区别每个人的缓存数据
 @param type   1: 提醒通知；2:平台公告
 @param offset 分页
 @param tag tag
 */
- (void) getMsgListWithToken:(NSString *)token userId:(NSString *)userId type:(NSString *)type offset:(int)offset tag:(NSString *)tag;

/**
 消息内容

 @param token token
 @param type 类型：1 事件内容 2.系统内容 3事件通知 4 系统通知
 @param msgID 消息ID
 @param tag tag
 */
- (void) clickReadWithToken:(NSString *)token type:(int)type msgID:(NSString *)msgID tag:(NSString *)tag;

/**
 用户中心个人数据tip

 @param token token
 @param userId 用户ID,用于缓存的key，来区别每个人的缓存数据
 @param tag tag
 */
- (void) getUserTipWithToken:(NSString *)token userId:(NSString *)userId tag:(NSString *)tag;

/**
 获取奖品列表信息

 @param token token
 @param userId 用户ID,用于缓存的key，来区别每个人的缓存数据
 @param state 1:未领取; 2:已领取; 3:已过期
 @param tag tag
 */
- (void) getRewardListWithToken:(NSString *)token userId:(NSString *)userId state:(NSString *)state tag:(NSString *)tag;

/**
 领取奖品

 @param token token
 @param prideID 奖品ID
 @param name 领取人姓名
 @param phone 领取人手机号
 @param goodsName 奖品名称
 @param tag tag
 */
- (void) receivePrizesWithToken:(NSString *)token prideID:(NSString *)prideID
                           name:(NSString *)name phone:(NSString *)phone
                      goodsName:(NSString *)goodsName tag:(NSString *)tag;

/**
 分享的类别
 
 @param token token
 @param state 类别：1、微信分享；2、qq分享
 @param tag tag
 */
- (void) shareWayWithToken:(NSString *)token state:(NSString *)state tag:(NSString *)tag;

/**
 签到信息

 @param token token
 @param userId 用户ID,用于缓存的key，来区别每个人的缓存数据
 @param tag tag
 */
- (void) signInfoWithToken:(NSString *)token userId:(NSString *)userId tag:(NSString *)tag;

/**
 用户签到
 
 @param token token
 @param tag tag
 */
- (void) userSignWithToken:(NSString *)token tag:(NSString *)tag;

/**
 删除用户绑定停车服务车辆

 @param token token
 @param plateNumber 车架号
 @param tag tag
 */
- (void) deleteCarParkServiceWithToken:(NSString *)token plateNumber:(NSString *)plateNumber tag:(NSString *)tag;

/**
 查询用户绑定停车服务车辆

 @param token token
 @param userId 用户ID,用于缓存的key，来区别每个人的缓存数据
 @param tag tag
 */
- (void) selectCarParkServiceWithToken:(NSString *)token userId:(NSString *)userId tag:(NSString *)tag;

/**
 绑定停车服务

 @param token token
 @param plateNumber 车架号（以,分隔）
 @param carname 车名称（以,分隔）
 @param imgurl 图标（以,分隔）
 @param tag tag
 */
- (void) addCarParkServiceWithToken:(NSString *)token plateNumber:(NSString *)plateNumber carname:(NSString *)carname imgurl:(NSString *)imgurl tag:(NSString *)tag;

@end
