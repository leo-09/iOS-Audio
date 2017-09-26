//
//  BoundCarModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/14.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

static NSString *Compact_Car_PlateType = @"02";// 小型汽车

/**
 绑定的车辆
 */
@interface BoundCarModel : CTXBaseModel

@property (nonatomic, copy) NSString *carImgPath;             // 车图标地址
@property (nonatomic, copy) NSString *imgPath;                // 小图标
@property (nonatomic, copy) NSString *carType;                // 车辆类型
@property (nonatomic, copy) NSString *defaultCar;             // 默认车辆
@property (nonatomic, copy) NSString *frameNumber;            // 车架号
@property (nonatomic, copy) NSString *carID;                  // id
@property (nonatomic, copy) NSString *inspectionReminder;     // 是否年检提醒:1、0，暂时不做
@property (nonatomic, copy) NSString *name;                   // 车型车系，比如大众
@property (nonatomic, copy) NSString *note;                   // 备注
@property (nonatomic, copy) NSString *plateNumber;            // 车牌照  唯一
@property (nonatomic, copy) NSString *plateType;              // 号牌类型 // 01 02
@property (nonatomic, copy) NSString *success;                // 1 数据获取成功  否则失败
@property (nonatomic, copy) NSString *userId;                 // 用户id,返回的列表里每一个字典里userId都是一样的，对应同一个用户

@property (nonatomic, assign) BOOL isShowSelect;
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) BOOL isParkingCar;                // 是否绑定停车

// 格式化车牌
- (NSString *) formatPlateNumber;

@end
