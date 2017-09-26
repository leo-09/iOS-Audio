//
//  CarFriendInfoViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import "CarFriendCardModel.h"

/**
 问小畅、随手拍详情
 */
@interface CarFriendInfoViewController : CTXBaseViewController

@property (nonatomic, copy) NSString *cardID;

@property (nonatomic, assign) int currentPage;

@end
