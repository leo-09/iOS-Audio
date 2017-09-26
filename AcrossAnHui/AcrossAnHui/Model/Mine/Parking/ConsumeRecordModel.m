//
//  ConsumeRecordModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ConsumeRecordModel.h"

@implementation ConsumeRecordModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{ @"desc" : @"description" };
}

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [ConsumeRecordModel modelWithDictionary:dict];
}

// 获取年月
- (NSString *) yearMonth {
    if (_addTime) {
        return [_addTime substringToIndex:7];
    } else {
        return @"--";
    }
}

// 获取月日
- (NSString *) monthDay {
    if (_addTime) {
        return [_addTime substringWithRange:NSMakeRange(5, 5)];
    } else {
        return @"--";
    }
}

@end


@implementation ConsumeRecordCollection

- (NSString *) month {
    if (!_yearMonth) {
        return @"";
    }
    
    int month = [[_yearMonth substringFromIndex:5] intValue];
    
    return [NSString stringWithFormat:@"%d月", month];
}

+ (NSMutableArray *) recordCollection:(NSMutableArray *)collection recordModels:(NSArray<ConsumeRecordModel *> *) records {
    
    // 没有记录 则直接返回
    if (!records || records.count == 0) {
        return collection;
    }
    
    if (!collection) {
        collection = [[NSMutableArray alloc] init];
    }
    
    BOOL isEqual;
    for (ConsumeRecordModel *record in records) {
        isEqual = NO;
        
        for (ConsumeRecordCollection *item in collection) {
            if ([[record yearMonth] isEqualToString:item.yearMonth]) {
                // 添加到相应的集合中
                [item.records addObject:record];
                
                isEqual = YES;
                break;
            }
        }
        
        if (!isEqual) {
            // record不在collection中，则新建RechargeRecordCollection，并添加到集合中
            ConsumeRecordCollection *item = [[ConsumeRecordCollection alloc] init];
            item.yearMonth = [record yearMonth];
            item.records = [[NSMutableArray alloc] init];
            [item.records addObject:record];
            
            [collection addObject:item];
        }
    }
    
    return collection;
}

@end
