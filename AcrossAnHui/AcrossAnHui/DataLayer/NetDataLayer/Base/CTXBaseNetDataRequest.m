//
//  CTXBaseNetDataRequest.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseNetDataRequest.h"
#import "YYCache.h"
#import "YYCacheManager.h"

@implementation CTXBaseNetDataRequest

#pragma mark - Get方法(默认方法)

- (void) httpGetRequest:(NSString *)url params:(NSMutableDictionary *)params requestModel:(BaseNetDataRequestModel *)model {
    [self httpRequestWithUrlStr:url params:params requestType:RequestTypeGet
                        isCache:NO isPriorUseCache:NO imageName:nil fileName:nil withData:nil withDataArray:nil
                   requestModel:model paramsForCacheKey:nil];
}

- (void) httpGetCacheRequest:(NSString *)url params:(NSMutableDictionary *)params paramsForCacheKey:(NSDictionary *)paramCacheKey requestModel:(BaseNetDataRequestModel *)model {
    [self httpRequestWithUrlStr:url params:params requestType:RequestTypeGet
                        isCache:YES isPriorUseCache:NO imageName:nil fileName:nil withData:nil withDataArray:nil
                   requestModel:model paramsForCacheKey:paramCacheKey];
}

#pragma mark - Post方法

- (void) httpPostRequest:(NSString *)url params:(NSMutableDictionary *)params requestModel:(BaseNetDataRequestModel *)model {
    [self httpRequestWithUrlStr:url params:params requestType:RequestTypePost
                        isCache:NO isPriorUseCache:NO imageName:nil fileName:nil withData:nil withDataArray:nil
                   requestModel:model paramsForCacheKey:nil];
}

- (void) httpPostCacheRequest:(NSString *)url params:(NSMutableDictionary *)params paramsForCacheKey:(NSDictionary *)paramCacheKey requestModel:(BaseNetDataRequestModel *)model {
    [self httpRequestWithUrlStr:url params:params requestType:RequestTypePost
                        isCache:YES isPriorUseCache:NO imageName:nil fileName:nil withData:nil withDataArray:nil
                   requestModel:model paramsForCacheKey:paramCacheKey];
}

- (void) httpPostPriorUseCacheRequest:(NSString *)url params:(NSMutableDictionary *)params paramsForCacheKey:(NSDictionary *)paramCacheKey requestModel:(BaseNetDataRequestModel *)model {
    [self httpPostPriorUseCacheRequest:url params:params isOnlyCache:NO paramsForCacheKey:paramCacheKey requestModel:model];
}

- (void) httpPostPriorUseCacheRequest:(NSString *)url params:(NSMutableDictionary *)params isOnlyCache:(BOOL)isOnlyCache paramsForCacheKey:(NSDictionary *)paramCacheKey requestModel:(BaseNetDataRequestModel *)model {
    // model为空，则使用默认值
    if (!model) {
        model = [[BaseNetDataRequestModel alloc] init];
    }
    // 优先使用缓存，不要提示
    model.dataFromCacheHint = nil;
    
    // 设置cache和cacheKey
    YYCache *cache = [[YYCache alloc] initWithName:HttpCache];
    NSString *cacheKey = [[BaseNetDataRequestTool sharedInstance] gainCacheKeyWithUrlStr:url paramsForCacheKey:paramCacheKey tokenKey:model.tokenKey];
    
    // 根据网址从Cache中取数据
    id cacheData = [cache objectForKey:cacheKey];// cacheData 缓存内容
    if (cacheData) {
        // 既然优先使用缓存，那就跟token无关了，则loginSuccessBlock设置空, 直接取缓存，所以isPriorUseCache=NO
        [self gainCacheDataWithCache:cache cacheKey:cacheKey isCache:YES isPriorUseCache:NO tint:model.offNetHint requestModel:model loginSuccessBlock:nil];
    } else {
        // 即使只使用缓存，但是没有缓存的时候，还是要发起网络请求的
        isOnlyCache = NO;
    }
    
    // 只使用缓存的情况，则不再发起网络请求
    if (!isOnlyCache) {
        // 取过缓存数据后，需要再访问接口更新最新数据 并更新页面
        [self httpRequestWithUrlStr:url params:params requestType:RequestTypePost
                            isCache:YES isPriorUseCache:YES imageName:nil fileName:nil withData:nil withDataArray:nil
                       requestModel:model paramsForCacheKey:paramCacheKey];
    }
}

