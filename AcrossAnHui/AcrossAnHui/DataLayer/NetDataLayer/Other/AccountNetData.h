//
//  AccounNetData.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseNetDataRequest.h"

@interface AccountNetData : CTXBaseNetDataRequest

/**
 登录

 @param phone 帐号
 @param psw 密码
 @param tag 标志
 */
- (void) loginWithPhone:(NSString *)phone passsword:(NSString *)psw tag:(NSString *)tag;

/**
 注册用户接口

 @param phone 手机号
 @param psw 密码
 @param verify 验证码
 @param tag tag
 */
- (void) registerWithPhone:(NSString *)phone passsword:(NSString *)psw verify:(NSString *)verify tag:(NSString *)tag;

/**
 忘记密码

 @param phone 手机号
 @param psw 密码
 @param verify 验证码
 @param tag tag
 */
- (void) forgetPasswordWithPhone:(NSString *)phone passsword:(NSString *)psw verify:(NSString *)verify tag:(NSString *)tag;

@end
