//
//  BaseNetDataRequestModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 可使用缓存的AFNetworking请求 的 请求模型
 */
@interface BaseNetDataRequestModel : NSObject

#pragma mark - 以下属性可以根据实际情况修改

// 参数的key值
@property (nonatomic, copy) NSString *paramsKey;    // json格式的参数的key
@property (nonatomic, copy) NSString *tokenKey;     // 携带token参数的key

@property (nonatomic, copy) NSString *tag;          // 请求的标志

// 返回结果JSON，结果标识符 @"result"
@property (nonatomic, copy) NSString *resultKey;
// 返回结果JSON，结果描述 @"msg"
@property (nonatomic, copy) NSString *msgKey;
// 返回结果JSON，结构数据 @"data"
@property (nonatomic, copy) NSString *dataKey;
// 返回结果JSON，结构数据 @"info"
@property (nonatomic, copy) NSString *infoKey;
// 返回结果JSON，结果标识符 默认1表示请求成功
@property (nonatomic, copy) NSString *successIden;
// 查询结果为空的状态码（为了匹配部分接口查询结果为空，状态码依旧不是1而设置）
@property (nonatomic, copy) NSString *nilDataIden;

@property (nonatomic, copy) NSString *encryptKey;       // 请求结果的加密字段
@property (nonatomic, copy) NSString *encryptValueKey;  // 请求结果的加密的值

// TOKEN失效的代码
@property (nonatomic, copy) NSString *inValidTokenCode;
@property (nonatomic, copy) NSString *nullTokenCode;

// 数据取自缓存的提示
@property (nonatomic, copy) NSString *dataFromCacheHint;
// 断网提示
@property (nonatomic, copy) NSString *offNetHint;
// 网络请求失败提示
@property (nonatomic, copy) NSString *queryFailureHint;

// 上次文件失败提示
@property (nonatomic, copy) NSString *uploadFileErrorHint;
// 上传图片的mimeType
@property (nonatomic, copy) NSString *imageMimeType;
// fileName
@property (nonatomic, copy) NSString *fileName;

// 提示当前使用的是流量/未知网络 的文案
@property (nonatomic, assign) NSString *wanNetTint;
@property (nonatomic, assign) NSString *unknowNetTint;

// 是否提示当前网络的状态：wifi、流量、未知网络等
@property (nonatomic, assign) BOOL isHintNetStatus;// 默认NO

// 是否记录网络断开时的请求
@property (nonatomic, assign) BOOL isRecordOperation;// 默认NO

@end
