//
//  LoginModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 登录成功后的实体类
 */
@interface LoginModel : CTXBaseModel

@property (nonatomic, copy) NSString *loginID;        // 用户id
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *token;          // 用户票据编码
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *loginName;      // 用户登录名，即昵称
@property (nonatomic, copy) NSString *photo;          // 用户头像地址
@property (nonatomic, copy) NSString *realName;       // 真实姓名
@property (nonatomic, copy) NSString *gender;         // 性别
@property (nonatomic, copy) NSString *rankingNo;      // 用户注册排名

@property (nonatomic, copy) NSString *crTime;
@property (nonatomic, copy) NSString *lastTime;
@property (nonatomic, copy) NSString *origin;

- (NSString *) genderName;

@end
