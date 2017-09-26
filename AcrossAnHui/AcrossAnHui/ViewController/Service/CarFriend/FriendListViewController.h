//
//  FriendListViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"

/**
 好友列表
 */
@interface FriendListViewController : CTXBaseViewController

// 帖子ID
@property (nonatomic, copy) NSString *cardID;

@property (nonatomic, assign) int currentPage;

@end
