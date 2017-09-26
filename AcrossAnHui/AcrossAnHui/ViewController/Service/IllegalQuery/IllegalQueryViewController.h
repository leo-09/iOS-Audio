//
//  IllegalQueryViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import "CarIllegalInfoModel.h"

/**
 违章查询
 */
@interface IllegalQueryViewController : CTXBaseViewController

@property (nonatomic, retain) CarIllegalInfoModel *currentCarModel;// 选中的 默认显示第几辆车的违章信息

@end
