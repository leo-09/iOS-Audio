//
//  BoundCarModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/14.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "BoundCarModel.h"

@implementation BoundCarModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"carID" : @"id" };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [BoundCarModel modelWithDictionary:dict];
}

- (void) setNote:(NSString *)note {
    note = [note stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    note = [note stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    _note = note;
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
