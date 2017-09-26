//
//  CarInspectAgencyOrderTrackModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 订单轨迹
 */
@interface CarInspectAgencyOrderTrackModel : CTXBaseModel

@property (nonatomic, copy) NSString *opcontent;
@property (nonatomic, copy) NSString *opdate;

- (NSString *) time;

@end
