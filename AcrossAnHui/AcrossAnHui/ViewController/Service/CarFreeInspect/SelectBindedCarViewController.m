//
//  SelectBindedCarViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "SelectBindedCarViewController.h"
#import "SubmitCarInfoViewController.h"
#import "CarFreeInspectViewController.h"
#import "CSelectBindedCarView.h"
#import "DialogView.h"
#import "CarInspectModel.h"

@interface SelectBindedCarViewController () {
    CarIllegalInfoModel *selectedModel;
}

@property (nonatomic, retain) CSelectBindedCarView *selectBindedCarView;

@end

@implementation SelectBindedCarViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择车辆";
    [self showHub];
    
    [self.view addSubview:self.selectBindedCarView];
    [self.selectBindedCarView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    _carInspectNetData = [[CarInspectNetData alloc] init];
    _carInspectNetData.delegate = self;
    
    _homeNetData = [[HomeNetData alloc] init];
    _homeNetData.delegate = self;
    
    // 优先取缓存
    [_homeNetData queryCarIllegalInfoWithToken:self.loginModel.token userId:self.loginModel.loginID isPriorUseCache:YES tag:@"queryCarIllegalInfoTag"];
    
    // 添加／删除车辆
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryCarIllegalInfo) name:BindOrDeleteCarNotificationName object:nil];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"queryCarIllegalInfoTag"]) {
        NSMutableArray *carIllegalArray = [CarIllegalInfoModel convertFromArray:result];
        self.selectBindedCarView.carIllegals = carIllegalArray;
    }
    
    // 车牌号车架号年检信息查询
    if ([tag isEqualToString:@"userApiNJWZCXTag"]) {
        CarInspectModel *model = [CarInspectModel convertFromDict:(NSDictionary *)result];
        
        if (model.status == CarInspectStatus_noIllegal ||       // 没有未处理的违章信息
            model.status == CarInspectStatus_network) {         // 网络连接失败，让其继续，可以重试
            
            SubmitCarInfoViewController *controller = [[SubmitCarInfoViewController alloc] initWithStoryboard];
            controller.fromViewController = self.fromViewController;
            controller.model = selectedModel.jdcjbxx;
            [self basePushViewController:controller];
        } else {
            [self showTextHubWithContent:model.info];
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"queryCarIllegalInfoTag"]) {
        [self showTextHubWithContent:tint];
        self.selectBindedCarView.carIllegals = nil;
    }
    
    // 车牌号车架号年检信息查询
    if ([tag isEqualToString:@"userApiNJWZCXTag"]) {
        // 网络连接失败，让其继续，可以重试
        SubmitCarInfoViewController *controller = [[SubmitCarInfoViewController alloc] initWithStoryboard];
        controller.fromViewController = self.fromViewController;
        controller.model = selectedModel.jdcjbxx;
        [self basePushViewController:controller];
    }
}

#pragma mark - getter/setter

- (CSelectBindedCarView *) selectBindedCarView {
    if (!_selectBindedCarView) {
        _selectBindedCarView = [[CSelectBindedCarView alloc] init];
        
        @weakify(self)
        [_selectBindedCarView setSubmitCarInfoListener:^ {
            @strongify(self)
            SubmitCarInfoViewController *controller = [[SubmitCarInfoViewController alloc] initWithStoryboard];
            controller.fromViewController = self.fromViewController;
            [self basePushViewController:controller];
        }];
        
        [_selectBindedCarView setSelectCarCellListener:^(id result) {
            @strongify(self)
            
            selectedModel = (CarIllegalInfoModel *) result;
            [self judgeSelectedCar];
        }];
    }
    
    return _selectBindedCarView;
}

#pragma mark - 选择车辆的条件判断

- (void) judgeSelectedCar {
    if ([selectedModel.jdcjbxx.success isEqualToString:@"1"]) {
        if ([selectedModel.jdcwfxxtj.jdcwfxxSum isEqualToString:@"0"]) {// 机动车未处理违法记录总条数 是0
            // 办理六年免检 且 不是小型汽车，则不符合
            if ([self.fromViewController isEqualToString:NSStringFromClass([CarFreeInspectViewController class])] &&
                ![selectedModel.jdcjbxx.plateType isEqualToString:Compact_Car_PlateType]) {
                [self showTextHubWithContent:@"您的车辆不属于非营运小型车辆，不符合申请6年免检"];
            } else {
                // 逻辑判断，跟SubmitCarInfoViewController的判断一样
                [self showHubWithLoadText:@"验证中..."];
                [self.carInspectNetData userApiNJWZCXWithPlateNumber:selectedModel.jdcjbxx.plateNumber
                                                         frameNumber:selectedModel.jdcjbxx.frameNumber
                                                             carType:selectedModel.jdcjbxx.plateType
                                                                 tag:@"userApiNJWZCXTag"];
            }
        } else {
            [self showTextHubWithContent:@"您还有未处理的违章信息"];
        }
    } else {
        [self showTextHubWithContent:@"系统维护中,暂时不能办理该车的业务"];
    }
}

- (void) queryCarIllegalInfo {
    [self showHub];
    [_homeNetData queryCarIllegalInfoWithToken:self.loginModel.token userId:self.loginModel.loginID isPriorUseCache:NO tag:@"queryCarIllegalInfoTag"];
}

@end
