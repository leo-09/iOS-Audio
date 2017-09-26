//
//  CarInspectAgencyOrderModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/16.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

typedef enum PayStatus {
    PayStatus_NoPay = 0,        // 未支付
    PayStatus_Paid = 1,         // 已支付
    PayStatus_Apply_Refund,     // 申请退款中
    PayStatus_Refunding,        // 退款中
    PayStatus_Refunded,         // 已退款
} PayStatus;

typedef enum EOrderStatus {
    EOrderStatus_Sure_Order = 0,            // 已下单
    EOrderStatus_Waiting_Order = 6,         // 等待司机接单
    EOrderStatus_Received_Order = 4,        // 司机已接单
    
    EOrderStatus_Customer_Order = 200,      // 等待客服派单
    
    EOrderStatus_Open_Order = 7,            // 司机已开启订单
    EOrderStatus_Driver_Arrived = 8,        // 司机已就位
    EOrderStatus_Driver_Driving = 11,       // 司机开车中
    
    EOrderStatus_Driver_Destination = 12,   // 司机到达目的地
    EOrderStatus_Driver_TakeCar = 50,       // 已收车
    
    EOrderStatus_Completed_Order = 55,      // 订单已完成
    
    EOrderStatus_Blocked_Funds = 2,         // 资金已冻结
    EOrderStatus_Canceling_Order = 100,     // 订单取消中
    EOrderStatus_Cancel_Order = 5,          // 订单取消
    
    EOrderStatus_Delete_Order = -1,         // 已作废
    EOrderStatus_Default = -2
} EOrderStatus;

@interface DBCommentModel : CTXBaseModel

@property (nonatomic, copy) NSString *commentID;          // 评论id
@property (nonatomic, copy) NSString *orderid;
@property (nonatomic, copy) NSString *driverPhone;        // 司机号码
@property (nonatomic, copy) NSString *attitude;           // 司机态度评分
@property (nonatomic, copy) NSString *speed;              // 司机速度评分
@property (nonatomic, copy) NSString *status;             // 评论状态是否公开 0不公开 1公开
@property (nonatomic, copy) NSString *content;            // 评论类容

@end


@interface DBCarInfoModel : CTXBaseModel

@property (nonatomic, copy) NSString *idCard;                 // 司机身份证
@property (nonatomic, copy) NSString *name;                   // 司机名
@property (nonatomic, copy) NSString *driverPhone;            // 司机手机
@property (nonatomic, copy) NSString *year;                   // 司机驾龄
@property (nonatomic, copy) NSString *carInfoNewLevel;        // 司机星级
@property (nonatomic, copy) NSString *orderId;

@end


/**
 订单详情
 */
@interface CarInspectAgencyOrderModel : CTXBaseModel

@property (nonatomic, copy) NSString *businessCode;             // 订单号
@property (nonatomic, copy) NSString *businessid;               // 订单ID
@property (nonatomic, retain) DBCarInfoModel *carInfo;          // 司机对象
@property (nonatomic, copy) NSString *carLisence;               // 车牌
@property (nonatomic, retain) DBCommentModel *comment;          // 评论对象
@property (nonatomic, copy) NSString *contactPerson;            // 联系人
@property (nonatomic, copy) NSString *contactPhone;             // 联系人电话
@property (nonatomic, copy) NSString *detailAddr;               // 地址

@property (nonatomic, copy) NSString *isDriverPosition;         // 司机位置信息 0没有 1有
@property (nonatomic, copy) NSString *orderid;                  // e代驾id
@property (nonatomic, assign) PayStatus payStatus;              // 看 支付码表
@property (nonatomic, assign) double payfee;                    // 支付金额
@property (nonatomic, copy) NSString *stationName;              // 车检站名
@property (nonatomic, assign) EOrderStatus status;              // 订单状态
//@property (nonatomic, assign) EOrderStatus oldStatus;         // 订单状态
@property (nonatomic, copy) NSString *statusName;               // 订单状态名
@property (nonatomic, copy) NSString *submitDate;               // 订单提交时间
@property (nonatomic, copy) NSString *subscribeDate;            // 预约时间
@property (nonatomic, assign) int waitDriveTime;                // 等待司机时间
@property (nonatomic, assign) int waitPayTime;                  // 等待支付时间
@property (nonatomic, copy) NSString *pictureMiddle;            // 司机头像
@property (nonatomic, copy) NSString *couponcodeid;             // 优惠码id

- (NSString *) firstWaitPayTimeStr;
- (NSString *) waitPayTimeStr;
- (NSString *) waitDriverTimeStr;
- (NSString *) businessCodeText;
- (NSString *) businessInfoText;

// 订单正在进行中：YES; 否则：NO
- (BOOL) isOrderWorking;
- (BOOL) isOrderWorkingForCell;
// 等待司机接单
- (BOOL) isWaitDriver;
// 等待支付
- (BOOL) isWaitPay;

// 格式化车牌号
- (NSString *) formatPlateNumber;

@end
