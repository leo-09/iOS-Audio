//
//  CarInspectAgencyOnlinePayViewController.m
//  AcrossAnHui
//
//  Created by ztd on 2017/8/2.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectAgencyOnlinePayViewController.h"
#import "ZWCountDownView.h"
#import "PayView.h"
#import "Masonry.h"
#import "UILabel+lineSpace.h"
#import "CTX-Prefix.pch"
#import "NetURLManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "MagicPushTransition.h"
#import "CarInspectNetData.h"
#import "CarInspectRecordNetData.h"
#import "CarInspectAgencyDetailViewController.h"

static NSString *appsheme = @"comahkeliAcrossAnHui2";

@interface CarInspectAgencyOnlinePayViewController (){
    NSInteger _selectValue;
    NSInteger waitPayTime;
    ZWCountDownView * countDown;
}

@property (nonatomic, retain) CarInspectNetData *carInspectNetData;
@property (nonatomic, retain) CarInspectRecordNetData *carInspectRecordNetData;

@end

@implementation CarInspectAgencyOnlinePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"在线支付";
    _carInspectNetData = [[CarInspectNetData alloc]init];
    _carInspectNetData.delegate = self;
    _carInspectRecordNetData = [[CarInspectRecordNetData alloc] init];
    _carInspectRecordNetData.delegate = self;
    [self getOrderDetail];
    _selectValue = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    [self getOrderDetail];
    [self initUI];
    
    //self.navigationController.delegate = self;
    isBack = NO;
}

- (void) getOrderDetail {
    [_carInspectRecordNetData getOrderDetailWithToken:self.loginModel.token businessid:self.orderModel.businessid tag:@"getOrderDetailTag"];
}
#pragma 初始化界面
-(void)initUI{
    countDown = [ZWCountDownView countDown];
    countDown.frame = CGRectMake((self.view.frame.size.width-200)/2, 0, 200, 100);
    
    @weakify(self)
    
    [countDown  setTimeStopBlock:^(){
        @strongify(self)
        //倒计时结束
        CarInspectAgencyDetailViewController * controller = [[CarInspectAgencyDetailViewController alloc]init];
        controller.businessid = self.orderModel.businessid;
        [self basePushViewController:controller];
        
    }];
    
    [self.view addSubview:countDown];
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, CTXScreenWidth, 10)];
    bgView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    [self.view addSubview:bgView];
    PayView * payView = [[PayView  alloc] initWithFrame:CGRectMake(0, 100+10, self.view.bounds.size.width, 150)];
    [payView setPayWay:^(NSInteger selectValue) {
        _selectValue = selectValue;
    }];
    [self.view addSubview:payView];
    
    [self createBtnUI];
}
-(void)createBtnUI{
    UIView * bgView = [[UIView alloc] init];
    [self.view addSubview:bgView];
    if (self.view.frame.size.width == 320) {
        bgView.frame = CGRectMake(0, 250+10, CTXScreenWidth, 80+45+25);
    }else{
        bgView.frame = CGRectMake(0, 250+10, CTXScreenWidth, 80+45);
    }
    bgView.backgroundColor = [UIColor whiteColor];
    
    UILabel * noteLab = [[UILabel alloc]init];
    [bgView addSubview:noteLab];
    noteLab.font = [UIFont systemFontOfSize:13];
    noteLab.numberOfLines = 0;
    noteLab.text = @"注意:\n1、如果司机在预约时间内到达，取消订单需要扣除25元\n2、车主超过约定时间未到达，司机等候时间每满15分钟收费10元";
    CGSize size = [noteLab getLabelHeightWithLineSpace:10 WithWidth:CTXScreenWidth-25 WithNumline:0];
    noteLab.frame = CGRectMake(12.5, 15, CTXScreenWidth-25, size.height);
    noteLab.textColor = UIColorFromRGB(0xfe6e00);
    
    
    UILabel * lineLab = [[UILabel alloc]init];
    [bgView addSubview:lineLab];
    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.width.equalTo(@(CTXScreenWidth));
        make.height.equalTo(@1);
        make.top.equalTo(noteLab.mas_bottom).offset(10);
    }];
    lineLab.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
    
    UILabel * payname = [[UILabel alloc]init];
    [bgView addSubview:payname];
    payname.text = @"待支付：";
    payname.font = [UIFont systemFontOfSize:15];
    
    UILabel * payPirce = [[UILabel alloc]init];
    [bgView addSubview:payPirce];
    
    payPirce.text = [NSString stringWithFormat:@"￥%0.2f元", _orderModel.payfee];
    payPirce.font = [UIFont systemFontOfSize:15];
    payPirce.textColor = UIColorFromRGB(0xfe6e00);
    [payname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12.5);
        make.width.equalTo(@(65));
        make.height.equalTo(@15);
        make.top.equalTo(lineLab.mas_bottom).offset(13);
    }];
    [payPirce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(12.5+65));
        make.width.equalTo(@(200));
        make.height.equalTo(@15);
        make.top.equalTo(lineLab.mas_bottom).offset(13);
    }];
    
    UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:but];
    but.tag = 100;
    but.backgroundColor = UIColorFromRGB(CTXThemeColor);
    [but setTitle:@"确认支付" forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:15];
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(makeSurePayButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(12.5));
        make.width.equalTo(@(CTXScreenWidth-25));
        make.height.equalTo(@40);
        make.top.equalTo(payname.mas_bottom).offset(15);
    }];
}
//点击了确认支付按钮
-(void)makeSurePayButtonClick
{
    [self pay];
    
}

