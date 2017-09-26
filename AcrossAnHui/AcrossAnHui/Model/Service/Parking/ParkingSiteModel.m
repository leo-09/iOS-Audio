//
//  ParkingSiteModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/20.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ParkingSiteModel.h"

@implementation ParkingSiteModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    ParkingSiteModel *model = [ParkingSiteModel modelWithDictionary:dict];
    model.siteList = [SiteModel convertFromArray:model.siteList];
    
    return model;
}

@end
