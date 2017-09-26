//
//  CarIllegalInfoModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarIllegalInfoModel.h"

// 违章信息总述
@implementation ViolationSummaryModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [ViolationSummaryModel modelWithDictionary:dict];
}

@end


// 违章详情
@implementation ViolationInfoModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [ViolationInfoModel modelWithDictionary:dict];
}

@end


// 违章信息Model
@implementation CarIllegalInfoModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    CarIllegalInfoModel *model = [CarIllegalInfoModel modelWithDictionary:dict];
    
    NSArray<ViolationInfoModel *> *jdcwfxxList = [ViolationInfoModel convertFromArray:model.jdcwfxxList];
    model.jdcwfxxList = jdcwfxxList;
    
    return model;
}

// 已交款
- (NSMutableArray<ViolationInfoModel *> *)alreadyPaid {
    if (!_alreadyPaid) {
        _alreadyPaid = [[NSMutableArray alloc] init];
        
        for (ViolationInfoModel *model in self.jdcwfxxList) {
            if ([model.jkbj isEqualToString:@"已交款"]) {
                [_alreadyPaid addObject:model];
            }
        }
    }
    
    return _alreadyPaid;
}

// 未交款
- (NSMutableArray<ViolationInfoModel *> *)notPaid {
    if (!_notPaid) {
        _notPaid = [[NSMutableArray alloc] init];
        
        for (ViolationInfoModel *model in self.jdcwfxxList) {
            if (![model.jkbj isEqualToString:@"已交款"]) {
                [_notPaid addObject:model];
            }
        }
    }
    
    return _notPaid;
}

@end
