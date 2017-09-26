//
//  UserTipModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "UserTipModel.h"

@implementation UserTipModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [UserTipModel modelWithDictionary:dict];
}

@end
