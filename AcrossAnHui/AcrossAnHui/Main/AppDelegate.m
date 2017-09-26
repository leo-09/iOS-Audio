//
//  AppDelegate.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "AppDelegate.h"

#import "iflyMSC/IFlyMSC.h"// 讯飞语音
#import <AMapFoundationKit/AMapFoundationKit.h>// 高德地图
#import <AMapLocationKit/AMapLocationKit.h>
#import <UMSocialCore/UMSocialCore.h>// 友盟
#import "UMMobClick/MobClick.h"
#import <AlipaySDK/AlipaySDK.h>// 支付宝
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
    #import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#import "UseInfoLocalData.h"
#import "GuideViewController.h"
#import "AdvertisementViewController.h"
#import "OrderRoadInfoViewController.h"
#import "MessageCenterInfoViewController.h"
#import "ParkingViewController.h"
#import "ParkingRecordViewController.h"
#import "AdvertisementLocalData.h"

static NSString *appKey = @"8234e5834e7bb0b87523369e";
static NSString *channel = @"App Store";
static BOOL isProduction = YES;

static NSString *UMengAppKey = @"5864c8b9b27b0a1955000937";
static NSString *AMapServicesAppKey = @"7bc283281805928fc8c40c47930cf284";
static NSString *WXApiAppKey = @"wxa221159c22298e91";
static NSString *WXApiAppSecret = @"d308581acf09d94bc4c9164feae55054";
static NSString *QQAppKey = @"1104749164";

@interface AppDelegate()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate

+ (instancetype) sharedDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark - life cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 讯飞语音
    [self settingIFly];
    
    // 高德地图
    [AMapServices sharedServices].apiKey = AMapServicesAppKey;
    
    // 友盟
    [self setUMengAnalytics];
    [self setUMengSocial];
    
    // 推送
    [self startJPUSHWithapplication:application didFinishWithOpentions:launchOptions];
    
    // 设置微信支付
    [WXApi registerApp:WXApiAppKey];
    
    // UI逻辑
    CGRect frame = CGRectMake(0, 0, CTXScreenWidth, CTXScreenHeight);
    self.window = [[UIWindow alloc] initWithFrame:frame];
    self.window.backgroundColor = UIColorFromRGB(CTXBackGroundColor);
    [self.window makeKeyAndVisible];
    
    // 主界面
    self.rootController = [[CTXNavigationController alloc] init];
    self.mainController = [[CTXMainViewController alloc] init];
    
    // 当用户通过点击通知消息进入应用时,launchOptions中会有推送消息的userInfo信息,如果remoteNotification不为空，则说明用户通过推送消息进入
    NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        // 通知消息进入应用，不需要进入广告页
        [self.rootController setViewControllers:@[ self.mainController ]];
    } else {
        // 判断是否第一次使用或者版本更新了
        if ([[UseInfoLocalData sharedInstance] isFirstUseOrUpdata]) {
            // 第一次使用或者版本更新，则进入引导页
            GuideViewController *controller = [[GuideViewController alloc] init];
            [self.rootController setViewControllers:@[ self.mainController, controller ]];
        } else {
            // 否则判断是否进入广告页
            if ([[AdvertisementLocalData sharedInstance] getAdvertisementModel]) {
                // 需要展示广告页
                AdvertisementViewController *controller = [[AdvertisementViewController alloc] init];
                [self.rootController setViewControllers:@[ self.mainController, controller ]];
            } else {
                [self.rootController setViewControllers:@[ self.mainController ]];
            }
        }
    }
    
    self.window.rootViewController = self.rootController;
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 注册APNs成功并上报DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    // 当 DeviceToken 获取失败时，系统会回调此方法
    CTXLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self cleanBadge];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.host isEqualToString:@"safepay"]) {
        // 跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            CTXLog(@"result = %@", resultDic);
        }];
    }
    
    [WXApi handleOpenURL:url delegate:self];
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    if ([url.host isEqualToString:@"safepay"]) {
        // 跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000) {// success
                [[NSNotificationCenter defaultCenter] postNotificationName:PayResultNotificationName object:self userInfo:@{@"result": @"YES"}];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:PayResultNotificationName object:self userInfo:@{@"result": @"NO"}];
            }
        }];
    }
    
    [WXApi handleOpenURL:url delegate:self];
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    
    return result;
}