#pragma mark - 上传文件方法

// 上传单张图片 name一般写file
-(void)uploadDataWithUrlStr:(NSString *)url params:(NSMutableDictionary *)params imageName:(NSString *)name fileName:(NSString *)fileName
                   withData:(NSData *)data requestModel:(BaseNetDataRequestModel *)model {
    [self httpRequestWithUrlStr:url params:params requestType:RequestTypeUpLoad
                        isCache:NO isPriorUseCache:NO imageName:name fileName:fileName withData:data withDataArray:nil
                   requestModel:model paramsForCacheKey:nil];
}

// 上传多张图片
-(void)uploadDataWithUrlStr:(NSString *)url params:(NSMutableDictionary *)params imageName:(NSString *)name
              withDataArray:(NSArray *)dataArray requestModel:(BaseNetDataRequestModel *)model {
    [self httpRequestWithUrlStr:url params:params requestType:RequestTypeMultiUpload
                        isCache:NO isPriorUseCache:NO imageName:name fileName:nil withData:nil withDataArray:dataArray
                   requestModel:model paramsForCacheKey:nil];
}

#pragma mark - 网络请求的方法

/**
 网络请求的统一入口：先判断网络状态
 @param url                 请求URL
 @param params              参数dict
 @param requestType         请求类型
 @param isCache             是否缓存标志
 @param isPriorUseCache     是否优先使用了缓存
 @param name                图片上传的名字(upload)
 @param fileName            fileName
 @param data                图片的二进制数据(upload)
 @param dataArray           多图片上传时的imageDataArray
 @param model               属性设置
 @param paramCacheKey       为缓存key定制的params
 */
-(void)httpRequestWithUrlStr:(NSString *) url params:(NSMutableDictionary *) params requestType:(RequestType) requestType
                     isCache:(BOOL)isCache isPriorUseCache:(BOOL) isPriorUseCache
                   imageName:(NSString *) name fileName:(NSString *)fileName
                    withData:(NSData *) data withDataArray:(NSArray *) dataArray
                requestModel:(BaseNetDataRequestModel *)model paramsForCacheKey:(NSDictionary *)paramCacheKey {
    
    // model为空，则使用默认值
    if (!model) {
        model = [[BaseNetDataRequestModel alloc] init];
    }
    
    // 设置cache和cacheKey
    YYCache *cache = [[YYCache alloc] initWithName:HttpCache];
    NSString *cacheKey = [[BaseNetDataRequestTool sharedInstance] gainCacheKeyWithUrlStr:url paramsForCacheKey:paramCacheKey tokenKey:model.tokenKey];
    
    // 判断网络状态
    if ([[BaseNetDataRequestTool sharedInstance] isNetworkEnable]) {
        [self requestWithURL:url params:params requestType:requestType isPriorUseCache:isPriorUseCache isCache:isCache cache:cache
                    cacheKey:cacheKey imageName:name fileName:fileName withData:data withDataArray:dataArray requestModel:model
           loginSuccessBlock:^(id newToken) {
               
               // 设置最新的token
               NSMutableDictionary *newParams = [[BaseNetDataRequestTool sharedInstance] replaceParams:params withNewToken:newToken tokenKey:model.tokenKey paramsKey:model.paramsKey];
               // token失效后调登录，登录成功后，再调用本次操作的接口
               [self httpRequestWithUrlStr:url params:newParams requestType:requestType
                                   isCache:isCache isPriorUseCache:isPriorUseCache
                                 imageName:name fileName:fileName withData:data
                             withDataArray:dataArray requestModel:model paramsForCacheKey:paramCacheKey];
           }];
    } else {
        // 没有网络连接, 记录当前网络请求操作
        if (model.isRecordOperation) {
            [self showOffTheNetworkWithBlock:^(id newToken) {
                // 设置最新的token
                NSMutableDictionary *newParams = [[BaseNetDataRequestTool sharedInstance] replaceParams:params withNewToken:newToken tokenKey:model.tokenKey paramsKey:model.paramsKey];
                // token失效后调登录，登录成功后，再调用本次操作的接口
                [self httpRequestWithUrlStr:url params:newParams requestType:requestType
                                    isCache:isCache isPriorUseCache:isPriorUseCache
                                  imageName:name fileName:fileName withData:data
                              withDataArray:dataArray requestModel:model paramsForCacheKey:paramCacheKey];
            }];
        }
        
        // cacheData 缓存内容
        id cacheData = [cache objectForKey:cacheKey];
        
        // 没有网络连接 && 没有优先使用缓存 && 没有缓存 ==> 再请求缓存数据
        if (!isPriorUseCache || !cacheData) {
            [self gainCacheDataWithCache:cache cacheKey:cacheKey isCache:isCache isPriorUseCache:isPriorUseCache tint:model.offNetHint requestModel:model
                       loginSuccessBlock:^(id newToken) {
                           
                           // 设置最新的token
                           NSMutableDictionary *newParams = [[BaseNetDataRequestTool sharedInstance] replaceParams:params withNewToken:newToken tokenKey:model.tokenKey paramsKey:model.paramsKey];
                           // token失效后调登录，登录成功后，再调用本次操作的接口
                           [self httpRequestWithUrlStr:url params:newParams requestType:requestType
                                               isCache:isCache isPriorUseCache:isPriorUseCache
                                             imageName:name fileName:fileName withData:data withDataArray:dataArray
                                          requestModel:model paramsForCacheKey:paramCacheKey];
                       }];
        }
    }
    
//    // 监听网络状态
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        // 是否提示 WAN网络／未知网络
//        if (model.isHintNetStatus) {
//            if(status == AFNetworkReachabilityStatusReachableViaWWAN) {// WAN网络
//                [self showToastNetStatusWithTint:model.wanNetTint];
//            } else if(status == AFNetworkReachabilityStatusUnknown) {// 未知网络
//                [self showToastNetStatusWithTint:model.unknowNetTint];
//            }
//        }
//    }];
}

