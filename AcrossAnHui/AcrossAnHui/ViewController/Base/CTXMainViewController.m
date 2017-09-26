//
//  CTXMainViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/4/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXMainViewController.h"
#import "HomeViewController.h"
#import "NearbyViewController.h"
#import "ServiceViewController.h"
#import "MineViewController.h"

@interface CTXMainViewController ()

@end

@implementation CTXMainViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    self.tabBar.barTintColor = [UIColor whiteColor];
    
    [self addViewControllers];
}

#pragma mark - private method

- (void) addViewControllers {
    NSDictionary *normalDict = @{ NSForegroundColorAttributeName:UIColorFromRGB(CTXBaseFontColor) };
    NSDictionary *themeDict = @{ NSForegroundColorAttributeName:UIColorFromRGB(CTXThemeColor) };
    
    HomeViewController *homeController = [[HomeViewController alloc] init];
    homeController.tabBarItem.title = @"首页";
    homeController.tabBarItem.image = [[UIImage imageNamed:@"shouye"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeController.tabBarItem.selectedImage = [[UIImage imageNamed:@"shouye_click"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [homeController.tabBarItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
    [homeController.tabBarItem setTitleTextAttributes:themeDict forState:UIControlStateSelected];
    
    NearbyViewController *parkController = [[NearbyViewController alloc] init];
    parkController.tabBarItem.title = @"附近";
    parkController.tabBarItem.image = [[UIImage imageNamed:@"fujin"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    parkController.tabBarItem.selectedImage = [[UIImage imageNamed:@"fujin_click"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [parkController.tabBarItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
    [parkController.tabBarItem setTitleTextAttributes:themeDict forState:UIControlStateSelected];
    
    ServiceViewController *financeController = [[ServiceViewController alloc] init];
    financeController.tabBarItem.title = @"服务";
    financeController.tabBarItem.image = [[UIImage imageNamed:@"fuwu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    financeController.tabBarItem.selectedImage = [[UIImage imageNamed:@"fuwu_click"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [financeController.tabBarItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
    [financeController.tabBarItem setTitleTextAttributes:themeDict forState:UIControlStateSelected];
    
    MineViewController *personalController = [[MineViewController alloc] initWithStoryboard];
    personalController.tabBarItem.title = @"我的";
    personalController.tabBarItem.image = [[UIImage imageNamed:@"wode"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    personalController.tabBarItem.selectedImage = [[UIImage imageNamed:@"wode_click"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [personalController.tabBarItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
    [personalController.tabBarItem setTitleTextAttributes:themeDict forState:UIControlStateSelected];
    
    self.viewControllers = @[homeController, parkController, financeController, personalController];
}

@end