#pragma mark - private method

// 讯飞语音
- (void) settingIFly {
    // 设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    // 打开输出在console的log开关
    [IFlySetting showLogcat:YES];
    // 设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    // 创建语音配置,appid必须要传入，仅执行一次则可
    // 所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:@"appid=58abd266"];
}

// 友盟
- (void) setUMengAnalytics {
    // UMengAnalytics
    UMConfigInstance.appKey = UMengAppKey;
    UMConfigInstance.channelId = @"App Store";// 默认会被当作@"App Store"渠道
    UMConfigInstance.ePolicy = REALTIME;
    [MobClick setAppVersion:XcodeAppVersion];
    [MobClick setEncryptEnabled:YES];
    [MobClick setCrashReportEnabled:YES];// 崩溃日志
    [MobClick setLogEnabled:YES];// 打印统计相关的输出内容
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
}

- (void) setUMengSocial {
    // 打开日志
    [[UMSocialManager defaultManager] openLog:YES];
    // 设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMengAppKey];
    // 设置QQ平台的appID
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ
                                          appKey:QQAppKey
                                       appSecret:nil
                                     redirectURL:@"http://www.ah122.cn/App/appdownload.html"];
    // 设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
                                          appKey:WXApiAppKey
                                       appSecret:WXApiAppSecret
                                     redirectURL:@"http://www.ah122.cn/App/appdownload.html"];
    // 移除相应平台的分享，如微信收藏
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
}

#pragma mark - WXApiDelegate (微信支付结果的调用)

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        // 发送媒体消息结果
    }
    
    if ([resp isKindOfClass:[PayResp class]]) {
        switch (resp.errCode) {
            case WXSuccess: { // 支付结果: 成功
                [[NSNotificationCenter defaultCenter] postNotificationName:PayResultNotificationName object:self userInfo:@{@"result": @"YES"}];
            }
                break;
            case WXErrCodeCommon: { //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                [[NSNotificationCenter defaultCenter] postNotificationName:PayResultNotificationName object:self userInfo:@{@"result": @"NO"}];
            }
                break;
            case WXErrCodeUserCancel: { //用户点击取消并返回
                [[NSNotificationCenter defaultCenter] postNotificationName:PayResultNotificationName object:self userInfo:@{@"result": @"NO"}];
            }
                break;
            case WXErrCodeSentFail: { //发送失败
                CTXLog(@"发送失败");
            }
                break;
            case WXErrCodeUnsupport:{ //微信不支持
                CTXLog(@"微信不支持");
            }
                break;
            case WXErrCodeAuthDeny:{ //授权失败
                CTXLog(@"授权失败");
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - 远程推送

// 配置极光推送服务
- (void)startJPUSHWithapplication:(UIApplication *)application didFinishWithOpentions:(NSDictionary *)launchOpentions {
    // ---------------------- 添加初始化APNs代码 ----------------------
    // Required notice: 3.0.0及以后版本注册可以这样写,也可以继续 旧的注册 式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加 定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // ---------------------- 添加初始化JPush代码 ----------------------
    // 不使用IDFA
    [JPUSHService setupWithOption:launchOpentions appKey:appKey channel:channel apsForProduction:isProduction advertisingIdentifier:nil];
    
    // 2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            CTXLog(@"registrationID获取成功：%@", registrationID);
            [[UseInfoLocalData sharedInstance] saveRegistrationID:registrationID];// 保存registrationID
        } else {
            CTXLog(@"registrationID获取失败，code：%d", resCode);
        }
    }];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max

#pragma mark- JPUSHRegisterDelegate

// 前台得到的的通知对象
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        [self dealUserInfo:userInfo];
    }
    
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        [self dealUserInfo:userInfo];
    }
    
    completionHandler();  // 系统要求执行这个方法
}

// 收到远程推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    return completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

#pragma mark - Jpush private method

