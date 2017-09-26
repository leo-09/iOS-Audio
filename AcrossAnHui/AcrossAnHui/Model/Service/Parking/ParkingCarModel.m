//
//  ParkingCarModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ParkingCarModel.h"

@implementation ParkingCarModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"parkingCarID" : @"id" };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [ParkingCarModel modelWithDictionary:dict];
}

// 欠费状态:0:欠费 1:不欠费
- (BOOL) isArrearage {
    if (_btype && [_btype isEqualToString:@"0"]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *) imgurl {
    return (_imgurl ? _imgurl : @"");
}

// 获取停车时间的 时间戳
- (int) parkingTimeInterval {
    // 计算进场时间的时间戳
    if (startTimeInterval == 0) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 给NSDateFormatter设置时区
        formatter.timeZone = [NSTimeZone localTimeZone];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        
        NSDate *date;
        if (!_startTime || [_startTime isEqualToString:@""]) {
            date = [NSDate date];
        } else {
            date = [formatter dateFromString:_startTime];
        }
        
        // 进场时间的时间戳(秒)
        startTimeInterval = [date timeIntervalSince1970];
    }
    
    // 获取当前时间的时间戳 (秒)
    NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
    
    // 计算差值(秒)
    int secondCount = (int) (currentInterval - startTimeInterval);
    
    return (secondCount > 0) ? secondCount : 0;
}

// 获取停车时间的 HH:MM:SS
- (NSString *) parkingTimeDescWithSecondCount:(int) secondCount {
    int hour = secondCount / 3600;
    int minute = (secondCount - hour * 3600) / 60;
    int second = secondCount - hour * 3600 - minute * 60;
    
    if (hour > 0) {
        return [NSString stringWithFormat:@"%@ : %@ : %@", [self twoStr:hour], [self twoStr:minute], [self twoStr:second]];
    } else if (minute > 0) {
        return [NSString stringWithFormat:@"00 : %@ : %@", [self twoStr:minute], [self twoStr:second]];
    } else {
        return [NSString stringWithFormat:@"00 : 00 : %@", [self twoStr:second]];
    }
}

- (NSString *) twoStr:(int) num {
    if (num < 10) {
        return [NSString stringWithFormat:@"0%d", num];
    } else {
        return [NSString stringWithFormat:@"%d", num];
    }
}

- (NSString *) formatPlateNumber {
    if (_plateNumber && _plateNumber.length > 3) {
        NSString *newplateNumber = [_plateNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSMutableString *pn = [[NSMutableString alloc] initWithString:newplateNumber];
        [pn insertString:@" " atIndex:2];
        return pn;
    } else {
        return _plateNumber;
    }
}

@end
