//
//  CarInspectNetData.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseNetDataRequest.h"
#import "SaveSubscribeModel.h"

/**
 六年免检、车检代办、车检预约
 */
@interface CarInspectNetData : CTXBaseNetDataRequest

/**
 车牌号车架号年检信息查询

 @param plateNumber 车牌
 @param frameNumber 车架号
 @param carType 车辆类型
 @param tag tag
 */
- (void) userApiNJWZCXWithPlateNumber:(NSString *)plateNumber frameNumber:(NSString *)frameNumber carType:(NSString *)carType tag:(NSString *)tag;

/**
 车牌号车架号免检信息查询

 @param plateNumber 车牌
 @param frameNumber 车架号
 @param carType 车辆类型
 @param date 交强险终止日期
 @param tag tag
 */
- (void) userApiMJWZCXWithPlateNumber:(NSString *)plateNumber frameNumber:(NSString *)frameNumber carType:(NSString *)carType date:(NSString *)date tag:(NSString *)tag;

/**
 查看车检站列表

 @param latitude 纬度
 @param longitude 经度
 @param areaId 地区id
 @param currentPage 请求的当前页；（从0开始）
 @param stationType 车间站类型；1：年检；2：六年免检；3：全部；
 @param showCount 当前查询数据长度
 @param sortKey 排序字段：1：按距离升序；2：按好评数降序
 @param tag tag
 */
- (void) stationListWithLatitude:(double)latitude longitude:(double)longitude areaId:(NSString *)areaId pageId:(int)currentPage
                     stationType:(int) stationType showCount:(int)showCount sortKey:(int)sortKey tag:(NSString *)tag;

/**
 模糊搜索车检站
 
 @param areaId 地区id
 @param stationType 车间站类型；1：年检；2：六年免检；3：全部；
 @param stationName 关键字
 */
-(void) searchStationWithAreaId:(NSString *)areaId  stationType:(int) stationType stationName:(NSString *)stationName  tag:(NSString *)tag;

/**
 保存预约记录接口

 @param token token
 @param subscribeMode model
 @param cityName 六年免检的上门取件城市名称
 @param tag tag
 */
- (void) saveSubscribeWithToken:(NSString *)token subscribeMode:(SaveSubscribeModel*)subscribeMode cityName:(NSString *)cityName tag:(NSString *)tag;

/**
 查询车检站详情页面
 
 @param latitude 纬度
 @param longitude 经度
 @param stationId 车检站ID
 @param tag tag
 */
- (void) stationDetailWithLatitude:(double)latitude longitude:(double)longitude stationId:(NSString *)stationId tag:(NSString *)tag;

/**
 支付宝支付

 @param businessCode 订单编号
 @param desc 描述
 @param tag tag
 */
- (void) aliPayWithBusinessCode:(NSString *)businessCode desc:(NSString *)desc tag:(NSString *)tag;

/**
  微信支付

 @param businessCode 订单编号
 @param desc 描述
 @param tag tag
 */
- (void) weChatPayWithBusinessCode:(NSString *)businessCode desc:(NSString *)desc tag:(NSString *)tag;

/**
 获取已支付信息详情

 @param businessID businessID
 @param tag tag
 */
- (void) orderDetailWithBusinessID:(NSString *)businessID tag:(NSString *)tag;

/**
 获取部分车检站评论信息

 @param stationID 车检站id
 @param assessStar 评价星数;(如果查询车检站差评列表,传assessSta=2即可,如果查询全部 的传值5)
 @param pageId   从0页开始
 @param showCount 当前查询数据长度；
 @param isContainImg 0:不包含；1：包含图片；3：全部
 @param tag tag
 */
-(void)queryStationCommentWithStationID:(NSString *)stationID assessStar:(NSString *)assessStar pageId:(NSString *)pageId showCount:(NSString *)showCount isContainImg:(NSString *)isContainImg tag:(NSString *)tag;

/**
 查询车检预约时间段
 
 @param orderDay 日期
 @param stationID 车检站id
 */
-(void)quertApptionmentTime:(NSString *)orderDay StationID:(NSString *)stationID tag:(NSString *)tag;

/**
 车检站相册

 @param stationID 车检站id
 @param tag tag
 */
-(void)quertStationAlbumStationID:(NSString *)stationID tag:(NSString *)tag;

/**
 优惠码接口

 @param couponCode 优惠码
 @param tag tag
 */
- (void) isCouponCodeWithCouponCode:(NSString *)couponCode tag:(NSString *)tag;

/**
 查询代办最近车检站
 
 @param latitude 经度
 @param longitude 纬度
 @param pageId 当前页
 @param from 来源
 @param showCount 每页显示数据个数
 */
-(void) queryNearbyStatationWithLatitude:(double)latitude longitude:(double)longitude pageId:(NSString *)pageId from:(NSString *)from showCount:(NSString *)showCount tag:(NSString *)tag;

/**
 车检代办 车检站预约时间（取车预约时间）
 
 @param stationID 车检站id
 @param tag tag
 */
-(void) queryCarInspectagencyStationAppintionTimeWithStationID:(NSString *)stationID tag:(NSString *)tag;

/**
 车检站评价图片上传
 
 @param data UIImage->data
 @param tag tag
 */
- (void) uploadUserHeaderImageWithData:(NSData *)data tag:(NSString *)tag;

/**
 车检站评价

 @param token token
 @param assessStar 评价星
 @param assessContent 评价内容
 @param imgUrl 图片地址
 @param businessid 车检站id
 @param tag tag
 */
-(void) submitStationCommentWithToken:(NSString *)token assessStar:(NSString *)assessStar assessContent:(NSString *)assessContent imgUrl:(NSString *)imgUrl businessid:(NSString *)businessid tag:(NSString *)tag;

/**
 查询评价记录总数

 @param stationId 车检站id
 @param tag tag
 */
-(void) queryStationEvaluateCountWithStationID:(NSString *)stationId tag:(NSString *)tag;

@end
