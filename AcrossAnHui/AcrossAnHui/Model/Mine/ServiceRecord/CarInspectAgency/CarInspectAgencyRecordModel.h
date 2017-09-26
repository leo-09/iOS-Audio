//
//  CarInspectAgencyRecordModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/16.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"
#import <UIKit/UIKit.h>
#import "CarInspectAgencyOrderModel.h"

/**
 车检代办 记录的model
 */
@interface CarInspectAgencyRecordModel : CTXBaseModel

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) NSInteger row;

@property (nonatomic, retain) CarInspectAgencyOrderModel *orderDetail;  // 订单详情对象

// 以下字段都是在orderDetail中,统一到orderDetail取值
//@property (nonatomic, copy) NSString *businessid;             // 业务id
//@property (nonatomic, copy) NSString *orderid;                // e代驾订单id
//@property (nonatomic, assign) PayStatus payStatus;            // 支付状态
//@property (nonatomic, copy) NSString *stationName;
//@property (nonatomic, copy) NSString *submitDate;             // 订单提交日期
//@property (nonatomic, assign) EOrderStatus status;            // 看 e代驾码表
//@property (nonatomic, copy) NSString *statusName;             // 状态名
//@property (nonatomic, copy) NSString *waitPayTime;            // 等待支付时间（毫秒）

@end
