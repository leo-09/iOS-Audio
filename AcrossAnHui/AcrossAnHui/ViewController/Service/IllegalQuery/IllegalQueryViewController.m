//
//  IllegalQueryViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "IllegalQueryViewController.h"
#import "IllegalInfoViewController.h"
#import "IllegalListViewController.h"
#import "BindCarViewController.h"
#import "CIllegalQueryView.h"
#import "HomeNetData.h"

@interface IllegalQueryViewController ()

@property (nonatomic, retain) HomeNetData *homeNetData;
@property (nonatomic, retain) CIllegalQueryView *illegalQueryView;

@end

@implementation IllegalQueryViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"违章查询";
    
    [self.view addSubview:self.illegalQueryView];
    [self.illegalQueryView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    _homeNetData = [[HomeNetData alloc] init];
    _homeNetData.delegate = self;
    
    // 违章详情页的数据，可以优先取缓存
    [self queryCarIllegalInfoWithPriorUseCache:YES];
    
    // 编辑此车后，绑定／删除该车，需要接受通知，重新请求数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryCarIllegalInfo:) name:BindOrDeleteCarNotificationName object:nil];
}

- (void) queryCarIllegalInfo:(NSNotification *)noti {
    if (noti.userInfo) {
        // userInfo有值，则表示编辑车辆
        NSString *note = noti.userInfo[@"note"];
        NSString *name = noti.userInfo[@"name"];
        NSString *carType = noti.userInfo[@"carType"];
        
        [self.illegalQueryView setEditCarNote:note name:name carType:carType];
    } else {
        // 删除车辆，则需要重新获取数据
        [self queryCarIllegalInfoWithPriorUseCache:NO];
    }
}

- (void) queryCarIllegalInfoWithPriorUseCache:(BOOL) isCache {
    [self showHub];
    [self.homeNetData queryCarIllegalInfoWithToken:self.loginModel.token userId:self.loginModel.loginID isPriorUseCache:isCache tag:@"queryCarIllegalInfoTag"];
}

// 添加车辆
- (void) addCar {
    BindCarViewController *controller = [[BindCarViewController alloc] initWithStoryboard];
    controller.naviTitle = @"绑定车辆";
    [self basePushViewController:controller];
}

// 移除观察者
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"queryCarIllegalInfoTag"]) {
        NSArray<CarIllegalInfoModel *> *carIllegalInfoModels = [CarIllegalInfoModel convertFromArray:result];
        
        // 如果点击某辆车的违章信息过来，则默认滑动到该辆车的位置
        int selectedIndex = 0;
        if (self.currentCarModel) {
            for (int i = 0; i < carIllegalInfoModels.count; i++) {
                CarIllegalInfoModel *model = carIllegalInfoModels[i];
                // 找出该车的位置
                if ([model.jdcjbxx.frameNumber isEqualToString:self.currentCarModel.jdcjbxx.frameNumber]) {
                    selectedIndex = i;
                    break;
                }
            }
        }
        
        // 显示内容
        [_illegalQueryView setDataSource:carIllegalInfoModels selectedIndex:selectedIndex];
        
        // 绑定的车辆少于5辆，则显示“添加车辆”按钮,否则不显示
        if (carIllegalInfoModels.count < 5) {
            if (!self.navigationItem.rightBarButtonItem) {
                UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加车辆" style:UIBarButtonItemStyleDone target:self action:@selector(addCar)];
                [rightBarButtonItem setTintColor:[UIColor whiteColor]];
                NSDictionary *dict = @{ NSFontAttributeName: [UIFont systemFontOfSize:CTXTextFont] };
                [rightBarButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
                self.navigationItem.rightBarButtonItem = rightBarButtonItem;
            }
        } else {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"queryCarIllegalInfoTag"]) {
        [_illegalQueryView setDataSource:nil selectedIndex:0];
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark - getter/setter

- (CIllegalQueryView *) illegalQueryView {
    if (!_illegalQueryView) {
        _illegalQueryView = [[CIllegalQueryView alloc] init];
        
        @weakify(self)
        [_illegalQueryView setSelectCarIllegalInfoCellListener:^(id result) {
            @strongify(self)
            ViolationInfoModel *violationInfoModel = (ViolationInfoModel *) result;
            
            IllegalInfoViewController *controller = [[IllegalInfoViewController alloc] init];
            controller.violationInfoModel = violationInfoModel;
            [self basePushViewController:controller];
        }];
        
        [_illegalQueryView setRefreshCarIllegalInfoDataListener:^(BOOL isRequestFailure) {
            @strongify(self)
            
            [self queryCarIllegalInfoWithPriorUseCache:NO];
        }];
        
        [_illegalQueryView setBindCarListener:^ {
            @strongify(self)
            
            [self addCar];
        }];
        
        [_illegalQueryView setEditCarListener:^(id result) {
            @strongify(self)
            
            BindCarViewController *controller = [[BindCarViewController alloc] initWithStoryboard];
            controller.naviTitle = @"编辑车辆";
            controller.carModel = (BoundCarModel *)result;
            [self basePushViewController:controller];
        }];
        
        [_illegalQueryView setShowIllegalListListener:^(id result) {
            @strongify(self)
            CarIllegalInfoModel *model = (CarIllegalInfoModel *) result;
            
            IllegalListViewController *controller = [[IllegalListViewController alloc] init];
            controller.model = model;
            [self basePushViewController:controller];
        }];
    }
    
    return _illegalQueryView;
}

@end
