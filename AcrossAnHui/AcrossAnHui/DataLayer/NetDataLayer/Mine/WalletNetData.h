//
//  WalletNetData.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/11.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseNetDataRequest.h"

@interface WalletNetData : CTXBaseNetDataRequest

/**
 自动付款状态修改

 @param token token
 @param payType 开关
 @param tag tag
 */
- (void)updatePayTypeWithToken:(NSString *)token payType:(NSString *)payType tag:(NSString *)tag;

/**
 用户余额查询

 @param token token
 @param tag tag
 */
- (void) selectBalanceWithToken:(NSString *)token tag:(NSString *)tag;

/**
 消费记录查询

 @param token token
 @param userId 用户ID,用于缓存的key，来区别每个人的缓存数据
 @param addTime 开始日期
 @param endTime 结束日期
 @param page 页码
 @param tag tag
 */
- (void) costRecordsWithToken:(NSString *)token userId:(NSString *)userId addTime:(NSString *)addTime endTime:(NSString *)endTime page:(int)page tag:(NSString *)tag;

/**
 充值记录查询

 @param token token
 @param userId 用户ID,用于缓存的key，来区别每个人的缓存数据
 @param page 页码
 @param tag tag
 */
- (void) selectRechargeWithToken:(NSString *)token userId:(NSString *)userId page:(int)page tag:(NSString *)tag;

/**
 查询发票申请余额
 
 @param token token
 @param tag tag
 */
- (void) seleteTicketSendMoneyWithToken:(NSString *)token tag:(NSString *)tag;

/**
 添加发票记录

 @param token token
 @param petitionermoney 申请金额
 @param petitioner 申请人
 @param address 邮寄地址
 @param tag tag
 */
- (void)addTicketSendWithToken:(NSString *)token petitionermoney:(NSString *)petitionermoney petitioner:(NSString *)petitioner address:(NSString *)address tag:(NSString *)tag;

/**
 查询申请发票记录

 @param token token
 @param userId 用户ID,用于缓存的key，来区别每个人的缓存数据
 @param page 页码
 @param tag tag
 */
- (void) selectTicketSendWithToken:(NSString *)token userId:(NSString *)userId page:(int)page tag:(NSString *)tag;

/**
 删除发票记录

 @param token token
 @param tid 发票ID
 @param tag tag
 */
- (void) deleteTicketSendWithToken:(NSString *)token tid:(NSString *)tid tag:(NSString *)tag;

@end
