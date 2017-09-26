//
//  AMapLocationModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

@interface AMapLocationModel : CTXBaseModel

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *formattedAddress;

@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double latitude;

+ (instancetype) defaultValue;

- (BOOL)isExistenceValue;
- (NSString *) areaAddress;

@end
