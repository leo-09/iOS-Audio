//
//  RefundOrderReasonModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "RefundOrderReasonModel.h"

@implementation RefundOrderReasonModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    RefundOrderReasonModel *model = [RefundOrderReasonModel modelWithDictionary:dict];
    model.reson_list = [CancelOrderReasonModel convertFromArray:model.reson_list];
    
    return model;
}

@end
