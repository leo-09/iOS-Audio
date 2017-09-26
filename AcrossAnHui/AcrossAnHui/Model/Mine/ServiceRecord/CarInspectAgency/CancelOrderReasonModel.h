//
//  CancelOrderReasonModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 车检代办取消原因
 */
@interface CancelOrderReasonModel : CTXBaseModel

@property (nonatomic, copy) NSString *cancelID;
@property (nonatomic, copy) NSString *sort;       // 排序
@property (nonatomic, copy) NSString *reson;      // 原因

@property (nonatomic, assign) BOOL isSelect;

@end
