//
//  CarTrafficMAPointAnnotation.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/4.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CarFriendTrafficModel.h"

/**
 车友路况 地图上的点
 */
@interface CarTrafficMAPointAnnotation : MAPointAnnotation

@property (nonatomic, retain) CarFriendTrafficModel *model;
@property (nonatomic, copy) NSString *imageName;

@end
