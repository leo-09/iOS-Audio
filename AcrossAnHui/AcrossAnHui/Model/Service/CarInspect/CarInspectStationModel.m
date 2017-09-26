//
//  CarInspectStation.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/29.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectStationModel.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "HomeLocalData.h"

@implementation CarInspectWorkTime

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [CarInspectWorkTime modelWithDictionary:dict];
}

@end


@implementation CarInspectCarType

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [CarInspectCarType modelWithDictionary:dict];
}

@end


@implementation CarInspectStationModel

+ (instancetype) convertFromDict:(NSDictionary *)dict isCarInspectAgency:(BOOL)isAgency {
    CarInspectStationModel *model = [CarInspectStationModel modelWithDictionary:dict];
    model.carTypeList = [CarInspectCarType convertFromArray:model.carTypeList];
    model.workTimeList = [CarInspectWorkTime convertFromArray:model.workTimeList];
    
    if (!isAgency) {// 车检预约和六年免检需要转换坐标值，车检代办不需要转换
        [model aMapCoordinateConvert];
    }
    
    return model;
}

+ (NSMutableArray *) convertFromArray:(NSArray *)array isCarInspectAgency:(BOOL)isAgency {
    NSMutableArray *result = [[NSMutableArray array] init];
    for (NSDictionary *dict in array) {
        [result addObject: [self convertFromDict:dict isCarInspectAgency:isAgency]];
    }
    
    return result;
}

// 百度地图的经纬度转高德地图的经纬度
- (void) aMapCoordinateConvert {
    
    // 转换百度地图经纬度为高德坐标系
    CLLocationCoordinate2D amapcoord = AMapCoordinateConvert(CLLocationCoordinate2DMake(self.latitude, self.longitude), AMapCoordinateTypeBaidu);
    
    // 经纬度重新赋值为高德坐标系
    self.latitude = amapcoord.latitude;
    self.longitude = amapcoord.longitude;
    
    // 高德坐标系的位置
    MAMapPoint point1 = MAMapPointForCoordinate(amapcoord);
    
    // 当前位置
    AMapLocationModel *locationModel = [[HomeLocalData sharedInstance] getAMapLocationModel];
    MAMapPoint currentPoint = MAMapPointForCoordinate(CLLocationCoordinate2DMake(locationModel.latitude, locationModel.longitude));
    
    // 计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1, currentPoint);
    self.distance1 = [NSString stringWithFormat:@"%.2f", distance / 1000];
}

@end
