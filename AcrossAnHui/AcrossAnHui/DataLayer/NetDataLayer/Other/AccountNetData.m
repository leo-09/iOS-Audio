//
//  AccounNetData.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "AccountNetData.h"

@implementation AccountNetData

- (void) loginWithPhone:(NSString *)phone passsword:(NSString *)psw tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.successIden = @"100";
    model.isRecordOperation = NO;
    model.tag = tag;
    
    // 密码竟然不加密!!!
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:(phone ? phone : @"") forKey:@"phone"];
    [params setObject:(psw ? psw : @"") forKey:@"password"];
    
    // 登录不可以用缓存
    [self httpPostRequest:Login_Url params:params requestModel:model];
}

- (void) registerWithPhone:(NSString *)phone passsword:(NSString *)psw verify:(NSString *)verify tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.successIden = @"100";
    model.isRecordOperation = NO;
    model.tag = tag;
    
    // 密码竟然不加密!!!
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:(phone ? phone : @"") forKey:@"phone"];
    [params setObject:(psw ? psw : @"") forKey:@"password"];
    [params setObject:(verify ? verify : @"") forKey:@"verify"];
    
    [self httpPostRequest:Register_Url params:params requestModel:model];
}

- (void) forgetPasswordWithPhone:(NSString *)phone passsword:(NSString *)psw verify:(NSString *)verify tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.successIden = @"100";
    model.isRecordOperation = NO;
    model.tag = tag;
    
    // 密码竟然不加密!!!
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:(phone ? phone : @"") forKey:@"phone"];
    [params setObject:(psw ? psw : @"") forKey:@"password"];
    [params setObject:(verify ? verify : @"") forKey:@"verify"];
    
    [self httpPostRequest:forgetPassword_Url params:params requestModel:model];
}

@end
