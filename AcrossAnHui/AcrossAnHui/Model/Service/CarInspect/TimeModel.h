//
//  TimeModel.h
//  AcrossAnHui
//
//  Created by ztd on 17/6/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

@interface MinuteModel : CTXBaseModel

@property (nonatomic,copy)NSString * hour;
@property (nonatomic,copy)NSArray<NSString *> * min;

@end

@interface TimeModel : CTXBaseModel

@property (nonatomic,copy)NSString * date;
@property (nonatomic,copy)NSArray<MinuteModel *> * time;

@end
