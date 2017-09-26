//
//  LoginViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/21.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"

/**
 登录页
 */
@interface LoginViewController : CTXBaseViewController

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *psw;

@property (nonatomic, strong) GlobalLoginSuccessBlock loginSuccessBlock;

@end
