//
//  SignModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/11.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "SignModel.h"
#import "DateTool.h"

@implementation SignList

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    SignList *model = [SignList modelWithDictionary:dict];
    return model;
}

@end

@implementation SignModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    SignModel *model = [SignModel modelWithDictionary:dict];
    model.signList = [SignList convertFromArray:model.signList];
    
    model.isSign = !model.isSign;
    
    return model;
}

- (NSString *) currentDate {
    return [[DateTool sharedInstance] timeFormatWithMillisecondTimeStamp:_curDate format:@"yyyy年MM月"];
}

@end
