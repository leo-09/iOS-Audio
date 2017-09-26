//
//  StationCommentModel.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/10.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "StationCommentModel.h"

@implementation StationCommentModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [StationCommentModel modelWithDictionary:dict];
}

@end
