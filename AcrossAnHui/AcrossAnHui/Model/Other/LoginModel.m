//
//  LoginModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"crTime" : @"crTime",
              @"email" : @"email",
              @"loginID" : @"id",
              @"lastTime" : @"lastTime",
              @"loginName" : @"loginName",
              @"origin" : @"origin",
              @"phone" : @"phone",
              @"photo" : @"photo",
              @"rankingNo" : @"rankingNo",
              @"realName" : @"realName",
              @"gender" : @"sex",
              @"token" : @"token"
            };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [LoginModel modelWithDictionary:dict];
}

- (NSString *) genderName {
    if ([self.gender isEqualToString:@"0"]) {
        return @"男";
    } else {
        return @"女";
    }
}

@end
