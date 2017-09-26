//
//  AMapLocationModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "AMapLocationModel.h"

@implementation AMapLocationModel

+ (instancetype) defaultValue {
    AMapLocationModel *model = [[AMapLocationModel alloc] init];
    
    model.province = defaultProvice;
    model.city = defaultCity;
    
    model.latitude = defaultLatitude;
    model.longitude = defaultLongitude;
    
    return model;
}

- (BOOL) isExistenceValue {
    if (!self.province) {
        return NO;
    }
    
    if (!self.city) {
        return NO;
    }
    
    if (!self.district) {
        return NO;
    }
    
    if (!self.formattedAddress) {
        return NO;
    }
    
    if (!self.longitude) {
        return NO;
    }
    
    if (!self.latitude) {
        return NO;
    }
    
    return YES;
}

- (NSString *) areaAddress {
    NSString *result = _formattedAddress;
    
    if (_province) {
        result = [result stringByReplacingOccurrencesOfString:_province withString:@""];
    }
    
    if (_city) {
        result = [result stringByReplacingOccurrencesOfString:_city withString:@""];
    }
    
    return result;
}

@end
