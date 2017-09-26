//
//  SubscribeModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/4.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "SubscribeModel.h"

@implementation SubscribeModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [SubscribeModel modelWithDictionary:dict];
}

- (NSString *) orderMoney {
    return [NSString stringWithFormat:@"¥ %.2f元", self.payfee];
}

- (NSString *)orderDescription {
    NSString *desc = [NSString stringWithFormat:@"车牌号：%@\n联系人：%@\n订单号：%@\n手机号：%@\n申请时间：%@\n上门取件地址：%@\n收件地址：%@\n订单金额：%@\n", self.carLisence, self.contactPerson, self.businessCode, self.contactPhone, self.submitDate, self.detailAddr, self.sjDetailAdd, [self orderMoney]];
    
    return desc;
}

#pragma mark - public method

- (NSString *) payMethod {
    if (_paymethod == 0) {
        if (_payType == 0) {
            return @"支付宝支付";
        } else if (_payType == 1) {
            return @"银联支付";
        } else {
            return @"微信支付";
        }
    } else {
        return @"到车检站支付";
    }
}

- (NSString *)subscribeOrderDescription {
    NSString *time = [NSString stringWithFormat:@"%@  %@-%@", _orderDay, _startTime, _endTime];
    
    NSString *desc = [NSString stringWithFormat:@"\n订单编号：%@\n联系人：%@\n手机号：%@\n预约时间：%@\n车检站名称：%@\n车检站地址：%@\n支付方式：%@\n支付金额：%@\n", self.businessCode, self.contactPerson, self.contactPhone, time, self.stationName, self.stationAddr, [self payMethod], [self orderMoney]];
    
    return desc;
}

- (NSString *)freeOrderDescription {
    NSString *desc = [NSString stringWithFormat:@"\n订单号：%@\n联系人：%@\n手机号：%@\n申请时间：%@\n上门取件地址：%@\n收件地址：%@\n车检站名称：%@\n车检站地址：%@\n支付金额：%@\n", self.businessCode, self.contactPerson, self.contactPhone, self.submitDate, self.detailAddr, self.sjDetailAdd, self.stationName, self.stationAddr, [self orderMoney]];
    
    return desc;
}

- (NSString *) subscribeStatusDesc {
    NSArray *status = @[ @"已预约", @"已取消", @"已完成" ];
    NSArray *payStatus = @[ @"未支付", @"已支付", @"申请退款中", @"退款中", @"已退款" ];
    
    return [NSString stringWithFormat:@"%@%@", status[self.orderStatus], payStatus[self.payStatus]];
}

- (NSString *) freeStatusDesc {
    NSArray *status = @[ @"已申请", @"快递办理中", @"已办理", @"回寄中", @"已完成", @"已取消" ];
    NSArray *payStatus = @[ @"未支付", @"已支付", @"申请退款中", @"退款中", @"已退款" ];
    
    return [NSString stringWithFormat:@"%@%@", status[self.orderType - 1], payStatus[self.payStatus]];
}

#pragma mark - getter/setter

- (int) orderStatus {
    if (_orderStatus > 2) {
        return 2;
    }
    
    return _orderStatus;
}

- (int) payStatus {
    if (_payStatus > 4) {
        return 4;
    }
    
    return _payStatus;
}

- (int) orderType {
    if (_orderType > 6) {
        return 6;
    }
    
    return _orderType;
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
