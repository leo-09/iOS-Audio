//
//  ServiceNetDataLayer.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseNetDataRequest.h"

@interface ServiceNetData : CTXBaseNetDataRequest

/**
 获取广告(轮播图)的信息列表

 @param advID 广告位编号:
        21：畅行安徽APP 首页轮播图编号
        22：畅行安徽APP 服务模块轮播图编号
        25：畅行安徽APP 启动APP轮播图编号
 @param tag 标志
 */
- (void) getAdvListById:(NSString *)advID tag:(NSString *)tag;

/**
 启动时候的广告页的数据

 @param tag tag
 */
- (void) getAdvertisementWithTag:(NSString *)tag;

/**
 活动列表接口

 @param page 起始页(从0开始)
 @param tag  标志
 */
- (void) getActivityZoneListWithStartPage:(int)page tag:(NSString *)tag;

/**
 获取栏目资讯列表接口（分页查询）

 @param name 资讯名称（模糊搜索）
 @param page 页码
 @param tag  标志
 */
- (void) getNewsListWithName:(NSString *)name currentPage:(int)page tag:(NSString *)tag;

/**
 获取热门搜索关键词接口
 */
- (void) getHotkeywordsWithTag:(NSString *)tag;

/**
 卖车记录

 @param token   token
 @param userId 用户ID,用于缓存的key，来区别每个人的缓存数据
 @param page    页
 @param tag     标志
 */
- (void) getAPPSellCarListWithToken:(NSString *)token userId:(NSString *)userId page:(int) page tag:(NSString *)tag;

/**
 提交卖车信息

 @param token       token
 @param carType     车辆类型
 @param carTime     上牌时间
 @param mileage     行驶路程
 @param city        所在城市
 @param name        联系人
 @param phone       手机号
 @param tag         标志
 */
- (void) saveAppSellInfoWithToken:(NSString *)token carType:(NSString *)carType carTime:(NSString *)carTime
                          mileage:(NSString *)mileage city:(NSString *)city name:(NSString *)name
                            phone:(NSString *)phone tag:(NSString *)tag;

@end
