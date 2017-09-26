//
//  SettingNetData.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseNetDataRequest.h"

@interface SettingNetData : CTXBaseNetDataRequest

/**
 上传用户头像
 
 @param data UIImage->data
 @param tag tag
 */
- (void) uploadUserHeaderImageWithData:(NSData *)data tag:(NSString *)tag;

/**
 修改用户信息接口
 
 @param token token
 @param photo 头像地址
 @param gender 性别
 @param nickName 昵称
 @param tag tag
 */
- (void) updateUserWithToken:(NSString *)token photo:(NSString *)photo gender:(NSString *)gender nickName:(NSString *)nickName tag:(NSString *)tag;

/**
 修改用户密码接口

 @param token token
 @param oldPsw 原密码
 @param newPsw 新密码
 @param tag tag
 */
- (void) updatePasswordWithToken:(NSString *)token oldPassword:(NSString *)oldPsw newPassword:(NSString *)newPsw tag:(NSString *)tag;

/**
 生成短信验证码接口

 @param phone 手机号
 @param msgType 类型
 @param tag tag
 */
- (void) captchaSendWithPhone:(NSString *) phone msgType:(NSString *)msgType tag:(NSString *)tag;

/**
 修改用户手机号接口

 @param token token
 @param phone 手机号
 @param verify 验证码
 @param tag tag
 */
- (void) updatePhoneWithToken:(NSString *)token phone:(NSString *)phone verify:(NSString *)verify tag:(NSString *)tag;

@end
