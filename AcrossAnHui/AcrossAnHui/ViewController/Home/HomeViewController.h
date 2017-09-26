//
//  HomeViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import "HomeNetData.h"
#import "CHomeView.h"
#import "MineNetData.h"
#import "ServiceNetData.h"
#import "HomeRightBarButtonItem.h"

/**
 首页
 */
@interface HomeViewController : CTXBaseViewController {
    BOOL isGetAppStoreVersion;
}

@property (nonatomic, retain) HomeNetData *homeNetData;
@property (nonatomic, retain) MineNetData *mineNetData;
@property (nonatomic, retain) ServiceNetData *serviceNetData;

@property (nonatomic, retain) CHomeView *homeView;
@property (nonatomic, retain) UIButton *navLeftBtn;
@property (nonatomic, retain) HomeRightBarButtonItem *rightBarButtonItem;

@end
