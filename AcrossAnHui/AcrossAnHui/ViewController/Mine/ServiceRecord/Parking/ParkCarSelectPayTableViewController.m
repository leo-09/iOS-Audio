//
//  ParkCarSelectPayTableViewController.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ParkCarSelectPayTableViewController.h"
#import "CarInspectRecordNetData.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

static NSString *appsheme = @"comahkeliAcrossAnHui2";

@interface ParkCarSelectPayTableViewController () {
    NSInteger _selectValue;
}

@property (nonatomic ,retain)CarInspectRecordNetData * carInspectRecordNetData;

@end

@implementation ParkCarSelectPayTableViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"ParkRecodeView" bundle:nil] instantiateViewControllerWithIdentifier:@"parkselect"];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付选择";
    _carInspectRecordNetData = [[CarInspectRecordNetData alloc]init];
    _carInspectRecordNetData.delegate = self;
}

#pragma mark - UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  68;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        _selectValue = 1;
    } else if (indexPath.row == 1){
        _selectValue = 2;
    }
    
    [self pay];
}

#pragma mark - 支付

- (void) pay {
    NSString * payFee = [NSString stringWithFormat:@"%0.2f",_payFee];
    if (_selectValue==1) {
        [_carInspectRecordNetData aliPayWithToken:self.loginModel.token BusinessCode:self.businessCode desc:@"停车支付" payFee:payFee tag:@"aliPayTag"];
    }
    
    if (_selectValue == 2) {
        [_carInspectRecordNetData weChatPayWithToken:self.loginModel.token BusinessCode:self.businessCode desc:@"停车支付" payFee:payFee tag:@"weChatPayTag"];
    }
}

- (void)payAction:(NSNotification*)notInfo {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:PayResultNotificationName object:nil];
    
    if ([[[notInfo userInfo]objectForKey:@"result"] boolValue]) {
        [self performSelector:@selector(replyTime) withObject:self afterDelay:1];
    }
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
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
    
    if ([tag isEqualToString:@"aliPayTag"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webChatPayResult:) name:PayResultNotificationName object:nil];
        
        // 调用支付宝支付
        NSString *payOrder = (NSString *)result;// 订单信息
        [[AlipaySDK defaultService] payOrder:payOrder fromScheme:appsheme callback:^(NSDictionary *resultDic) {
            int resultStatus = [resultDic[@"resultStatus"] intValue];
            if (resultStatus == 9000) {// 支付成功
                [self replyTime];
            }
        }];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self hideHub];
    [self showTextHubWithContent:tint];
}

// 微信支付结果的通知
- (void) webChatPayResult:(NSNotification *)noti {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if ([noti.userInfo[@"result"] isEqualToString:@"YES"]) {
        [self replyTime];
    } else {
         [self showTextHubWithContent:@"支付失败"];
    }
}

#pragma mark 推迟2秒进入到详情界面

-(void)replyTime {
    [self.navigationController popViewControllerAnimated:true];
    [[NSNotificationCenter defaultCenter]postNotificationName:ParkingPaySuccessNotificationName object:self userInfo:nil];
    [self showTextHubWithContent:@"支付成功"];
}

-(void)setSelectCellListener:(void (^)())listener {
    selectCellListener = listener;
}

@end