/**
 网络请求统一处理
 @param url                 请求URL
 @param params              参数dict
 @param requestType         请求类型
 @param isPriorUseCache     是否优先使用了缓存
 @param isCache             是否缓存标志
 @param cacheKey            缓存的对应key值
 @param name                图片上传的名字(upload)
 @param fileName            fileName
 @param data                图片的二进制数据(upload)
 @param dataArray           多图片上传时的imageDataArray
 @param model               属性设置
 @param loginSuccessBlock   token失效后调登录，登录成功后的操作
 */
-(void) requestWithURL:(NSString *) url params:(NSMutableDictionary *) params requestType:(RequestType) requestType
       isPriorUseCache:(BOOL) isPriorUseCache isCache:(BOOL)isCache cache:(YYCache *)cache cacheKey:(NSString *) cacheKey
              imageName:(NSString *)name fileName:(NSString *)fileName
              withData:(NSData *) data withDataArray:(NSArray *) dataArray
          requestModel:(BaseNetDataRequestModel *)model loginSuccessBlock:(GlobalLoginSuccessBlock)loginSuccessBlock {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    // 超时时间
    session.requestSerializer.timeoutInterval = 8;
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    if (requestType == RequestTypeGet) {// Get
        [session GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            // 请求数据，没有进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self dealWithResponseObject:responseObject isPriorUseCache:isPriorUseCache cache:cache isCache:isCache cacheKey:cacheKey requestModel:model loginSuccessBlock:loginSuccessBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self gainCacheDataWithCache:cache cacheKey:cacheKey isCache:isCache isPriorUseCache:isPriorUseCache tint:model.queryFailureHint requestModel:model loginSuccessBlock:loginSuccessBlock];
        }];
    } else if (requestType == RequestTypePost) {// Post
        [session POST:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            // 请求数据，没有进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self dealWithResponseObject:responseObject isPriorUseCache:isPriorUseCache cache:cache isCache:isCache cacheKey:cacheKey requestModel:model loginSuccessBlock:loginSuccessBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self gainCacheDataWithCache:cache cacheKey:cacheKey isCache:isCache isPriorUseCache:isPriorUseCache tint:model.queryFailureHint requestModel:model loginSuccessBlock:loginSuccessBlock];
        }];
    } else if (requestType == RequestTypeUpLoad) {// UpLoad
        [session POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            if (fileName) {
                [formData appendPartWithFileData:data name:name fileName:fileName mimeType:model.imageMimeType];
            } else {
                NSString *newFileName = [[BaseNetDataRequestTool sharedInstance] gainImageNameWithImageMimeType:model.imageMimeType];
                [formData appendPartWithFileData:data name:name fileName:newFileName mimeType:model.imageMimeType];
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            float pro = (float)uploadProgress.completedUnitCount / (float)uploadProgress.totalUnitCount;
            [self showProgress:pro tag:model.tag];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self dealWithResponseObject:responseObject isPriorUseCache:isPriorUseCache cache:cache isCache:isCache cacheKey:cacheKey requestModel:model loginSuccessBlock:loginSuccessBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self gainCacheDataWithCache:cache cacheKey:cacheKey isCache:isCache isPriorUseCache:isPriorUseCache tint:model.queryFailureHint requestModel:model loginSuccessBlock:loginSuccessBlock];
        }];
    } else if (requestType == RequestTypeMultiUpload) {
        [session POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (NSInteger i = 0; i < dataArray.count; i++) {
                NSData *imageData = [dataArray objectAtIndex:i];
                
                NSString *fileName;
                if (model.fileName) {
                    fileName = model.fileName;
                } else {
                    fileName = [[BaseNetDataRequestTool sharedInstance] gainImageNameWithImageMimeType:model.imageMimeType];
                }
                
                [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:model.imageMimeType];
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            float pro = (float)uploadProgress.completedUnitCount / (float)uploadProgress.totalUnitCount;
            [self showProgress:pro tag:model.tag];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self dealWithResponseObject:responseObject isPriorUseCache:isPriorUseCache cache:cache isCache:isCache cacheKey:cacheKey requestModel:model loginSuccessBlock:loginSuccessBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self gainCacheDataWithCache:cache cacheKey:cacheKey isCache:isCache isPriorUseCache:isPriorUseCache tint:model.queryFailureHint requestModel:model loginSuccessBlock:loginSuccessBlock];
        }];
    } else {
        [self showErrorWithTint:@"请选择正确的请求方式" tag:model.tag];
    }
}

