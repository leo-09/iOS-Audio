//
//  ParkingNetData.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/11.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseNetDataRequest.h"

@interface ParkingNetData : CTXBaseNetDataRequest

/**
 停车服务首页数据

 @param token token
 @param userId 用户ID,用于缓存的key，来区别每个人的缓存数据
 @param longitude 经纬度
 @param latitude 经纬度
 @param tag tag
 */
- (void) selectPackinfoByCardWithToken:(NSString *)token userId:(NSString *)userId longitude:(double)longitude latitude:(double)latitude tag:(NSString *)tag;

/**
 通知收费管理员收费

 @param token token
 @param siteId  停车场ID
 @param tag tag
 */
- (void) pushToOperatorWithToken:(NSString *)token siteId:(NSString *)siteId tag:(NSString *)tag;

/**
 查询附近列表页

 @param sitename 停车场名称 模糊搜索
 @param longitude 经纬度
 @param latitude 经纬度
 @param currentPage 页码
 @param tag tag
 */
- (void) selectSiteListWithSitename:(NSString *)sitename longitude:(double)longitude latitude:(double)latitude page:(int)currentPage tag:(NSString *)tag;

/**
 查询所有路段信息

 @param sitename 停车场名称 模糊搜索
 @param longitude 经纬度
 @param latitude 经纬度
 @param tag tag
 */
- (void) selectAllSiteListWithSitename:(NSString *)sitename longitude:(double)longitude latitude:(double)latitude tag:(NSString *)tag;

/**
 查询所有区域及对应的路段分组

 @param cityName 城市名
 @param tag tag
 */
- (void) selectAreaGroupListWithCityName:(NSString *)cityName tag:(NSString *)tag;

/**
 查询附近列表页

 @param siteID 路段ID
 @param siteName 路段名
 @param areacode 区域代码
 @param sorttype 排序方式
 @param longitude 经纬度
 @param latitude 经纬度
 @param currentPage 页码
 @param tag tag
 */
- (void) selectSiteListWithSiteID:(NSString *)siteID siteName:(NSString *)siteName areacode:(NSString *)areacode
                         sorttype:(NSString *)sorttype longitude:(double)longitude latitude:(double)latitude
                             page:(int)currentPage tag:(NSString *)tag;

/**
 查询停车详情

 @param siteID 停车场ID
 @param longitude 经纬度
 @param latitude 经纬度
 @param tag tag
 */
- (void)getSiteByIdWithSiteID:(NSString *)siteID longitude:(double)longitude latitude:(double)latitude tag:(NSString *)tag;

/**
 补缴欠费

 @param token token
 @param orderNum (欠费)订单编号
 @param tag tag
 */
- (void) immediatePaymentFinishWithToken:(NSString *)token orderNum:(NSString *)orderNum tag:(NSString *)tag;

/**
 欠费金额查询

 @param token token
 @param tag tag
 */
- (void) selectOdueWithToken:(NSString *)token tag:(NSString *)tag;

@end
