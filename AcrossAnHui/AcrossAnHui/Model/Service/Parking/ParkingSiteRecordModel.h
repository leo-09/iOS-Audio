//
//  ParkingSiteRecordModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"
#import "SiteModel.h"

/**
 停车位搜索记录的列表
 */
@interface ParkingSiteRecordModel : CTXBaseModel

@property (nonatomic, retain) NSMutableArray *siteModels;

@end
