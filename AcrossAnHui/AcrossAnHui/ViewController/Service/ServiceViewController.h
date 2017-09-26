//
//  ServiceViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import "CServiceView.h"
#import "ServeModel.h"

/**
 服务
 */
@interface ServiceViewController : CTXBaseViewController

@property (nonatomic, retain) CServiceView *serviceView;

@property (nonatomic, retain) NSArray *advModels;
@property (nonatomic, retain) NSArray *serveModels;

@end
