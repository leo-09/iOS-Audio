//
//  CarInspectAgencyDriverPostionModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectAgencyDriverPostionModel.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@implementation PositionModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    PositionModel *model = [PositionModel modelWithDictionary:dict];
    [model aMapCoordinateConvert];
    
    return model;
}

// 百度地图的经纬度转高德地图的经纬度
- (void) aMapCoordinateConvert {
    
    // 转换百度地图经纬度为高德坐标系
    CLLocationCoordinate2D amapcoord = AMapCoordinateConvert(CLLocationCoordinate2DMake(self.lat, self.lng), AMapCoordinateTypeBaidu);
    
    // 经纬度重新赋值为高德坐标系
    self.lat = amapcoord.latitude;
    self.lng = amapcoord.longitude;
}

@end

@implementation OrderStatesInfo

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [OrderStatesInfo modelWithDictionary:dict];
}

@end

@implementation CarInspectAgencyDriverPostionModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    CarInspectAgencyDriverPostionModel *model = [CarInspectAgencyDriverPostionModel modelWithDictionary:dict];
    
    model.arrive = [PositionModel convertFromArray:model.arrive];
    model.await = [PositionModel convertFromArray:model.await];
    model.drive = [PositionModel convertFromArray:model.drive];
    
    return model;
}

@end