#pragma mark 推迟2秒进入到详情界面

-(void)replyTime {
    CarInspectAgencyDetailViewController * controller = [[CarInspectAgencyDetailViewController alloc]init];
    controller.businessid = self.orderModel.businessid;
    controller.isFromDBOnlinePayViewController = YES;
    [self basePushViewController:controller];
    
    //关闭计时器
    countDown.timeStamp = 0;
    [countDown removeFromSuperview];
    countDown = nil;
}

- (void)close:(id)sender {
    if (self.isFromRecord) {
        //关闭计时器
        
        countDown.timeStamp = 0;
        [countDown removeFromSuperview];
        countDown = nil;
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        isBack = YES;
        //关闭计时器
        [countDown removeFromSuperview];
        countDown = nil;
        countDown.timeStamp = 0;
        
        CarInspectAgencyDetailViewController * controller = [[CarInspectAgencyDetailViewController alloc]init];
        controller.businessid = self.orderModel.businessid;
        controller.isFromDBOnlinePayViewController = YES;
        [self basePushViewController:controller];
    }
}

- (void) pay {
    NSString *desc = [NSString stringWithFormat:@"车检代办"];
    
    if (_selectValue==2) {
        [_carInspectNetData weChatPayWithBusinessCode:self.orderModel.businessCode desc:desc tag:@"weChatPayTag"];
    } else {
        [_carInspectNetData aliPayWithBusinessCode:self.orderModel.businessCode desc:desc tag:@"aliPayTag"];
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
                UIButton * btn = (UIButton *)[self.view viewWithTag:100];
                btn.enabled=false;
                [self performSelector:@selector(replyTime) withObject:self afterDelay:2];
            }
        }];
    }
    
    if ([tag isEqualToString:@"getOrderDetailTag"]) {
        [self hideHub];
        
        NSDictionary * Dic = (NSDictionary *)result;
        waitPayTime = [Dic[@"waitPayTime"] integerValue];
        countDown.timeStamp = waitPayTime/1000;
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
        UIButton * btn = (UIButton *)[self.view viewWithTag:100];
        btn.enabled=false;
        [self performSelector:@selector(replyTime) withObject:self afterDelay:2];
    } else {
        [self showTextHubWithContent:@"支付失败"];
    }
}



#pragma mark UINavigationControllerDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    if (isBack) {
        isBack = NO;
        MagicPushTransition *transition = [[MagicPushTransition alloc] init];
        return transition;
    } else {
        return nil;
    }
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
