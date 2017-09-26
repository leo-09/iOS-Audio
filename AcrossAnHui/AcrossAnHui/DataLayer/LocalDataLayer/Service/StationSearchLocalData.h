//
//  StationSearchLocalData.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseLocalData.h"
#import "CarInspectStationModel.h"
#import "YYCache.h"

/**
 搜索车检站历史记录
 */
@interface StationSearchLocalData : CTXBaseLocalData

@property (nonatomic, retain) YYCache *yyCache;

+ (instancetype) sharedInstance;

/**
 查找所有的记录

 @return 所有的记录
 */
- (NSMutableArray *) queryAllRecord;

/**
 添加一个搜索记录
 
 @param record 搜索关键字
 */
- (void) addRecord:(CarInspectStationModel *) record;

/**
 删除所有的记录
 */
- (void) removeAllRecord;

@end
