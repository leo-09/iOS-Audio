//
//  HomeNetData.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseNetDataRequest.h"

@interface HomeNetData : CTXBaseNetDataRequest

/**
 请求天气数据

 @param city 城市
 @param priorUseCache 是否优先使用缓存
 @param tag 标志
 */
- (void) getWeatherWithCity:(NSString *)city priorUseCache:(BOOL)priorUseCache tag:(NSString *)tag;

/**
 请求油价数据

 @param tag 标志
 */
- (void) queryOilPriceWithTag:(NSString *)tag;

/**
 获取栏目资讯列表接口

 @param tag 标志
 */
- (void) getModularNewsWithTag:(NSString *)tag;

/**
 机动车违章查询接口

 @param token token
 @param userId 用户ID,用于缓存的key，来区别每个人的缓存数据
 @param isCache 是否优先使用缓存数据
 @param tag 标志
 */
- (void) queryCarIllegalInfoWithToken:(NSString *)token userId:(NSString *)userId isPriorUseCache:(BOOL)isCache tag:(NSString *)tag;

/**
 获取APP在AppStore中的版本号
 
 @param tag 标志
 */
- (void) getAppStoreVersionWithTag:(NSString *)tag;

@end
