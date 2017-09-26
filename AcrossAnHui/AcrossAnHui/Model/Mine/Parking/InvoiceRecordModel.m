//
//  InvoiceRecordModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/24.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "InvoiceRecordModel.h"

@implementation InvoiceRecordModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [InvoiceRecordModel modelWithDictionary:dict];
}

@end
