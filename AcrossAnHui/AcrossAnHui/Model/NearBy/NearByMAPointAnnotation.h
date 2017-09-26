//
//  NearByMAPointAnnotation.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/31.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

/**
 附近 地图上的点
 */
@interface NearByMAPointAnnotation : MAPointAnnotation<NSCoding>

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *tag;

@end
