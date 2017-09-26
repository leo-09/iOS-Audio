//
//  HelpCenterModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "HelpCenterModel.h"

@implementation HelpCenterModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [HelpCenterModel modelWithDictionary:dict];
}

@end
