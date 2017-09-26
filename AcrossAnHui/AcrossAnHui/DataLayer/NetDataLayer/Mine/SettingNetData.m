//
//  SettingNetData.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "SettingNetData.h"

@implementation SettingNetData

- (void) uploadUserHeaderImageWithData:(NSData *)data tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.imageMimeType = @"image/png";
    model.successIden = @"100";
    model.tag = tag;
    
    [self uploadDataWithUrlStr:UploadHeaderImageUrl params:nil imageName:@"file" fileName:@"image.jpg" withData:data requestModel:model];
}

- (void) updateUserWithToken:(NSString *)token photo:(NSString *)photo gender:(NSString *)gender nickName:(NSString *)nickName tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.successIden = @"100";
    model.tag = tag;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    
    if (photo) {
        [params setObject:(photo ? photo : @"") forKey:@"photo"];
    }
    if (gender) {
        [params setObject:(gender ? gender : @"") forKey:@"sex"];
    }
    if (nickName) {
        [params setObject:(nickName ? nickName : @"") forKey:@"loginName"];
    }
    
    [self httpPostRequest:UpdateUser_Url params:params requestModel:model];
}

- (void) updatePasswordWithToken:(NSString *)token oldPassword:(NSString *)oldPsw newPassword:(NSString *)newPsw tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.successIden = @"100";
    model.tag = tag;
    
    // 密码竟然不加密!!!
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    [params setObject:(oldPsw ? oldPsw : @"") forKey:@"password"];
    [params setObject:(newPsw ? newPsw : @"") forKey:@"newpassword"];
    
    [self httpPostRequest:UpdatePassword params:params requestModel:model];
}

- (void) captchaSendWithPhone:(NSString *)phone msgType:(NSString *)msgType tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.successIden = @"100";
    model.tag = tag;
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:(phone ? phone : @"") forKey:@"phone"];
    [params setObject:(msgType ? msgType : @"") forKey:@"msgType"];
    
    [self httpPostRequest:GenerateSMSCodeUrl params:params requestModel:model];
}

- (void) updatePhoneWithToken:(NSString *)token phone:(NSString *)phone verify:(NSString *)verify tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.successIden = @"100";
    model.tag = tag;
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    [params setObject:(phone ? phone : @"") forKey:@"phone"];
    [params setObject:(verify ? verify : @"") forKey:@"verify"];
    
    [self httpPostRequest:UpdatePhone_Url params:params requestModel:model];
}

@end
