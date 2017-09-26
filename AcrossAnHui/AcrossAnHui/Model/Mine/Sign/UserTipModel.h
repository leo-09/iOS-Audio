//
//  UserTipModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 用户中心个人数据
 */
@interface UserTipModel : CTXBaseModel

@property (nonatomic, assign) BOOL isSign;
@property (nonatomic, assign) BOOL isDraw;
@property (nonatomic, assign) BOOL isReward;

@end
