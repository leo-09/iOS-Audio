//
//  ParkingSiteSearchLocalData.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseLocalData.h"
#import "YYCache.h"
#import "SiteModel.h"

/**
 搜索停车位 的 历史记录
 */
@interface ParkingSiteSearchLocalData : CTXBaseLocalData

@property (nonatomic, retain) YYCache *yyCache;

+ (instancetype) sharedInstance;

/**
 查找所有的记录

 @return 记录集合
 */
- (NSMutableArray *) queryAllRecord;

/**
 添加一个搜索记录
 
 @param record 搜索关键字
 */
- (void) addRecord:(SiteModel *) record;

/**
 删除所有的记录
 */
- (void) removeAllRecord;


@end
