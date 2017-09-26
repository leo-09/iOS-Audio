//
//  CarFriendGoodResultModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/3.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarFriendGoodResultModel.h"

@implementation CarFriendGoodResultModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    CarFriendGoodResultModel *model = [CarFriendGoodResultModel modelWithDictionary:dict];
    model.data = [CarFriendHeadImageModel convertFromArray:model.data];
    
    return model;
}

@end
