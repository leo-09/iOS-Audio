//
//  CarInspectLogistics.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/21.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"
#import <UIKit/UIKit.h>

/**
 物流跟踪
 */
@interface CarInspectLogistics : CTXBaseModel

@property (nonatomic, copy) NSString *address;      // 位置
@property (nonatomic, copy) NSString *time;         // 如：2017-04-19 12:00:00
@property (nonatomic, copy) NSString *remark;       // 位置描述

// 该Model对应的Cell高度
@property (nonatomic, assign) CGFloat cellHeight;

@end
