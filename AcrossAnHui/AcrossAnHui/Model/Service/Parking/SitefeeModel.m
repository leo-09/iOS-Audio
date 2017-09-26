//
//  SitefeeModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/20.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "SitefeeModel.h"

@implementation SitefeeModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    SitefeeModel *model = [SitefeeModel modelWithDictionary:dict];
    
    return model;
}

@end
