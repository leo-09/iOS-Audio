//
//  RefundOrderReasonModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"
#import "CancelOrderReasonModel.h"

@interface RefundOrderReasonModel : CTXBaseModel

@property (nonatomic, retain) NSArray<CancelOrderReasonModel *> *reson_list;    // 原因列表：2级JSON数组,data下属
@property (nonatomic, copy) NSString *money;              // 退款金额
@property (nonatomic, copy) NSString *return_type;        // 退款类型
@property (nonatomic, copy) NSString *return_desc;        // 退款描述

@end
