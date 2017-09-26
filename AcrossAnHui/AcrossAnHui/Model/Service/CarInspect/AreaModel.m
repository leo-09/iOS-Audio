//
//  AreaModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/29.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "AreaModel.h"


@implementation VillageModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [VillageModel modelWithDictionary:dict];
}

@end


@implementation TownModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    TownModel *model = [TownModel modelWithDictionary:dict];
    
    model.village = [VillageModel convertFromArray:model.village];
    return model;
}

@end


@implementation AreaModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    AreaModel *model = [AreaModel modelWithDictionary:dict];
    
    model.town = [TownModel convertFromArray:model.town];
    return model;
}

@end

@implementation CarFreeInspectAddressModel

@end
