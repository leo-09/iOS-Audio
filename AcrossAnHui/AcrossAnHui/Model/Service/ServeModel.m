//
//  ServeModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ServeModel.h"

@implementation ServeModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [ServeModel modelWithDictionary:dict];
}

- (NSString *) serveModelToJSONString {
    return [self modelToJSONString];
}

/**
 选中状态对应的图

 @return  选中：   0:delete； 1:selected
          没选中： 2:add
 */
- (NSString *) selectStatusImage {
    if (self.selectStatus == CAN_DELETE_STATUS) {
        return @"delete";
    } else if (self.selectStatus == SELECTED_STATUS) {
        return @"selected";
    } else {
        return @"add";
    }
}

- (Class) getNSClassFromString {
    if (self.targetInstance && ![self.targetInstance isEqualToString:@""]) {
        return NSClassFromString(self.targetInstance);
    } else {
        return nil;
    }
}

@end


@implementation ServeSuperModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    ServeSuperModel *superModel = [ServeSuperModel modelWithJSON:dict];
    superModel.serveArray = [ServeModel convertFromArray:superModel.serveArray];
    return superModel;
}

- (NSString *) serveModelToJSONString {
    return [self modelToJSONString];
}

@end
