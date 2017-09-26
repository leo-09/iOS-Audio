//
//  LoginInfoData.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseLocalData.h"
#import "LoginModel.h"
#import "YYCache.h"

/**
  登录信息数据
 */
@interface LoginInfoLocalData : CTXBaseLocalData

@property (nonatomic, retain) YYCache *yyCache;

+ (instancetype) sharedInstance;

// 帐号密码 信息
- (void) saveAccount:(NSString *)account psw:(NSString *)psw;
- (void) updateNewPassword:(NSString *)psw;
- (void) updateNewAccount:(NSString *)account;
- (NSString*) getAccount;
- (NSString*) getPassword;
- (void) clearInfo;// 清除登录信息

- (void) saveLoginModel:(LoginModel *)loginModel;
- (LoginModel *) getLoginModel;
- (void) removeLoginModel;

@end
