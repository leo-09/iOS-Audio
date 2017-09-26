//
//  CarInspectModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

typedef enum {
    // 车检查询接口／免检查询接口 共同的状态码
    CarInspectStatus_account = 501,         // 账号不能为空
    CarInspectStatus_psw = 502,             // 密码不能为空
    CarInspectStatus_plateType = 504,       // 号牌种类不能为空
    CarInspectStatus_plateNumber = 505,     // 号牌号码不能为空
    CarInspectStatus_frameNumber = 506,     // 车架号后六位不能为空
    CarInspectStatus_accountPsw = 507,      // 接口账号或密码不正确
    CarInspectStatus_carInfo = 508,         // 您的车辆信息输入有误，请核对车辆信息
    
    CarInspectStatus_network = 512,         // 网络连接失败，请稍后重试
    
    CarInspectStatus_illegal = 513,         // 您还有未处理的违章信息
    CarInspectStatus_threeMonth = 519,      // 您的车辆需在机动车检验有效期前三个月内才可以申请车检
    
    // 车检查询接口 独有的状态码
    CarInspectStatus_noIllegal = 204,       // 您没有未处理的违章信息
    
    // 免检查询接口 独有的状态码
    CarInspectStatus_nonConformity = 514,   // 您的车辆不属于非营运小型车辆，不符合申请6年免检
    CarInspectStatus_endDate = 515,         // 您的交强险结束日期不正确，不符合申请6年免检
    CarInspectStatus_beyondDate = 516,      // 您的车辆下次年检日期已超出车辆注册登记日期6年期限，不符合申请6年免检
    CarInspectStatus_trafficAccident = 517, // 您的车辆发生过造成人员伤亡的交通事故，不符合申请6年免检
    CarInspectStatus_mayConformity = 518,   // 可能符合申请6年免检（未填写交强险日期的车检用户）
    CarInspectStatus_conformity = 205,      // 符合申请6年免检（填写交强险日期的申请6年免检用户）
    
} CarInspectStatus;

/**
 年检违章/六年免检查询
 */
@interface CarInspectModel : CTXBaseModel

@property (nonatomic, assign) CarInspectStatus status;
@property (nonatomic, copy) NSString *info;

/**
 不符合申请6年免检

 @return YES：不符合申请6年免检
 */
- (BOOL) nonConformityCarFreeInspect;

@end


