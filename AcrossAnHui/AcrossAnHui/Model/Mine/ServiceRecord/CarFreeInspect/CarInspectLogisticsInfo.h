//
//  CarInspectLogisticsInfo.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/21.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 物流信息
 */
@interface CarInspectLogisticsInfo : CTXBaseModel

@property (nonatomic, copy) NSString *type;                 // 物流类型1-顺丰2-EMS
@property (nonatomic, copy) NSString *type_desc;            // 物流描述
@property (nonatomic, copy) NSString *tel;                  // 物流电话
@property (nonatomic, copy) NSString *businessid;           // 订单id
@property (nonatomic, copy) NSString *businessCode;         // 订单 编号

- (NSString *)typeName;

@end
