//
//  BaseNetDataRequestModel.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "BaseNetDataRequestModel.h"

@implementation BaseNetDataRequestModel

- (instancetype) init {
    if (self = [super init]) {
        // 默认值
        
        self.tokenKey = @"token";
        self.paramsKey = @"params";
        
        self.resultKey = @"result";
        self.dataKey = @"data";
        self.infoKey = nil;                 // info的key，与dataKey平级。默认没有该key
        self.msgKey = @"msg";
        self.successIden = @"1";
        self.nilDataIden = nil;
        
        self.encryptKey = @"encrypt";
        self.encryptValueKey = @"y";
        
        self.inValidTokenCode = @"-1402";   // 用户票据超时
        self.nullTokenCode = @"-1404";      // 用户票据不能为空
        
        self.tag = @"tag";
        
        self.offNetHint = @"网络开小差, 请检查网络连接";
        self.dataFromCacheHint = @"";   // @"网络错误, 数据来自缓存";
        self.queryFailureHint = @"";    // @"网络错误, 请稍后重试";
        
        self.uploadFileErrorHint = @"上传文件出错";
        self.imageMimeType = @"image/png";
        self.fileName = nil;
        
        self.wanNetTint = @"您当前使用的是流量";
        self.unknowNetTint = @"您当前正在使用位置网络";
        self.isHintNetStatus = NO;
        
        self.isRecordOperation = NO;
    }
    
    return self;
}

@end
