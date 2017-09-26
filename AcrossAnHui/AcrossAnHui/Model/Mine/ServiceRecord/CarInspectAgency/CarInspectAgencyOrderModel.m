//
//  CarInspectAgencyOrderModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/16.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectAgencyOrderModel.h"

@implementation DBCommentModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"commentID" : @"id"
              };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [DBCommentModel modelWithDictionary:dict];
}

@end


@implementation DBCarInfoModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"carInfoNewLevel" : @"newLevel"
              };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [DBCarInfoModel modelWithDictionary:dict];
}

@end


@implementation CarInspectAgencyOrderModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [CarInspectAgencyOrderModel modelWithDictionary:dict];
}

- (NSString *) firstWaitPayTimeStr {
    // 获取倒计时时间
    int secondCount = self.waitPayTime / 1000;
    int minute = secondCount / 60;
    int second = secondCount % 60;
    
    if (minute > 0) {
        return [NSString stringWithFormat:@"%@分%@秒", [self twoStr:minute], [self twoStr:second]];
    } else {
        return [NSString stringWithFormat:@"%@秒", [self twoStr:second]];
    }
}

- (NSString *) waitPayTimeStr {
    // 获取倒计时时间
    int secondCount = self.waitPayTime / 1000;
    int minute = secondCount / 60;
    int second = secondCount % 60;
    
    // 剪一秒后，重新赋值
    self.waitPayTime = self.waitPayTime - 1000;// 每秒=1000毫秒
    if (self.waitPayTime < 0) {
        self.waitPayTime = 0;
    }
    
    if (minute > 0) {
        return [NSString stringWithFormat:@"%@分%@秒", [self twoStr:minute], [self twoStr:second]];
    } else {
        return [NSString stringWithFormat:@"%@秒", [self twoStr:second]];
    }
}

- (NSString *) waitDriverTimeStr {
    // 获取倒计时时间
    int secondCount = self.waitDriveTime / 1000;
    int hour = secondCount / 3600;
    int minute = (secondCount - hour * 3600) / 60;
    int second = secondCount - hour * 3600 - minute * 60;
    
    // 剪一秒后，重新赋值
    self.waitDriveTime = self.waitDriveTime - 1000;// 每秒=1000毫秒
    if (self.waitDriveTime < 0) {
        self.waitDriveTime = 0;
    }
    
    if (hour > 0) {
        return [NSString stringWithFormat:@"%@ : %@ : %@", [self twoStr:hour], [self twoStr:minute], [self twoStr:second]];
    } else if (minute > 0) {
        return [NSString stringWithFormat:@"00 : %@ : %@", [self twoStr:minute], [self twoStr:second]];
    } else {
        return [NSString stringWithFormat:@"00 : 00 : %@", [self twoStr:second]];
    }
}

- (NSString *) businessCodeText {
    return [NSString stringWithFormat:@"订单编号：%@", (self.businessCode ? self.businessCode : @"")];
}

- (NSString *) businessInfoText {
    return [NSString stringWithFormat:@"下单时间：%@\n联系人：%@\n联系电话：%@\n车牌号：%@\n车检站：%@\n取车地址：%@\n预约取车时间：%@",
            self.submitDate, self.contactPerson, self.contactPhone, [self formatPlateNumber], self.stationName, self.detailAddr, self.subscribeDate];
}

- (BOOL) isOrderWorking {
    // 司机已开启订单 ---> 订单完成
    if (self.carInfo.idCard &&
        (self.status == EOrderStatus_Open_Order ||
         self.status == EOrderStatus_Driver_Arrived ||
         self.status == EOrderStatus_Driver_Driving ||
         self.status == EOrderStatus_Driver_Destination ||
         self.status == EOrderStatus_Driver_TakeCar)) {
            
            return YES;
        }
    
    return NO;
}

- (BOOL) isOrderWorkingForCell {
    // 司机已开启订单 ---> 订单完成
    if (self.carInfo.idCard &&
        (self.status == EOrderStatus_Open_Order ||
         self.status == EOrderStatus_Driver_Arrived ||
         self.status == EOrderStatus_Driver_Driving ||
         self.status == EOrderStatus_Driver_Destination ||
         self.status == EOrderStatus_Driver_TakeCar)) {
            
            return YES;
        }
    
    return NO;
}

- (BOOL) isWaitDriver {
    if (self.waitDriveTime > 0 &&
        (self.status == EOrderStatus_Default ||
         self.status == EOrderStatus_Sure_Order ||
         self.status == EOrderStatus_Waiting_Order ||
         self.status == EOrderStatus_Received_Order)) {
         
            return YES;
        }
    
    return NO;
}

- (BOOL) isWaitPay {
    // 未支付 未取消 等待支付时间大于0
    if (self.payStatus == PayStatus_NoPay &&
        self.status != EOrderStatus_Cancel_Order &&
        self.status != EOrderStatus_Canceling_Order &&
        self.waitPayTime > 0) {
        
        return YES;
    }
    
    return NO;
}

- (NSString *) twoStr:(int) num {
    if (num < 10) {
        return [NSString stringWithFormat:@"0%d", num];
    } else {
        return [NSString stringWithFormat:@"%d", num];
    }
}

- (NSString *) formatPlateNumber {
    if (_carLisence && _carLisence.length > 3) {
        NSString *newplateNumber = [_carLisence stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSMutableString *pn = [[NSMutableString alloc] initWithString:newplateNumber];
        [pn insertString:@" " atIndex:2];
        return pn;
    } else {
        return _carLisence;
    }
}

@end
