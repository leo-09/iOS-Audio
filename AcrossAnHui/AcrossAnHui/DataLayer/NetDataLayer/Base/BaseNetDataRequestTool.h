//
//  BaseNetDataRequestTool.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/31.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 可使用缓存的AFNetworking请求 的 工具类
 */
@interface BaseNetDataRequestTool : NSObject

+ (instancetype) sharedInstance;

/**
 替换新的token

 @param params      原参数
 @param newToken    新token
 @param tokenKey    tokenKey
 @param paramsKey   paramsKey
 @return            新参数
 */
- (NSMutableDictionary *)replaceParams:(NSMutableDictionary *)params
                          withNewToken:(NSString *)newToken
                              tokenKey:(NSString *)tokenKey
                             paramsKey:(NSString *) paramsKey;

/**
 缓存的key值不超过128位

 @param cacheKey cacheKey
 @return new cacheKey
 */
- (NSString *) dealCacheKey:(NSString *)cacheKey;

/**
 生成图片文件名称

 @param imageMimeType imageMimeType
 @return string
 */
- (NSString *) gainImageNameWithImageMimeType:(NSString *)imageMimeType;

/**
 生成CacheKey

 @param url 请求url
 @param paramCacheKey 请求参数
 @param tokenKey token
 @return CacheKey
 */
- (NSString *) gainCacheKeyWithUrlStr:(NSString *) url
                    paramsForCacheKey:(NSDictionary *)paramCacheKey
                             tokenKey:(NSString *)tokenKey;

/**
 拼接请求的网络地址
 @param urlString   基础网址
 @param paramCacheKey  拼接参数
 @param tokenKey    token的Key
 @return 拼接完成的网址
 */
- (NSString *) urlDictToStringWithUrlStr:(NSString *)urlString
                       paramsForCacheKey:(NSDictionary *)paramCacheKey
                                tokenKey:(NSString *)tokenKey;

/**
 处理json格式的字符串中的换行符、回车符
 @param str json格式的字符串
 @return 替代了换行符、回车符等的字符串
 */
- (NSString *) deleteSpecialCodeWithStr:(NSString *)str;

/**
 网络判断

 @return YES 网络连接正常
 */
- (BOOL) isNetworkEnable;

@end
