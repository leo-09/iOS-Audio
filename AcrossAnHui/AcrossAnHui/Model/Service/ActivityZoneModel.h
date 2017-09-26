//
//  ActivityZoneModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/24.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 活动专区的model
 */
@interface ActivityZoneModel : CTXBaseModel

@property (nonatomic, copy) NSString *imgPath;
@property (nonatomic, copy) NSString *linkUrl;
@property (nonatomic, copy) NSString *outsideUrl;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *status;// status: -1 -->活动已结束 ，1 -->活动进行中
@property (nonatomic, copy) NSString *title;

@end
