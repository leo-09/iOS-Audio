//
//  AreaModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/29.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

@interface VillageModel : CTXBaseModel

@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *areaid;

@end


@interface TownModel : CTXBaseModel

@property (nonatomic, retain) NSArray<VillageModel *> *village;
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *areaid;

@end


/**
 全国地区
 */
@interface AreaModel : CTXBaseModel

@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *areaid;
@property (nonatomic, retain) NSArray<TownModel *> *town;

@end



/**
 界面使用的类
 */
@interface CarFreeInspectAddressModel : CTXBaseModel

@property (nonatomic, assign) int currentCityIndex;     // 选中的城市下标
@property (nonatomic, assign) int currentTownIndex;     // 选中的区县下标

@property (nonatomic, retain) TownModel *currentCity;   // 选中的城市
@property (nonatomic, retain) VillageModel *currentTown;// 选中的区县

@property (nonatomic, copy) NSString *addrInfo;       // 详细地址

@end
