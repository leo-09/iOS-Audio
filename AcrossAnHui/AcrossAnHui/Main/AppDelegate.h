//
//  AppDelegate.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"// 微信支付
#import "AMapLocationModel.h"

#import "CTXNavigationController.h"
#import "CTXMainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) CTXNavigationController * rootController;
@property (nonatomic, retain) CTXMainViewController *mainController;

@property (nonatomic, retain) AMapLocationModel *aMapLocationModel;

@property (nonatomic, assign) BOOL isBindCar;// 是否绑定车辆

+ (instancetype) sharedDelegate;

// Badge减1
- (void) reduceBadge;
// Badge清零
- (void) cleanBadge;

@end
