//
//  CarFriendMAPointAnnotation.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

/**
 问小畅、随手拍 和报路况 选择位置的点
 */
@interface CarFriendMAPointAnnotation : MAPointAnnotation

@property (nonatomic, assign) BOOL isSelected;

// 详细地址
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *address;

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@end
