//
//  ServeData.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseLocalData.h"
#import "ServeModel.h"

@interface ServeLocalData : CTXBaseLocalData

+ (instancetype) sharedInstance;

/**
 读取所有的服务信息

 @return 服务列表
 */
- (NSArray *) readLocalServeCollection;

/**
 读取 定制服务列表

 @return 定制服务列表
 */
- (ServeSuperModel *) readSelectedServe;

/**
 更新 定制服务列表

 @param model 定制服务列表
 */
- (void) updateSelectedServe:(ServeSuperModel *)model;

/**
 是否更新了 定制服务列表
 */
- (BOOL) isUpdateSelectedServeToDocuments;
- (void) updateSelectedServeToDocuments:(NSString *) isUpdate;

@end
