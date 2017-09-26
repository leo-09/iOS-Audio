//
//  LoginInfoData.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "LoginInfoLocalData.h"

static NSString *accountKey = @"accountKey";
static NSString *passwordKey = @"passwordKey";
static NSString *loginModelKey = @"loginModelKey";

@implementation LoginInfoLocalData

#pragma mark - 单例模式

static LoginInfoLocalData *instance;

+ (id) allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

+ (instancetype) sharedInstance {
    static dispatch_once_t oncetToken;
    dispatch_once(&oncetToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (id) copyWithZone:(NSZone *)zone {
    return instance;
}

- (instancetype) init {
    if (self = [super init]) {
        _yyCache = [YYCache cacheWithName:LoginInfoDataCache];
    }
    return self;
}

#pragma mark - 帐号密码 信息

- (void) saveAccount:(NSString *)account psw:(NSString *)psw {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:account forKey:accountKey];
    [defaults setObject:psw forKey:passwordKey];
    
    [defaults synchronize];
}

- (void) updateNewPassword:(NSString *)psw {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:psw forKey:passwordKey];
    [defaults synchronize];
}

- (void) updateNewAccount:(NSString *)account {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:account forKey:accountKey];
    [defaults synchronize];
}

- (NSString *) getAccount {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *account = [defaults objectForKey:accountKey];
    
    return account;
}

- (NSString *) getPassword {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *password = [defaults objectForKey:passwordKey];
    
    return password;
}

// 清除登录信息
- (void) clearInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:@"" forKey:accountKey];
    [defaults setObject:@"" forKey:passwordKey];
    
    [defaults synchronize];
}

#pragma mark - 保存登录后的信息

- (void) saveLoginModel:(LoginModel *)loginModel {
    [_yyCache setObject:loginModel forKey:loginModelKey withBlock:^{
        NSLog(@"setObject sucess");
    }];
}

- (LoginModel *) getLoginModel {
    //根据key读取数据
    LoginModel * model = (LoginModel *) [_yyCache objectForKey:loginModelKey];
    return model;
}

- (void) removeLoginModel {
    [_yyCache removeObjectForKey:loginModelKey];
}

@end