/**
 统一处理网络请求成功返回的数据 ------ 网络请求有2个出口，这是第1个出口
 @param responseData        请求结果数据
 @param isPriorUseCache     是否优先使用了缓存
 @param cache               cache
 @param isCache             是否缓存
 @param cacheKey            缓存key (cacheData暂不理会)
 @param model               属性设置
 @param loginSuccessBlock   token失效后调登录，登录成功后的操作
 */
-(void)dealWithResponseObject:(NSData *)responseData isPriorUseCache:(BOOL) isPriorUseCache
                        cache:(YYCache *)cache isCache:(BOOL)isCache cacheKey:(NSString *)cacheKey
                 requestModel:(BaseNetDataRequestModel *)model loginSuccessBlock:(GlobalLoginSuccessBlock)loginSuccessBlock {

    // 关闭网络指示器
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
    
    NSString * dataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    dataString = [[BaseNetDataRequestTool sharedInstance] deleteSpecialCodeWithStr:dataString];
    NSData *requestData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    
    // 处理并显示数据
    [self returnDataWithRequestData:requestData requestTint:nil
                              cache:cache isCache:isCache cacheKey:cacheKey   // 网络请求的数据，需要cache取保存requestData
                    isPriorUseCache:isPriorUseCache requestModel:model loginSuccessBlock:loginSuccessBlock];
}

/**
 网络请求失败或者网络断开，统一处理缓存数据 ------ 网络请求有2个出口，这是第2个出口

 @param cache               cache
 @param cacheKey            key
 @param isCache             是否使用缓存
 @param isPriorUseCache     是否优先使用了缓存
 @param tint                提示
 @param model               属性设置
 @param loginSuccessBlock   token失效后调登录，登录成功后的操作
 */
