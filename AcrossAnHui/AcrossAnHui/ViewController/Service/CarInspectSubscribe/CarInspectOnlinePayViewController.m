//
//  CarInspectOnlinePayViewController.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectOnlinePayViewController.h"
#import "YYKit.h"
#import "UILabel+lineSpace.h"
#import "PayResultViewController.h"
#import "CarInspectNetData.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

static NSString *appsheme = @"comahkeliAcrossAnHui2";

@interface CarInspectOnlinePayViewController ()
@property (nonatomic, assign) BOOL isWeChatPay;// 是否微信支付 还是 支付宝支付
@property (nonatomic, retain) CarInspectNetData *carInspectNetData;
@end

@implementation CarInspectOnlinePayViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"CarInspectSubscribeView" bundle:nil] instantiateViewControllerWithIdentifier:@"CarInspectOnlinePayViewController"];//CarInspetAppointmentViewController
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付页面";
    self.isWeChatPay = NO;
    _carInspectNetData = [[CarInspectNetData alloc]init];
    _carInspectNetData.delegate = self;
    
    [self.stationImg setImageWithURL:[NSURL URLWithString:_model.stationPic] placeholder:[UIImage imageNamed:@"zet-1"]];
    self.stationInfoLab.numberOfLines = 0;
    self.stationInfoLab.text = [NSString stringWithFormat:@"%@\n%@",_model.stationName,_model.stationAddr];
    [self.stationInfoLab getLabelHeightWithLineSpace:3 WithWidth:CTXScreenWidth-12-100-18-12 WithNumline:0];
   
    self.plateLab.text = [NSString stringWithFormat:@"车牌号:%@",_model.carLisence];
    self.nameLab.text = [NSString stringWithFormat:@"联系人:%@",_model.contactPerson];
    self.oederTimeLab.text = [NSString stringWithFormat:@"预约时间:%@ %@-%@",_model.orderDay,_model.startTime, _model.endTime];
    self.orderNumberLab.text  = [NSString stringWithFormat:@"订单编号:%@", _model.businessCode];
    self.orderPayLab.text  = [NSString stringWithFormat:@"￥%0.2f元",_model.payfee];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 4) {
        self.isWeChatPay = NO;
        _alipayIV.image = [UIImage imageNamed:@"goux_car"];
        _webChatIV.image = [UIImage imageNamed:@"weigoux_car"];
    }
    
    // 微信
    if (indexPath.row == 5) {
        self.isWeChatPay = YES;
        _alipayIV.image = [UIImage imageNamed:@"weigoux_car"];
        _webChatIV.image = [UIImage imageNamed:@"goux_car"];
    }
    if (indexPath.row == 7) {
        [self pay];
    }
}

#pragma mark - 支付

- (void) pay {
    NSString *desc = [NSString stringWithFormat:@"%@申请车检预约", self.model.stationName];
    
    if (self.isWeChatPay) {
        [_carInspectNetData weChatPayWithBusinessCode:self.model.businessCode desc:desc tag:@"weChatPayTag"];
    } else {
        [_carInspectNetData aliPayWithBusinessCode:self.model.businessCode desc:desc tag:@"aliPayTag"];
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
                [self toPayResultViewController];
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
        [self toPayResultViewController];
    } else {
        [self showTextHubWithContent:@"支付失败"];
    }
}

- (void) toPayResultViewController {
    // 跳转到支付成功页面
    PayResultViewController *controller = [[PayResultViewController alloc] init];
    controller.tag = ChannelPay_CarInspectSubscribePay;
    controller.businessId = self.model.businessid;
    [self basePushViewController:controller];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
