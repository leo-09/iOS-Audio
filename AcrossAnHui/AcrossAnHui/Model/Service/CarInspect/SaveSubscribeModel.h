//
//  SaveSubscribeModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/4.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 保存预约记录 的请求参数
 */
@interface SaveSubscribeModel : CTXBaseModel

@property (nonatomic, copy) NSString *carLisence;         // 车牌号
@property (nonatomic, copy) NSString *lastFrame;          // 车架号
@property (nonatomic, copy) NSString *paymethod;          // 支付方式；0：线上支付；1：线下支付
@property (nonatomic, copy) NSString *stationid;          // 车检站id
@property (nonatomic, copy) NSString *jdarea;             // 寄件地区id；（免检必传）
@property (nonatomic, copy) NSString *detailAddr;         // 寄件详细地址（免检必传）
@property (nonatomic, copy) NSString *sjareaid;           // 收件地区id（免检必传）
@property (nonatomic, copy) NSString *sjDetailAdd;        // 收件详细地址（免检必传）
@property (nonatomic, copy) NSString *contactPerson;      // 用户姓名
@property (nonatomic, copy) NSString *contactPhone;       // 联系电话
@property (nonatomic, copy) NSString *ordertimeid;        // 预约时间段id
@property (nonatomic, copy) NSString *isAutoReg;          // 是否自动注册；0：否；1：是
@property (nonatomic, copy) NSString *businessType;       // 业务类型(1:年检; 2:6年免检;3:车检代办)
@property (nonatomic, copy) NSString *carType;            // 车辆类型
@property (nonatomic, copy) NSString *subscribeDate;      // 预约时间(格式:yyyy-MM-dd HH:mm:ss)
@property (nonatomic, copy) NSString *avator;             // 头像地址
@property (nonatomic, copy) NSString *postCode;           // 寄件人邮编, 6年免检用到
@property (nonatomic, copy) NSString *sjPostCode;         // 收件人邮编, 6年免检用到
@property (nonatomic, copy) NSString *expressType;        // 快递方式 1-顺丰2-EMS;
@property (nonatomic, copy) NSString *sourcebu;           // 业务来源；(app端可以不传，wap端必传)
@property (nonatomic, copy) NSString *couponcodeid;       // 优惠码id
@property (nonatomic, copy) NSString *lng;                // 取车经度
@property (nonatomic, copy) NSString *lat;                // 取车纬度
@property (nonatomic, copy) NSString *hlng;               // 还车经度
@property (nonatomic, copy) NSString *hlat;               // 还车纬度

- (NSMutableDictionary *) toDictionary;

@end