- (void) gainCacheDataWithCache:(YYCache *)cache cacheKey:(NSString *)cacheKey isCache:(BOOL)isCache
                isPriorUseCache:(BOOL) isPriorUseCache tint:(NSString *)tint requestModel:(BaseNetDataRequestModel *)model
              loginSuccessBlock:(GlobalLoginSuccessBlock)loginSuccessBlock {
    if (isCache) {
        // 根据网址从Cache中取数据
        id cacheData = [cache objectForKey:cacheKey];// cacheData 缓存内容
        
        if(cacheData) {
            [self returnDataWithRequestData:cacheData requestTint:tint cache:nil isCache:NO cacheKey:nil    // 读取缓存数据，则不需要cache取保存cacheData，都为nil
                            isPriorUseCache:isPriorUseCache requestModel:model loginSuccessBlock:loginSuccessBlock];
        } else {
            [self showErrorWithTint:tint tag:model.tag];
        }
    } else {
        [self showErrorWithTint:tint tag:model.tag];
    }
}

/**
 根据返回的数据进行统一的格式处理

 @param requestData         网络或者是缓存的数据
 @param requestTint         有数据，则表示取自cache；为空则是网络获取的数据
 @param cache               cache
 @param isCache             isCache
 @param isPriorUseCache     isPriorUseCache
 @param cacheKey            缓存key (cacheData暂不理会)
 @param model               属性设置
 @param loginSuccessBlock   token失效后调登录，登录成功后的操作
 */
- (void)returnDataWithRequestData:(NSData *)requestData requestTint:(NSString *)requestTint
                            cache:(YYCache *)cache isCache:(BOOL)isCache cacheKey:(NSString *)cacheKey
                  isPriorUseCache:(BOOL) isPriorUseCache requestModel:(BaseNetDataRequestModel *)model
                loginSuccessBlock:(GlobalLoginSuccessBlock)loginSuccessBlock {
    
    // 解析json格式的结果
    id result = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
    
    // 判断是否为字典
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *response = (NSDictionary *)result;
        
        // 包括resultKey
        if ([[response allKeys] containsObject:model.resultKey]) {
            NSString *resultValue = [NSString stringWithFormat:@"%@", [response objectForKey:model.resultKey]];// @"result"
            if (resultValue && [resultValue isEqualToString:model.successIden]) {// resultValue存在, 并表示成功时
                
                // 只有请求的数据正确，那么需要缓存时, 才可以缓存网络请求的数据
                if (isCache && cache) {
                    [cache setObject:requestData forKey:cacheKey withBlock:^{
                        CTXLog(@"setObject for %@ sucess ", cacheKey);
                    }];
                }
                
                // 请求的数据做处理，把data层剥掉
                id data = [response objectForKey:model.dataKey];
                
                // 针对加密接口的操作
                id encrypt = [response objectForKey:@"encrypt"];
                if (encrypt && [encrypt isEqualToString:@"y"]) {
                    NSArray *dataArray = [DES3Util stringToNSArray:[DES3Util decrypt:data]];
                    [self showSuccess:dataArray tint:requestTint requestModel:model];
                } else {
                    if (model.infoKey) {    // 包含info的健值对
                        id info = [response objectForKey:model.infoKey];
                        info = info ? info : @{};
                        
                        [self showSuccess:@{ @"data" : data, @"info" : info } tint:requestTint requestModel:model];
                    } else {
                        [self showSuccess:data tint:requestTint requestModel:model];
                    }
                }
            } else if (model.nilDataIden && [resultValue isEqualToString:model.nilDataIden]) {
                // 只有请求的数据正确，那么需要缓存时, 才可以缓存网络请求的数据
                if (isCache && cache) {
                    [cache setObject:requestData forKey:cacheKey withBlock:^{
                        CTXLog(@"setObject for %@ sucess ", cacheKey);
                    }];
                }
                
                // 为了匹配部分接口查询结果为空，状态码依旧不是1而设置
                id data = [response objectForKey:model.dataKey];
                
                if (model.infoKey) {    // 包含info的健值对
                    id info = [response objectForKey:model.infoKey];
                    info = info ? info : @{};
                    data = data ? data : @{};
                    
                    [self showSuccess:@{ @"data" : data, @"info" : info } tint:requestTint requestModel:model];
                } else {
                    [self showSuccess:data tint:requestTint requestModel:model];
                }
            } else if (resultValue && ([resultValue isEqualToString:model.inValidTokenCode] || [resultValue isEqualToString:model.nullTokenCode])) {// token失效
                // 即使取缓存数据，如果token失效，依旧强调token失效 --- 登录接口千万不可返回这个，否则就是死循环
                [self showInValidOrNullTokenWithBlock:loginSuccessBlock];
            } else {
                // 如果是优先使用了缓存，且网络请求错误，则不应该做任何显示
                if (!isPriorUseCache) {
                    id message = [response objectForKey:model.msgKey];// @"msg"
                    
                    if (cache && isCache) {
                        // 来自网络请求数据 错误了，就去读取缓存数据
                        [self gainCacheDataWithCache:cache cacheKey:cacheKey isCache:isCache isPriorUseCache:isPriorUseCache tint:message requestModel:model loginSuccessBlock:loginSuccessBlock];
                    } else {
                        // 来自缓存数据 错误了,只能提示用户 数据错误
                        [self showErrorWithTint:(requestTint ? requestTint : message) tag:model.tag];
                    }
                }
            }
        } else {
            // 请求结果不一致时，直接将结果返回给ViewController处理
            [self showSuccess:response tint:requestTint requestModel:model];
        }
    } else {
        // 如果是优先使用了缓存，且网络请求错误，则不应该做任何显示
        if (!isPriorUseCache) {
            if (cache && isCache) {
                // 来自网络请求数据 错误了，就去读取缓存数据
                [self gainCacheDataWithCache:cache cacheKey:cacheKey isCache:isCache isPriorUseCache:isPriorUseCache tint:model.queryFailureHint requestModel:model  loginSuccessBlock:loginSuccessBlock];
            } else {
                // 来自缓存数据 错误了,只能提示用户 数据错误
                [self showErrorWithTint:model.queryFailureHint tag:model.tag];
            }
        }
    }
}

