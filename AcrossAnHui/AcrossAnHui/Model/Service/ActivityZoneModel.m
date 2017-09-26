//
//  ActivityZoneModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/24.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ActivityZoneModel.h"
#import "NetURLManager.h"

@implementation ActivityZoneModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    ActivityZoneModel *model = [ActivityZoneModel modelWithDictionary:dict];
    
    // 设置imgPath完整路径
    [model setImgPath:[NSString stringWithFormat:@"%@%@", MainHost, model.imgPath]];
    
    return model;
}

- (NSString *) remark {
    return (_remark ? _remark : @"");
}

@end
