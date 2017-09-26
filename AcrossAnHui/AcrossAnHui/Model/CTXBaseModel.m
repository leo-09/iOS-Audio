//
//  CTXBaseModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

@implementation CTXBaseModel

+ (instancetype) convertFromDict:(NSDictionary *)dict {
    return [CTXBaseModel modelWithDictionary:dict];
}

+ (NSMutableArray *) convertFromArray:(NSArray *)array {
    NSMutableArray *result = [[NSMutableArray array] init];
    
    if (!array || array.count == 0) {
        return result;
    }
    
    for (NSDictionary *dict in array) {
        [result addObject: [self convertFromDict:dict]];
    }
    
    return result;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone *)zone {
    return [self modelCopy];
}

- (NSUInteger)hash {
    return [self modelHash];
}

- (BOOL)isEqual:(id)object {
    return [self modelIsEqual:object];
}

- (NSString *)description {
    return [self modelDescription];
}

@end
