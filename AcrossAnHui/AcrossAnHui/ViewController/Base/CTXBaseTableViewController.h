//
//  CTXBaseTableViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Masonry.h"
#import "YYKit.h"
#import "LoginInfoLocalData.h"
#import "AccountNetData.h"
#import "LoginModel.h"
#import "NotificationNameMacro.h"

@interface CTXBaseTableViewController : UITableViewController<CTXNetDataDelegate> {
    UIBarButtonItem *backItem;
}

@property (nonatomic, assign) BOOL isCanPushViewController;// 保证push ViewController只会被调用一次

@property (nonatomic, strong) GlobalLoginSuccessBlock firstLoginSuccessBlock;
@property (nonatomic, retain) LoginModel *loginModel;

@property (nonatomic, retain) NSMutableArray<GlobalLoginSuccessBlock> *offNetOperations;

- (void) close:(id)sender;

- (BOOL) gestureRecognizerShouldBegin;

- (void) showHub;
- (void) showHubWithLoadText:(NSString *) text;
- (void) hideHub;

- (void) showTextHubWithContent:(NSString *) content;

// 定位
- (void) startUpdatingLocationWithBlock:(void (^)()) locationSuccessBlock;
- (void) reStartUpdatingLocationWithBlock:(void (^)()) locationSuccessBlock;

/**
 操作前，先登录
 
 @param loginSuccessBlock 登录成功后的回调
 */
- (void) loginFirstWithBlock:(GlobalLoginSuccessBlock) loginSuccessBlock;

/**
 更新loginModel
 
 @param result 请求结果
 */
- (void) updateLoginModelWithResult:(NSDictionary *)result;

// 统一的push处理
- (void) basePushViewController:(UIViewController *)controller;

@end
