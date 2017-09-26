//
//  CTXBaseViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/4/28.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import "UMMobClick/MobClick.h"
#import "LoginViewController.h"
#import "CTXNavigationController.h"
#import "MBProgressHUDTool.h"
#import "OYCountDownManager.h"
#import "HomeLocalData.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "UseInfoLocalData.h"
#import "CoreServeNetData.h"

@interface CTXBaseViewController()

@property (nonatomic, retain) AMapLocationManager *locationManager;

@end

@implementation CTXBaseViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.isCanPushViewController = YES;// 每次进入，重新置为YES,表示可以push ViewController
    
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    
    // 返回上一级按钮
    backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_white"] style:UIBarButtonItemStyleDone target:self action:@selector(close:)];
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backItem;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

-(void)dealloc {
    [kCountDownManager invalidate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    CTXLog(@"%@ dealloc", NSStringFromClass([self class]));
}

// 关闭View
- (void) close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - super method

- (BOOL) gestureRecognizerShouldBegin {
    return YES;
}

#pragma mark - MBProgressHUD

- (void) showHubWithLoadText:(NSString *) text {
    [[MBProgressHUDTool sharedInstance] showHubWithLoadText:text superView:self.view];
}

- (void) showHub {
    [[MBProgressHUDTool sharedInstance] showHubWithLoadText:@"查询中..." superView:self.view];
}

- (void) hideHub {
    [[MBProgressHUDTool sharedInstance] hideHub];
}

- (void) showTextHubWithContent:(NSString *) content {
    [[MBProgressHUDTool sharedInstance] showTextHubWithContent:content];
}

#pragma mark - 操作前 需要登录/Token有效

- (void) loginFirstWithBlock:(GlobalLoginSuccessBlock) loginSuccessBlock {
    self.firstLoginSuccessBlock = loginSuccessBlock;
    
    // 获取帐号信息
    NSString *account = [[LoginInfoLocalData sharedInstance] getAccount];
    NSString *psw = [[LoginInfoLocalData sharedInstance] getPassword];
    
    if (account && psw && ![account isEqualToString:@""] && ![psw isEqualToString:@""]) {
        // 有帐号密码，则需要更新Token
        AccountNetData * accountNetData = [[AccountNetData alloc] init];
        accountNetData.delegate = self;
        [accountNetData loginWithPhone:account passsword:psw tag:toLoginTag];
    } else {
        // 没有帐号密码，则需要登录
        [self toLoginView];
    }
}

- (void) toLoginView {
    LoginViewController *controller = [[LoginViewController alloc] init];
    [controller setLoginSuccessBlock:self.firstLoginSuccessBlock];
    CTXNavigationController *naviController = [[CTXNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:naviController animated:YES completion:nil];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    [self showTextHubWithContent:tint];// 提示数据是来自缓存的
    
    if ([tag isEqualToString:toLoginTag]) {
        [self updateLoginModelWithResult:(NSDictionary *)result];
        
        // 绑定极光不成功，则重新绑定极光
        if (![[UseInfoLocalData sharedInstance] isJPushBindSuccess]) {
            CoreServeNetData *coreServeNetData = [[CoreServeNetData alloc] init];
            coreServeNetData.delegate = self;
            [coreServeNetData bindingJpushUrlWithToken:self.loginModel.token tag:@"bindingJpushUrlTag"];
        }
        
        if (self.firstLoginSuccessBlock) {
            self.firstLoginSuccessBlock(self.loginModel.token);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotificationName object:nil userInfo:nil];
    }
    
    if ([tag isEqualToString:@"bindingJpushUrlTag"]) {
        [[UseInfoLocalData sharedInstance] setJPushBindSuccess];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    if ([tag isEqualToString:toLoginTag]) {
        [self toLoginView];
    }
}

// 统一处理 token失效或者token为空
- (void) inValidOrNullTokenWithBlock:(GlobalLoginSuccessBlock) loginSuccessBlock {
    [self loginFirstWithBlock:loginSuccessBlock];
}

// 没有网络的回调,并记录当前的操作
- (void) offTheNetworkWithBlock:(GlobalLoginSuccessBlock) networkEnableBlock {
    if (!self.offNetOperations) {
        self.offNetOperations = [[NSMutableArray alloc] init];
    }
    
    [self.offNetOperations addObject:networkEnableBlock];
    
    // 启动倒计时管理
    [kCountDownManager start];
    // 监听通知,判断网络状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:kCountDownNotification object:nil];
}

//提示当前使用的是流量
- (void) toastNetStatusWithTint:(NSString *)tint {
    [self showTextHubWithContent:tint];
}

#pragma mark - private method

// 断网的情况下，每秒都判断网络状态
- (void)countDownNotification {
    // 网络又有链接了
    if ([[BaseNetDataRequestTool sharedInstance] isNetworkEnable]) {
        // 关闭定时器
        [kCountDownManager invalidate];
        
        // 重新加载请求
        for (GlobalLoginSuccessBlock block in self.offNetOperations) {
            block(self.loginModel.token);
        }
        
        [self.offNetOperations removeAllObjects];
    }
}

// 更新loginModel
- (void) updateLoginModelWithResult:(NSDictionary *)result {
    // 获取登录返回的结果
    LoginModel *loginModel = [LoginModel convertFromDict:result];
    // 保存帐号信息
    [[LoginInfoLocalData sharedInstance] saveLoginModel:loginModel];
    self.loginModel = loginModel;
}

- (LoginModel *) loginModel {
    _loginModel = [[LoginInfoLocalData sharedInstance] getLoginModel];// 获取登录的用户信息
    
    return _loginModel;
}

#pragma mark - public method

- (void) basePushViewController:(UIViewController *)controller {
    if (self.isCanPushViewController) {
        self.isCanPushViewController = NO;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - 定位 Action Handle

- (void)startUpdatingLocationWithBlock:(void (^)()) locationSuccessBlock {
    if ([[AppDelegate sharedDelegate].aMapLocationModel isExistenceValue]) {
        // 定位完成后的操作
        if (locationSuccessBlock) {
            locationSuccessBlock();
        }
        return;
    }
    
    [self reStartUpdatingLocationWithBlock:locationSuccessBlock];
}

- (void) reStartUpdatingLocationWithBlock:(void (^)()) locationSuccessBlock {
    self.locationManager = [[AMapLocationManager alloc] init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    // 定位超时时间，最低2s
    [self.locationManager setLocationTimeout:6];
    // 逆地理请求超时时间，最低2s
    [self.locationManager setReGeocodeTimeout:6];
    
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            CTXLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            // 定位失败,如果没有缓存，则保存默认值
            if (![[HomeLocalData sharedInstance] getAMapLocationModel]) {
                // 默认值
                AMapLocationModel *model = [AMapLocationModel defaultValue];
                
                [[HomeLocalData sharedInstance] saveAMapLocationModel:model];
                [AppDelegate sharedDelegate].aMapLocationModel = model;
            } else {
                [AppDelegate sharedDelegate].aMapLocationModel = [[HomeLocalData sharedInstance] getAMapLocationModel];
            }
        } else {
            //逆地理信息
            AMapLocationModel *model = [[AMapLocationModel alloc] init];
            model.province = regeocode.province;
            model.city = regeocode.city;
            model.district = regeocode.district;
            model.formattedAddress = regeocode.formattedAddress;
            model.latitude = location.coordinate.latitude;
            model.longitude = location.coordinate.longitude;
            
            [[HomeLocalData sharedInstance] saveAMapLocationModel:model];
            [AppDelegate sharedDelegate].aMapLocationModel = model;
        }
        
        // 定位完成后的操作
        if (locationSuccessBlock) {
            locationSuccessBlock();
        }
    }];
}

@end
