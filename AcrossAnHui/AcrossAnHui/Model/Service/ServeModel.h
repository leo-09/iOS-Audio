//
//  ServeModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

typedef enum {
    CAN_DELETE_STATUS = 0,
    SELECTED_STATUS,
    CAN_ADD_STATUS
} SelectStatus;

/**
 服务的model
 */
@interface ServeModel : CTXBaseModel

@property (nonatomic, copy) NSString *serveID;
@property (nonatomic, copy) NSString *name;               // 服务名                  优先级：1
@property (nonatomic, copy) NSString *urlAddress;         // html界面                优先级：2
@property (nonatomic, copy) NSString *targetInstance;     // 对应的目标对象            优先级：3
@property (nonatomic, assign) BOOL isNeedLogin;             // 是否需要登录 才能使用      优先级：3.0

@property (nonatomic, assign) SelectStatus selectStatus;    // 选中状态
@property (nonatomic, copy) NSString *image;              // 服务图标

- (NSString *) selectStatusImage;
- (Class) getNSClassFromString;

- (NSString *) serveModelToJSONString;

@end


/**
 服务集合的model
 */
@interface ServeSuperModel : CTXBaseModel

@property (nonatomic, copy) NSString *nameKey;        // 模块名
@property (nonatomic, copy) NSString *imageKey;       // 模块图标
@property (nonatomic, retain) NSMutableArray<ServeModel *> *serveArray;      // 模块下的服务

- (NSString *) serveModelToJSONString;

@end
