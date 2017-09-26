//
//  CTXBaseModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<YYModel/YYModel.h>)
    FOUNDATION_EXPORT double YYModelVersionNumber;
    FOUNDATION_EXPORT const unsigned char YYModelVersionString[];
    #import <YYModel/NSObject+YYModel.h>
    #import <YYModel/YYClassInfo.h>
#else
    #import "NSObject+YYModel.h"
    #import "YYClassInfo.h"
#endif

/**
 model的基类
 */
@interface CTXBaseModel : NSObject<NSCoding, NSCopying>

+ (instancetype) convertFromDict:(NSDictionary *)dict;
+ (NSMutableArray *) convertFromArray:(NSArray *)array;

@end
