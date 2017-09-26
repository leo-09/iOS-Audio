//
//  CTXBaseNetDataRequest.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetURLManager.h"
#import "DES3Util.h"
#import "BaseNetDataRequestModel.h"
#import "AFNetworking.h"
#import "BaseNetDataRequestTool.h"


/**
 *  数据逻辑层的 delegate
 */
@protocol CTXNetDataDelegate <NSObject>

@required

/**
 网络请求成功
 @param tag 标示
 @param result 结果
 @param tint 为空则不需要提示用户；有值则需要提示
 */
- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint;

@optional

// 网络请求失败
- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint;

// 上次文件进度
- (void) uploadFileWithTag:(NSString *)tag progress:(float)progress;

// token失效或者token为空的回调,并带入当前的操作
- (void) inValidOrNullTokenWithBlock:(GlobalLoginSuccessBlock) loginSuccessBlock;

// 没有网络的回调,并记录当前的操作
- (void) offTheNetworkWithBlock:(GlobalLoginSuccessBlock) networkEnableBlock;

//提示当前使用的是流量
- (void) toastNetStatusWithTint:(NSString *)tint;

@end


/**
 请求方式
 */
typedef NS_ENUM(NSInteger, RequestType) {
    RequestTypeGet,
    RequestTypePost,
    RequestTypeUpLoad,//单个上传
    RequestTypeMultiUpload,//多个上传
    RequestTypeDownload
};


/**
 可使用缓存的AFNetworking请求
 */
@interface CTXBaseNetDataRequest : NSObject

@property (nonatomic, weak)  id<CTXNetDataDelegate> delegate;

#pragma mark - Get方法

//不带缓存
- (void) httpGetRequest:(NSString *)url
                 params:(NSMutableDictionary *)params
           requestModel:(BaseNetDataRequestModel *)model;
- (void) httpGetCacheRequest:(NSString *)url
                      params:(NSMutableDictionary *)params
           paramsForCacheKey:(NSDictionary *)paramCacheKey
                requestModel:(BaseNetDataRequestModel *)model;

#pragma mark - Post方法(默认方法)

//不带缓存
- (void) httpPostRequest:(NSString *)url
                  params:(NSMutableDictionary *)params
            requestModel:(BaseNetDataRequestModel *)model;

/**
 带缓存的post 请求
 
 @param url url
 @param params 参数
 @param paramCacheKey ！！！缓存需要考虑这个请求发生的时间地点 这个因素，需要剔除token或city等，作为缓存的key！！！
 @param model 属性设置,有默认值
 */
- (void) httpPostCacheRequest:(NSString *)url
                       params:(NSMutableDictionary *)params
            paramsForCacheKey:(NSDictionary *)paramCacheKey
                 requestModel:(BaseNetDataRequestModel *)model;

/**
 优先使用缓存 带缓存的post 请求
 缓存机制：1、优先使用缓存： 有缓存，直接取缓存并显示，再发起网路请求，获取正确的数据后才更新缓存和UI，获取错误的数据则不做处理;
                        无缓存，则往走“2-不优先使用缓存”的流程。
         2、不优先使用缓存：先判定网络断开则取缓存数据，否则请求数据，返回结果正确则更新缓存和UI，否则去取缓存数据，有数据则显示UI，没有则提示。
 
 @param url url
 @param params 参数
 @param isOnlyCache 是否仅仅使用缓存，不再更新数据
 @param paramCacheKey ！！！缓存需要考虑这个请求发生的时间地点 这个因素，需要剔除token或city等，作为缓存的key！！！
 @param model 属性设置,有默认值
 */
- (void) httpPostPriorUseCacheRequest:(NSString *)url
                               params:(NSMutableDictionary *)params
                          isOnlyCache:(BOOL)isOnlyCache
                    paramsForCacheKey:(NSDictionary *)paramCacheKey
                         requestModel:(BaseNetDataRequestModel *)model;
- (void) httpPostPriorUseCacheRequest:(NSString *)url
                               params:(NSMutableDictionary *)params
                    paramsForCacheKey:(NSDictionary *)paramCacheKey
                         requestModel:(BaseNetDataRequestModel *)model;

#pragma mark - 上传文件方法

//上传单张图片
- (void) uploadDataWithUrlStr:(NSString *)url
                       params:(NSMutableDictionary *)params
                    imageName:(NSString *)name
                     fileName:(NSString *)fileName
                     withData:(NSData *)data
                 requestModel:(BaseNetDataRequestModel *)model;
//上传多张图片
- (void) uploadDataWithUrlStr:(NSString *)url
                       params:(NSMutableDictionary *)params
                    imageName:(NSString *)name
                withDataArray:(NSArray *)dataArray
                 requestModel:(BaseNetDataRequestModel *)model;

@end
