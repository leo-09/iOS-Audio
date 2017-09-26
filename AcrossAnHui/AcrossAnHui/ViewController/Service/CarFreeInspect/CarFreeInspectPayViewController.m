
//
//  CarFreeInspectPayViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/4.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarFreeInspectPayViewController.h"
#import "PayResultViewController.h"
#import "CarInspectNetData.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

static NSString *appsheme = @"comahkeliAcrossAnHui2";

@interface CarFreeInspectPayViewController ()

@property (nonatomic, assign) CGFloat orderInfoHeight;
@property (nonatomic, assign) BOOL isWeChatPay;// 是否微信支付 还是 支付宝支付

@property (nonatomic, retain) CarInspectNetData *carInspectNetData;

@end

@implementation CarFreeInspectPayViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"CarFreeInspect" bundle:nil] instantiateViewControllerWithIdentifier:@"CarFreeInspectPayViewController"];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单支付";
    self.isWeChatPay = NO;
    
    _carInspectNetData = [[CarInspectNetData alloc] init];
    _carInspectNetData.delegate = self;
    
    // 订单详情
    NSString *orderDescription = [self.model orderDescription];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 15.0f;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:(orderDescription ? orderDescription : @"")];
    text.attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:CTXTextFont],
                         NSParagraphStyleAttributeName : paragraphStyle };
    text.color = UIColorFromRGB(CTXBaseFontColor);
    text.font = [UIFont systemFontOfSize:CTXTextFont];
    NSString *rangeOfString = [self.model orderMoney] ? [self.model orderMoney] : @"";
    NSRange range = [orderDescription rangeOfString:rangeOfString options:NSBackwardsSearch];
    [text setColor:[UIColor orangeColor] range:range];
    // 计算 text 的高度
    CGSize attSize = [text boundingRectWithSize:CGSizeMake((CTXScreenWidth-24), MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    self.orderInfoHeight = attSize.height;
    
    // 更新tableView高度
    [self.tableView reloadData];
    
    NSURL *url = [NSURL URLWithString:self.model.stationPic];
    [self.imageView setImageWithURL:url placeholder:[UIImage imageNamed:@"zet-1"]];
    self.stationNameLabel.text = self.model.stationName;
    self.stationAddressLabel.text = self.model.stationAddr;
    self.orderInfoLabel.attributedText = text;
    CTXViewBorderRadius(_payLabel, 5.0, 0, [UIColor clearColor]);
}

// 移除观察者
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 115;
    } else if (indexPath.row == 1 || indexPath.row == 3 ||
               indexPath.row == 6 || indexPath.row == 8) {
        return 15;
    } else if (indexPath.row == 2) {
        return self.orderInfoHeight;
    } else if (indexPath.row == 4 ||
               indexPath.row == 5) {
        return 70;
    } else if (indexPath.row == 7) {
        return 40;
    } else {
        return 0;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 选择支付宝
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
    
    // 确认支付
    if (indexPath.row == 7) {
        [self pay];
    }
}

#pragma mark - 支付 

- (void) pay {
    NSString *desc = [NSString stringWithFormat:@"%@申请6年免检", self.model.stationName];
    
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
    controller.tag = ChannelPay_CarFreeInspect;
    controller.businessId = self.model.businessid;
    [self basePushViewController:controller];
}

@end