- (void) dealUserInfo:(NSDictionary *)userInfo {
    NSString * userInfoData = userInfo[@"data"];
    if (!userInfoData || [userInfoData isEqualToString:@""]) {
        [self showRoadPlanAlertControlWithUserInfo:userInfo];   // 显示路况消息
    } else {
        NSData *data = [userInfoData dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *type = [[dict objectForKey:@"type"] stringValue];
        
        [self showMessageAlertControlWithDict:dict type:type];
    }
}

- (void) showMessageAlertControlWithDict:(NSDictionary *)pushMsgDict type:(NSString *)type {
    NSString *title = @"";
    NSString *message = @"";
    MessageCenterInfoTag tag = Message_eventNotice;
    
    if ([type isEqualToString:@"1"]) {           // 事件消息
        title = @"有事件消息推送来了";
        message = @"是否前往消息内容界面";
        tag = Message_eventNotice;
    } else if ([type isEqualToString:@"2"]) {    // 系统消息
        title = @"有系统消息推送来了";
        message = @"是否前往消息内容界面";
        tag = Message_eventNotice;
    } else if ([type isEqualToString:@"3"]) {   // 停车入场
        title = @"有停车入场消息推送来了";
        message = @"是否前往停车服务首页";
    } else if ([type isEqualToString:@"5"]) {   /// 停车出场
        title = @"有停车出场消息推送来了";
        message = @"是否前往停车记录界面";
    }
    
    // 发送 ”推送“ 通知
    [[NSNotificationCenter defaultCenter] postNotificationName:PushMessageNotificationName object:self userInfo:nil];
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self reduceBadge];
        
        if ([type isEqualToString:@"1"] || [type isEqualToString:@"2"]) {   // 消息内容
            MessageCenterInfoViewController *controller = [[MessageCenterInfoViewController alloc]init];
            controller.tag = tag;
            controller.pushMsgDict = pushMsgDict;
            [self.mainController.navigationController pushViewController:controller animated:YES];
        } else if ([type isEqualToString:@"3"]) {
            ParkingViewController *controller = [[ParkingViewController alloc] init];
            [self.mainController.navigationController pushViewController:controller animated:YES];
        } else if ([type isEqualToString:@"5"]) {
            ParkingRecordViewController *controller = [[ParkingRecordViewController alloc] init];
            [self.mainController.navigationController pushViewController:controller animated:YES];
        }
    }];
    
    UIAlertAction *cancleAlertion = [UIAlertAction actionWithTitle:@"不前往" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // 不做操作
    }];
    
    [alertControl addAction:trueAction];
    [alertControl addAction:cancleAlertion];
    [self.window.rootViewController presentViewController:alertControl animated:true completion:nil];
}

- (void) showRoadPlanAlertControlWithUserInfo:(NSDictionary *)userInfo {
    // 路况消息
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"有路况消息推送来了" message:@"是否前往路况界面" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self reduceBadge];
        // 在地图查看 定制路况 的详情，可导航
        OrderRoadInfoViewController *controller = [[OrderRoadInfoViewController alloc]init];
        // 起点
        NSString *startStr = userInfo[@"origin"];
        NSArray *startArray = [startStr componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
        if (startArray && startArray.count > 1) {
            controller.startPoint = [AMapNaviPoint locationWithLatitude:[startArray[0] doubleValue] longitude:[startArray[1] doubleValue]];
        } else {
            controller.startPoint = [AMapNaviPoint locationWithLatitude:defaultLatitude longitude:defaultLongitude];
        }
        // 终点
        NSString *endStr = userInfo[@"destination"];
        NSArray *endArray = [endStr componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
        if (endArray && endArray.count > 1) {
            controller.endPoint = [AMapNaviPoint locationWithLatitude:[endArray[0] doubleValue] longitude:[endArray[1] doubleValue]];
        } else {
            controller.endPoint = [AMapNaviPoint locationWithLatitude:defaultLatitude longitude:defaultLongitude];
        }
        
        [self.mainController.navigationController pushViewController:controller animated:YES];
    }];
    
    UIAlertAction *cancleAlertion = [UIAlertAction actionWithTitle:@"不前往" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // 不做操作
    }];
    
    [alertControl addAction:trueAction];
    [alertControl addAction:cancleAlertion];
    [self.window.rootViewController presentViewController:alertControl animated:true completion:nil];
}

#pragma mark - private method

- (void) reduceBadge {
    NSInteger badgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badgeNumber--;
    
    if (badgeNumber < 0) {
        badgeNumber = 0;
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = badgeNumber;
    [JPUSHService setBadge:badgeNumber];
}

- (void) cleanBadge {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService resetBadge];
}

#endif

@end
