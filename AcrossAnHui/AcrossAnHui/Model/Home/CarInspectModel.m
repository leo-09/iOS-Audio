//
//  CarInspectModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectModel.h"

@implementation CarInspectModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [CarInspectModel modelWithDictionary:dict];
}


- (BOOL) nonConformityCarFreeInspect {
    if (self.status == CarInspectStatus_nonConformity ||
        self.status == CarInspectStatus_beyondDate ||
        self.status == CarInspectStatus_trafficAccident) {
        
        return YES;
    } else {
        return NO;
    }
}

@end
