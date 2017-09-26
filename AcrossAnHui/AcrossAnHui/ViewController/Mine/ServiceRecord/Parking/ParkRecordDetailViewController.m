//
//  ParkRecordDetailViewController.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ParkRecordDetailViewController.h"
#import "ParkRecordDetailView.h"
#import "Masonry.h"
#import "ParkRecordAlertView.h"
#import "ParkCarSelectPayTableViewController.h"
#import "NetURLManager.h"
#import "RechargeViewController.h"
#import "CarInspectRecordNetData.h"

@interface ParkRecordDetailViewController ()

@property (nonatomic,retain)ParkRecordDetailView * detailView;
@property (nonatomic,retain)CarInspectRecordNetData * carinspectRecordNetData;
@property (nonatomic,retain)NSMutableArray * dataArr;
@property (nonatomic ,assign)CGFloat ubalance;

@end

@implementation ParkRecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情记录";
    _carinspectRecordNetData = [[CarInspectRecordNetData alloc]init];
    _carinspectRecordNetData.delegate = self;
    _dataArr = [NSMutableArray array];
    self.view.backgroundColor = CTXColor(244, 244, 244);
    [self initUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(update) name:ParkingPaySuccessNotificationName object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

//微信、支付支付成功后刷新数据
-(void)update{
    [self showHubWithLoadText:@"加载中..."];
    [self performSelector:@selector(replyTime) withObject:self afterDelay:2];
    

}
-(void)replyTime{
[self getData:_model.magCard carID:_model.carid isPay:@"0"];

}
-(void)initUI{
    self.automaticallyAdjustsScrollViewInsets = false;
    self.detailView = [[ParkRecordDetailView alloc]initWithFrame:CGRectMake(0, 0, CTXScreenWidth, CTXScreenHeight-64)];
    
    [self.view addSubview:self.detailView];
    
    @weakify(self)
    [self.detailView setSelectCellListener:^{
        @strongify(self)
        
        //立即支付
        if (_ubalance-_model.money>0) {
            NSString * note = [NSString stringWithFormat:@"本次停车费用总计:%0.2f元,是否确定支付", self.model.money];
            ParkRecordAlertView * Alertview =[[ParkRecordAlertView alloc]initWithFrame:CGRectMake(0, 0, CTXScreenWidth, CTXScreenHeight-64) note:note title:@"确定缴费"];
            [self.view addSubview:Alertview];
            
            [Alertview setSelectCellListener:^(BOOL selectPay) {
                
                if (selectPay==false) {
                    ParkCarSelectPayTableViewController * controller = [[ParkCarSelectPayTableViewController alloc]initWithStoryboard];
                    controller.businessCode = self.model.orderNum;
                    controller.payFee = self.model.money;
                    [self basePushViewController:controller];
                } else {
                    [self myWalletPay];
                }
                
            }];
            
            
        } else {
            NSString * note = [NSString stringWithFormat:@"目前账户余额为：%0.2f元，是否去充值", (CGFloat)self.ubalance];
            ParkRecordAlertView * Alertview =[[ParkRecordAlertView alloc]initWithFrame:CGRectMake(0, 0, CTXScreenWidth, CTXScreenHeight-64) note:note title:@"余额不足"];
            [self.view addSubview:Alertview];
            
            
            [Alertview setSelectCellListener:^(BOOL selectPay) {
                
                if (selectPay==false) {
                    ParkCarSelectPayTableViewController * controller = [[ParkCarSelectPayTableViewController alloc]initWithStoryboard];
                    controller.businessCode = self.model.orderNum;
                    controller.payFee = self.model.money;
                    [self basePushViewController:controller];
                }else{
                    //充值
                    RechargeViewController * vc =[[RechargeViewController alloc]initWithStoryboard];
                    [self basePushViewController:vc];
                }
            }];
        }
    }];
    
    if ([_model.isPay isEqualToString:@"0"]) {
        [_dataArr addObject:_model];
        [self.detailView freshData:_dataArr];
    } else {
        [self showHubWithLoadText:@"加载中..."];
        [self getData:_model.magCard carID:_model.carid isPay:@"1"];
    }
}

//获取订单
-(void)getData:(NSString *)magCard carID:(NSString *)carID isPay:(NSString *)isPay{
    
    
    [_carinspectRecordNetData queryParkingDetailRecordWithToken:self.loginModel.token carID:carID isPay:isPay tag:@"parkingDetailTag"];
}

//钱包支付
-(void)myWalletPay{
    
    [self showHubWithLoadText:@"支付中..."];
    [_carinspectRecordNetData getWalletPayWithToken:self.loginModel.token orderNum:_model.orderNum tag:@"WalletPayTag"];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [self hideHub];
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"parkingDetailTag"]) {
    
        NSDictionary * dataDic = (NSDictionary *)result;
        _ubalance = [dataDic[@"ubalance"] floatValue];
        NSDictionary * dictt = dataDic[@"parkingDetail"];
        NSMutableArray * arr = [NSMutableArray array];
        _model = [ParkRecordModel convertFromDict:dictt];
        [arr addObject:_model];
        self.dataArr = arr;
        [self.detailView freshData:self.dataArr];
    }
    
    if ([tag isEqualToString:@"WalletPayTag"]) {
        [self showTextHubWithContent:tint];
        if (_dataArr.count>0) {
            [_dataArr removeAllObjects];
        }
        _model.isPay = 0;
        [_dataArr addObject:_model];
        [self.detailView freshData:_dataArr];
        if (selectCellListener) {
        selectCellListener();
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [self hideHub];
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
}

-(void)setSelectCellListener:(void (^)())listener{
    selectCellListener = listener;
}

@end
