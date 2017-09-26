//
//  CarInspectAgencyOrderTrackModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectAgencyOrderTrackModel.h"

@implementation CarInspectAgencyOrderTrackModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [CarInspectAgencyOrderTrackModel modelWithDictionary:dict];
}

- (NSString *) time {
    if (_opdate.length == 18) { // 缺少空格 2017-10-1010:10:10
        NSString *date = [_opdate substringWithRange:NSMakeRange(5, 5)];
        NSString *time = [_opdate substringWithRange:NSMakeRange(10, 5)];
        
        return [NSString stringWithFormat:@"%@ %@", date, time];
    } else {
        return [_opdate substringWithRange:NSMakeRange(5, 11)];
    }
}

@end
