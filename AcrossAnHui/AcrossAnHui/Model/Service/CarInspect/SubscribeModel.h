//
//  SubscribeModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/4.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"
#import <UIKit/UIKit.h>

/**
 保存预约记录 成功的返回数据
 */
@interface SubscribeModel : CTXBaseModel

@property (nonatomic, copy) NSString *startTime;                // 开始时间
@property (nonatomic, copy) NSString *endTime;                  // 结束时间

@property (nonatomic, copy) NSString *carLisence;               // 车牌号
@property (nonatomic, copy) NSString *carType;                  // 车辆类型
@property (nonatomic, copy) NSString *carTypeName;              // 车辆类型
@property (nonatomic, copy) NSString *lastFrame;                // 车驾号后六位

@property (nonatomic, copy) NSString *insuranceStart;           // 交强险开始时间
@property (nonatomic, copy) NSString *insuranceEnd;             // 交强险结束日期

@property (nonatomic, copy) NSString *businessType;             // 业务类型1-车检;2-6年免检;3-车检代办
@property (nonatomic, copy) NSString *businessCode;             // 订单编号
@property (nonatomic, copy) NSString *businessid;               // 订单id
@property (nonatomic, copy) NSString *orderDay;                 // 订单时间
@property (nonatomic, assign) int orderStatus;                  // 订单状态 0:已预约；1：已取消；2:已完成
@property (nonatomic, assign) int orderType;                    // 订单状态

@property (nonatomic, copy) NSString *contactPerson;            // 联系人
@property (nonatomic, copy) NSString *contactPhone;             // 联系电话
@property (nonatomic, assign) double cjPrice;                   // 车检金额

@property (nonatomic, copy) NSString *sjareaid;                 // 寄件区域id
@property (nonatomic, copy) NSString *detailAddr;               // 寄件详细地址
@property (nonatomic, copy) NSString *sjDetailAdd;              // 收件详细地址
@property (nonatomic, copy) NSString *areaid;                   // 寄件地址id

@property (nonatomic, copy) NSString *expressType;              // 物流类型1-EMS 2-邮政

@property (nonatomic, copy) NSString *emsBackMailNum;           // 邮政返程运单号
@property (nonatomic, copy) NSString *emsMailNum;               // 邮政寄件运单号
@property (nonatomic, copy) NSString *sjPostCode;               // 收件邮编
@property (nonatomic, copy) NSString *postCode;                 // 寄件邮编
@property (nonatomic, assign) double mjPrice2;                  // 邮政免检费用

@property (nonatomic, copy) NSString *sfOperationDate;          // 顺丰操作时间
@property (nonatomic, copy) NSString *flowid;                   // 顺丰物流流水号
@property (nonatomic, copy) NSString *sfOrderNo;                // 顺丰回寄运单号
@property (nonatomic, copy) NSString *reflowid;                 // 顺丰回寄流水号
@property (nonatomic, copy) NSString *sfOrderStateDesc;         // 顺丰订单状态描述
@property (nonatomic, copy) NSString *sendBno;                  // 顺丰运单号
@property (nonatomic, copy) NSString *sfOrderState;             // 顺丰订单状态
@property (nonatomic, assign) double mjPrice;                   // 顺丰金额

@property (nonatomic, copy) NSString *ordertimeid;              // 预约时间段id
@property (nonatomic, copy) NSString *owerAddrid;               // 地址信息id

@property (nonatomic, copy) NSString *paymethod;                // 支付方式0-线上支付1-线下支付
@property (nonatomic, assign) double personyh;                  // 车主优惠金额

@property (nonatomic, assign) int payStatus;                    // 支付状态 0:未支付；1：已支付;2:申请退款中;3退款中;4:已退款；
@property (nonatomic, assign) int payType;                      // 支付类型 0:支付宝；1：银联；2：微信支付；
@property (nonatomic, assign) double payfee;                    // 支付金额
@property (nonatomic, copy) NSString *payflowid;                // 支付流水号

// 业务来源字典:504-App;506-PC;564-WAP_畅行安徽公众号;565-WAP_支付宝;566-WAP_中国平安;569-WAP_安徽省交警总队...
@property (nonatomic, copy) NSString *sourcebu;
@property (nonatomic, copy) NSString *sourcebuName;             // 业务来源名称
@property (nonatomic, assign) double sportsyh;                  // 平台优惠金额

@property (nonatomic, copy) NSString *stationid;                // 车检站id
@property (nonatomic, copy) NSString *stationName;              // 车检站名称
@property (nonatomic, copy) NSString *stationAddr;              // 车检站地址
@property (nonatomic, copy) NSString *stationPic;               // 车检站图片

@property (nonatomic, copy) NSString *submitDate;               // 提交时间
@property (nonatomic, copy) NSString *submitUserid;             // 提交用户id

@property (nonatomic, copy) NSString *totalCount;               // 总数量

@property (nonatomic, copy) NSString *orderid;                  // 车检代办E代驾订单id
@property (nonatomic, copy) NSString *couponcodeid;             // 优惠码id
@property (nonatomic, copy) NSString *reasonid;                 // 取消原因id,多个逗号分隔

@property (nonatomic, assign) int isEvaluate;                   // 是否评价；1：已评价；0：未评价；

//@property (nonatomic, copy) NSString *hlat;
//@property (nonatomic, copy) NSString *hlng;
//@property (nonatomic, copy) NSString *lat;
//@property (nonatomic, copy) NSString *lng;
//@property (nonatomic, copy) NSString *reciveStyle;              // 收件方式

// 该Model对应的Cell高度
@property (nonatomic, assign) CGFloat cellHeight;

// 订单描述
- (NSString *)orderDescription;

// 支付金额
- (NSString *) orderMoney;

// 车检预约订单的描述
- (NSString *)subscribeOrderDescription;

// 六年免检的订单描述
- (NSString *)freeOrderDescription;

// 订单状态描述
- (NSString *) subscribeStatusDesc;
- (NSString *) freeStatusDesc;

// 格式化车牌
- (NSString *) formatPlateNumber;

@end
