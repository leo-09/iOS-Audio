//
//  SearchNewsInfoLocalData.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseLocalData.h"
#import "YYCache.h"

/**
 搜索新闻的历史记录
 */
@interface SearchNewsInfoLocalData : CTXBaseLocalData

@property (nonatomic, retain) YYCache *yyCache;

+ (instancetype) sharedInstance;

/**
 查找所有的记录
 
 @param block 所有的记录
 */
- (void) queryAllRecordWithBlock:(void (^)(NSString *key, id<NSCoding> object))block;

/**
 添加一个搜索记录
 
 @param record 搜索关键字
 */
- (void) addRecord:(NSString *) record;

/**
 删除所有的记录
 */
- (void) removeAllRecord;

@end
