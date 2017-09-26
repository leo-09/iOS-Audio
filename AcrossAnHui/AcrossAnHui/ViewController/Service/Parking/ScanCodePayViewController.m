//
//  ScanCodePayViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ScanCodePayViewController.h"
#import "ParkingViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "KLCDTextHelper.h"
#import "CarInspectRecordNetData.h"

@interface ScanCodePayViewController ()

@property (nonatomic, assign) BOOL isWeChatPay;// 是否微信支付 还是 支付宝支付
@property (nonatomic, retain) CarInspectRecordNetData *recordNetData;

@end

@implementation ScanCodePayViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"Parking" bundle:nil] instantiateViewControllerWithIdentifier:@"ScanCodePayViewController"];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"停车支付";
    
    // 默认支付宝支付
    self.isWeChatPay = NO;
    
    CTXViewBorderRadius(_payLabel, 3.0, 0, [UIColor clearColor]);
    
    _carInfoLabel.text = [NSString stringWithFormat:@"%@ %@", _model.magCard, _model.carname];
    _startTimeLabel.text = [NSString stringWithFormat:@"停车时间：%@", _model.parkTime];
    _addressLabel.text = [NSString stringWithFormat:@"停车地址：%@", _model.sitename];
    _chargingLabel.text = [NSString stringWithFormat:@"停车计费：%.2f元", _model.money];
    _timeLabel.text = [NSString stringWithFormat:@"停车计时：%@", [self sumMins]];
    
    _recordNetData = [[CarInspectRecordNetData alloc] init];
    _recordNetData.delegate = self;
}

- (NSString *) sumMins {
    if (_model) {
        int hour = _model.sumMins / 60;
        int minute = _model.sumMins % 60;
        
        if (hour > 0) {
            return [NSString stringWithFormat:@"%d小时%d分钟", hour, minute];
        } else {
            return [NSString stringWithFormat:@"%d分钟", minute];
        }
    } else {
        return @"0分";
    }
}

#pragma mark UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60;
    } else if (indexPath.row == 1) {
        CGFloat height = 38 * 3 + 20 + 23;
        
        height += [KLCDTextHelper HeightForText:_addressLabel.text withFontSize:CTXTextFont withTextWidth:(CTXScreenWidth - 57)];
        return height;
    } else if (indexPath.row == 2) {
        return 20;
    } else if (indexPath.row == 3 || indexPath.row == 4) {
        return 70;
    } else if (indexPath.row == 6) {
        return 40;
    } else {
        return 15;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {// 支付宝
        self.isWeChatPay = NO;
        _alipayIV.image = [UIImage imageNamed:@"goux_car"];
        _webChatIV.image = [UIImage imageNamed:@"weigoux_car"];
    } else if (indexPath.row == 4) {// 微信
        self.isWeChatPay = YES;
        _alipayIV.image = [UIImage imageNamed:@"weigoux_car"];
        _webChatIV.image = [UIImage imageNamed:@"goux_car"];
    } else if (indexPath.row == 6) {// 确认支付
        if (self.isWeChatPay) {
            [self wxPayAPP];
        } else {
            [self alipayPay];
        }
    }
}

#pragma mark - netWork

// 支付宝APP支付
- (void) alipayPay {
    [self showHubWithLoadText:@"支付中..."];
    
    [_recordNetData aliPayWithToken:self.loginModel.token
                       BusinessCode:self.model.orderNum desc:@"停车支付"
                             payFee:[NSString stringWithFormat:@"%f", self.model.money] tag:@"aliPayTag"];
}

// 微信APP支付
- (void) wxPayAPP {
    [self showHubWithLoadText:@"支付中..."];
    
    [_recordNetData weChatPayWithToken:self.loginModel.token
                          BusinessCode:self.model.orderNum desc:@"停车支付"
                                payFee:[NSString stringWithFormat:@"%f", self.model.money] tag:@"weChatPayTag"];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"aliPayTag"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webChatPayResult:) name:PayResultNotificationName object:nil];
        
        // 调用支付宝支付
        [[AlipaySDK defaultService] payOrder:(NSString *) result fromScheme:@"comahkeliAcrossAnHui2"
                                    callback:^(NSDictionary *resultDic) {
            int resultStatus = [resultDic[@"resultStatus"] intValue];
            if (resultStatus == 9000) {// 支付成功
                [self goBackBtnClick];
            } else {
                [self showTextHubWithContent:@"支付失败"];
            }
        }];
    }
    
    if ([tag isEqualToString:@"weChatPayTag"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webChatPayResult:) name:PayResultNotificationName object:nil];
        
        // 支付参数
        NSDictionary *dict = (NSDictionary *)result;
        
        PayReq * request = [[PayReq alloc] init];
        request.partnerId = dict[@"partnerid"];                 // 客户id
        request.prepayId = dict[@"prepayid"];                   // prepayid
        request.package = dict[@"package"];                     // 请求包
        request.nonceStr = dict[@"noncestr"];                   // 字符串
        request.timeStamp = [dict[@"timestamp"] doubleValue];   // 时间戳
        request.sign = dict[@"sign"];                           // 签名
        
        [WXApi sendReq:request];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
}

#pragma mark - 支付结果的通知

- (void) webChatPayResult:(NSNotification *)noti {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if ([noti.userInfo[@"result"] isEqualToString:@"YES"]) {
        [self goBackBtnClick];
    } else {
        [self showTextHubWithContent:@"支付失败"];
    }
}

-(void)goBackBtnClick {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ParkingViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

@end
