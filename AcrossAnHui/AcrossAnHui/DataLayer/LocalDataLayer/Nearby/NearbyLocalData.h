//
//  NearbyLocalData.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/24.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseLocalData.h"
#import "YYCache.h"

/**
 地图搜索的 停车场、加油站的存储数据
 */
@interface NearbyLocalData : CTXBaseLocalData

@property (nonatomic, retain) YYCache *yyCache;

+ (instancetype) sharedInstance;

/**
 根据key 查找其搜索记录

 @param key 健值
 @return 保存的搜索记录
 */
- (NSMutableArray *) queryAnnotationsWithKey:(NSString *)key;

/**
 根据key 覆盖其搜索记录

 @param annos 搜索记录
 @param key key
 */
- (void) coverAnnotations:(NSArray *) annos key:(NSString *)key ;

/**
 根据key 删除其搜索记录

 @param key key
 */
- (void) removeAnnotationsWithKey:(NSString *)key;

@end
