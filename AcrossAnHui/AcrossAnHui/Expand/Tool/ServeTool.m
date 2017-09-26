//
//  ServeTool.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ServeTool.h"
#import <UIKit/UIApplication.h>
#import "EditHomeServeViewController.h"
#import "CTXWKWebViewController.h"
#import "SelectBindedCarViewController.h"
#import "SubmitCarInfoViewController.h"
#import "CarFreeInspectViewController.h"
#import "CarInspectSubscribeViewController.h"
#import "CarInspectAgencyViewController.h"
#import "CarFriendViewController.h"

@implementation ServeTool

#pragma mark - public method

// 拨打电话
+ (void) callPhone:(NSString *)phone {
    if (phone.length == 0) {
        return;
    }
    
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phone];
    
    CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 10.0) {
        // 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}

+ (void) pushServeWithModel:(ServeModel *)model currentViewController:(CTXBaseViewController *) vc block:(ClickListener) loginSuccessBlock {
    if ([model.name isEqualToString:@"编辑首页"]) {
        EditHomeServeViewController *controller = [[EditHomeServeViewController alloc] init];
        [vc basePushViewController:controller];
    } else if ([model.name isEqualToString:@"加油服务"]) {
        [self openAlipays];
    } else if (model.urlAddress && ![model.urlAddress isEqualToString:@""]) {
        CTXWKWebViewController *controller = [[CTXWKWebViewController alloc] init];
        controller.name = model.name;
        controller.url = model.urlAddress;
        controller.desc = nil;
        controller.isNotUpdateNaviTitle = YES;
        [vc basePushViewController:controller];
    } else if ([model.targetInstance isEqualToString:@""]) {
        [vc showTextHubWithContent:@"敬请期待"];
    } else {
        // 需要登录且token为空
        if (model.isNeedLogin && !vc.loginModel.token) {
            [vc loginFirstWithBlock:^(id newToken) {
                loginSuccessBlock();
            }];
        } else {
            // 六年免检、车检代办、车检预约，需要判断是否已绑定车辆
            if ([model.targetInstance isEqualToString:NSStringFromClass([CarFreeInspectViewController class])] ||
                [model.targetInstance isEqualToString:NSStringFromClass([CarInspectSubscribeViewController class])] ||
                [model.targetInstance isEqualToString:NSStringFromClass([CarInspectAgencyViewController class])]) {
                
                if ([AppDelegate sharedDelegate].isBindCar) {
                    // 绑定车辆则去选择车辆
                    SelectBindedCarViewController *controller = [[SelectBindedCarViewController alloc] init];
                    controller.fromViewController = model.targetInstance;
                    [vc basePushViewController:controller];
                } else {
                    // 没有绑定车辆则去添加车辆
                    SubmitCarInfoViewController *controller = [[SubmitCarInfoViewController alloc] initWithStoryboard];
                    controller.fromViewController = model.targetInstance;
                    [vc basePushViewController:controller];
                }
            } else if ([model.targetInstance isEqualToString:NSStringFromClass([CarFriendViewController class])]) {
                // 问小畅、随手拍
                CarFriendViewController *controller = [[CarFriendViewController alloc] init];
                controller.themeName = model.name;
                [vc basePushViewController:controller];
            } else {
                Class vcClass = [model getNSClassFromString];
                UIViewController *controller = [[vcClass alloc] init];
                [vc basePushViewController:controller];
            }
        }
    }
}

#pragma mark - private method

// 打开支付宝
+ (void) openAlipays {
    NSURL *url = [NSURL URLWithString:@"alipays://platformapi/startapp?appId=20000781"];
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSURL *stpneUrl = [NSURL URLWithString:@"https://itunes.apple.com/us/app/zhi-fu-bao-kou-bei-sheng-huo/id333206289?mt=8"];
        [[UIApplication sharedApplication] openURL:stpneUrl];
    }
}

@end
