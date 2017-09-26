//
//  CarInspectAgencyDriverPostionModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 位置：经纬度
 */
@interface PositionModel : CTXBaseModel

@property (nonatomic, assign) double lng;
@property (nonatomic, assign) double lat;

@end

@interface OrderStatesInfo : CTXBaseModel

@property (nonatomic, retain) PositionModel *arrivePos;     // 就位位置
@property (nonatomic, retain) PositionModel *acceptPos;     // 接单位置
@property (nonatomic, retain) PositionModel *drivePos;      // 开车位置
@property (nonatomic, retain) PositionModel *finishPos;     // 完成位置
@property (nonatomic, retain) PositionModel *currentPos;    // 当前位置

@end

/**
 司机轨迹
 */
@interface CarInspectAgencyDriverPostionModel : CTXBaseModel

@property (nonatomic, copy) NSString *acceptTime;     // 接单时间（毫秒）
@property (nonatomic, copy) NSString *driveTime;      // 开车时间（毫秒）
@property (nonatomic, copy) NSString *arriveTime;     // 就位时间（毫秒）
@property (nonatomic, copy) NSString *finishTime;     // 完成时间（毫秒）
@property (nonatomic, copy) NSString *lastTime;       // 最后路径点时间（毫秒）

@property (nonatomic, retain) OrderStatesInfo *orderStatesInfo;

@property (nonatomic, retain) NSArray<PositionModel *> *arrive;     // 接单到就位间的坐标点集合
@property (nonatomic, retain) NSArray<PositionModel *> *await;      // 就位到开车间的坐标点集合
@property (nonatomic, retain) NSArray<PositionModel *> *drive;      // 开车到完成间的坐标点集合

@end