#pragma mark - 返回数据的调度显示

- (void) showSuccess:(id)response tint:(NSString *)tint requestModel:(BaseNetDataRequestModel *)model {
    if(!self.delegate) {
        return;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
    
    if ([self.delegate respondsToSelector:@selector(querySuccessWithTag:result:tint:)]) {
        if (tint) {
            [self.delegate querySuccessWithTag:model.tag result:response tint:model.dataFromCacheHint];
        } else {
            [self.delegate querySuccessWithTag:model.tag result:response tint:nil];
        }
        
        return;
    }
    
#pragma clang diagnostic pop
}

- (void) showErrorWithTint:(NSString *)tint tag:(NSString *)tag {
    if(!self.delegate) {
        return;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
    
    if ([self.delegate respondsToSelector:@selector(queryFailureWithTag:tint:)]) {
        [self.delegate queryFailureWithTag:tag tint:tint];
        return;
    }
    
#pragma clang diagnostic pop
}

- (void) showInValidOrNullTokenWithBlock:(GlobalLoginSuccessBlock)block {
    if(!self.delegate) {
        return;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
    
    if ([self.delegate respondsToSelector:@selector(inValidOrNullTokenWithBlock:)]) {
        [self.delegate inValidOrNullTokenWithBlock:block];
        return;
    }
    
#pragma clang diagnostic pop
}

- (void) showOffTheNetworkWithBlock:(GlobalLoginSuccessBlock)block {
    if(!self.delegate) {
        return;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
    
    if ([self.delegate respondsToSelector:@selector(offTheNetworkWithBlock:)]) {
        [self.delegate offTheNetworkWithBlock:block];
        return;
    }
    
#pragma clang diagnostic pop
}

- (void) showProgress:(float) pro tag:(NSString *)tag {
    if(!self.delegate) {
        return;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
    
    if ([self.delegate respondsToSelector:@selector(uploadFileWithTag:progress:)]) {
        [self.delegate uploadFileWithTag:tag progress:pro];
        return;
    }

#pragma clang diagnostic pop
}

- (void) showToastNetStatusWithTint:(NSString *)tint {
    if(!self.delegate) {
        return;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
    
    if ([self.delegate respondsToSelector:@selector(toastNetStatusWithTint:)]) {
        [self.delegate toastNetStatusWithTint:tint];
        return;
    }
    
#pragma clang diagnostic pop
}

@end
