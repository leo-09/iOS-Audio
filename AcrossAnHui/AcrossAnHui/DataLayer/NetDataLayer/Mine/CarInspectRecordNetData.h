//
//  CarInspectRecordNetData.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseNetDataRequest.h"

@interface CarInspectRecordNetData : CTXBaseNetDataRequest

/**
 查询预约记录接口
 
 @param token 用户验证
 @param userId 用户ID,用于缓存的key，来区别每个人的缓存数据
 @param page 请求的当前页；（从0开始）
 @param type 查询年检类型；(1:年检;   2:6年免检 ； 0:查询全部)
 @param tag tag
 */
- (void) subscribeListWithToken:(NSString *)token userId:(NSString *)userId currentPage:(int)page businessType:(NSString *) type tag:(NSString *)tag;

/**
 申请退款接口

 @param token token
 @param businessid 订单ID
 @param tag tag
 */
- (void) applyRefundWithToken:(NSString *)token businessID:(NSString *)businessid tag:(NSString *)tag;

/**
 代办记录
 
 @param token token
 @param userId 用户ID,用于缓存的key，来区别每个人的缓存数据
 @param pageId 页码
 @param tag tag
 */
- (void)getDaiBanRecordWithToken:(NSString *)token userId:(NSString *)userId pageId:(int)pageId tag:(NSString *)tag;

/**
 代办确认订单
 
 @param token token
 @param businessid 订单ID
 @param tag tag
 */
- (void)sureOrderWithToken:(NSString *)token businessid:(NSString *)businessid tag:(NSString *)tag;

/**
 代办订单详情
 
 @param token token
 @param businessid 订单ID
 @param tag tag
 */
- (void)getOrderDetailWithToken:(NSString *)token businessid:(NSString *)businessid tag:(NSString *)tag;

/**
 车检代办重新下单
 
 @param token token
 @param businessid 订单ID
 @param tag tag
 */
- (void) saveOrderAgainWithToken:(NSString *)token businessid:(NSString *)businessid tag:(NSString *)tag;

/**
 订单跟踪
 
 @param token token
 @param businessid 订单ID
 @param tag tag
 */
- (void) getOrderRecordWithToken:(NSString *)token businessid:(NSString *)businessid tag:(NSString *)tag;

/**
 查询代办取消原因
 
 @param tag tag
 */
- (void) findCancelResonListWithTag:(NSString *)tag;

/**
 取消预约记录接口
 
 @param token token
 @param businessid 订单ID
 @param reasonid 取消原因ID
 @param tag tag
 */
- (void) cancelSubscribeWithToken:(NSString *)token businessid:(NSString *)businessid reasonid:(NSString *)reasonid tag:(NSString *)tag;

/**
 司机轨迹

 @param orderid e代驾订单id
 @param tag tag
 */
- (void) getDriverPositionWithOrderID:(NSString *)orderid tag:(NSString *)tag;

/**
 代办申请退款原因

 @param token token
 @param businessid 订单ID
 @param tag tag
 */
- (void) getReturnMoneyResonWithToken:(NSString *)token businessid:(NSString *)businessid tag:(NSString *)tag;

/**
 代办申请退款

 @param token token
 @param businessid 订单ID
 @param reasonid 取消原因ID
 @param money 退款金额
 @param tag tag
 */
- (void) applyDbRefundWithToken:(NSString *)token businessid:(NSString *)businessid reasonid:(NSString *)reasonid money:(NSString *)money tag:(NSString *)tag;

/**
 停车记录

 @param token token
 @param userId 用户ID,用于缓存的key，来区别每个人的缓存数据
 @param magCard 车牌号
 @param currentPage 当前页
 @param isPay 支付状态
 @param tag tag
 */
-(void)queryParkingRecordListWithToken:(NSString *)token userId:(NSString *)userId magCard:(NSString *)magCard currentPage:(int)currentPage isPay:(NSString *)isPay tag:(NSString *)tag;

/**
 停车记录详情

 @param token token
 @param CarID carID
 @param isPay 支付状态
 @param tag tag
 */
-(void)queryParkingDetailRecordWithToken:(NSString *)token  carID:(NSString *)CarID isPay:(NSString *)isPay tag:(NSString *)tag;

/**
 钱包余额支付

 @param token token
 @param orderNum 订单编号
 @param tag tag
 */
-(void)getWalletPayWithToken:(NSString *)token  orderNum:(NSString *)orderNum tag:(NSString *)tag;

/**
 支付宝支付
 
 @param token token
 @param businessCode 订单编号
 @param desc 描述
 @param payFee 支付金额
 @param tag tag
 */
- (void) aliPayWithToken:(NSString *)token BusinessCode:(NSString *)businessCode desc:(NSString *)desc payFee:(NSString *)payFee tag:(NSString *)tag;

/**
 微信支付
 
 @param token token
 @param businessCode 订单编号
 @param desc 描述
 @param payFee 支付金额
 @param tag tag
 */
- (void) weChatPayWithToken:(NSString *)token BusinessCode:(NSString *)businessCode desc:(NSString *)desc payFee:(NSString *)payFee tag:(NSString *)tag;


/**
 司机评价

 @param token token
 @param orderid 订单id
 @param driverPhone 司机手机号
 @param attitude 司机态度评分
 @param speed 司机速度评分
 @param content 评价内容
 */
-(void)driverEvaluateWithToken:(NSString *)token orderid:(NSString *)orderid driverPhone:(NSString *)driverPhone attitude:(CGFloat)attitude speed:(CGFloat)speed  content:(NSString *)content tag:(NSString *)tag;

/**
 查看物流

 @param businessID 订单ID
 @param type 0表示寄往车检站  1表示寄往用户
 @param tag tag
 */
- (void) querySFBnoWithBusinessID:(NSString *)businessID type:(int) type tag:(NSString *)tag;

@end
