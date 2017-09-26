//
//  HomeViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "HomeViewController.h"
#import "MessageCenterViewController.h"
#import "AdvertisementModel.h"
#import "NewsInfoModel.h"
#import "CarIllegalInfoModel.h"
#import "DES3Util.h"
#import "CTXWKWebViewController.h"
#import "NewsInfoViewController.h"
#import "EditHomeServeViewController.h"
#import "IllegalQueryViewController.h"
#import "BindCarViewController.h"
#import "ServeLocalData.h"
#import "ServeModel.h"
#import "VersionUpdateView.h"
#import "GasStationViewController.h"
#import "ServeTool.h"
#import "VersionTool.h"
#import "HomeLocalData.h"
#import "AdvertisementLocalData.h"
#import "KLCDTextHelper.h"

@implementation HomeViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.homeView];
    
    // 默认显示 ‘添加车辆’
    self.homeView.carIllegals = @[ [self addCarButtonInfo] ];
    
    _homeNetData = [[HomeNetData alloc] init];
    _homeNetData.delegate = self;
    
    _mineNetData = [[MineNetData alloc] init];
    _mineNetData.delegate = self;
    
    // 更新广告页数据
    _serviceNetData = [[ServiceNetData alloc] init];
    _serviceNetData.delegate = self;
    
    [self showHub];
    
    // 请求数据
    [self getAdvList];
    [self getNewsList];
    [self getCarInfo];
    [self readServeModels];
    
    // 绑定/删除车辆, 更新车辆信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiUpdateCarInfo) name:BindOrDeleteCarNotificationName object:nil];
    // 登录或者退出帐号，更新车辆信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiUpdateCarInfo) name:LoginNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiUpdateCarInfo) name:LogoffNotificationName object:nil];
    // 更新 定制服务
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readServeModels) name:EditHomeServeNotificationName object:nil];
    // 推送消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewMessageCount) name:PushMessageNotificationName object:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 获取最新消息数量
    [self getNewMessageCount];
    
    // 获取APP在AppStore中的版本号
    [self getAppStoreVersion];
    
    // 处理navigationBar
    self.parentViewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSDictionary * attributes = @{ NSForegroundColorAttributeName:[UIColor whiteColor] };
    self.parentViewController.navigationController.navigationBar.titleTextAttributes = attributes;
    self.parentViewController.navigationController.navigationBar.barTintColor = UIColorFromRGB(CTXThemeColor);
    
    self.parentViewController.title = @"畅行安徽";
    
    // rightBarButtonItem
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarButtonItem];
    self.parentViewController.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    // 定位
    if (![AppDelegate sharedDelegate].aMapLocationModel) {
        [self startUpdatingLocationWithBlock:^{
            NSString *city = [[HomeLocalData sharedInstance] getAMapLocationModel].city;
            [self setNavLeftBtnTitle:city];
        }];
    }
    
    // leftBarButtonItem
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navLeftBtn];
    [leftBarButtonItem setTintColor:[UIColor whiteColor]];
    self.parentViewController.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

// 移除观察者
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - private method

- (void) messageCenter {
    if (self.loginModel.token) {
        MessageCenterViewController *controller = [[MessageCenterViewController alloc] initWithStoryboard];
        [self basePushViewController:controller];
    } else {
        [self loginFirstWithBlock:^(id newToken) {
            [self messageCenter];
        }];
    }
}

#pragma mark - getter/setter

- (UIButton *) navLeftBtn {
    if (!_navLeftBtn) {
        CGRect frame = CGRectMake(0, 0, 90, 44);
        _navLeftBtn = [[UIButton alloc] initWithFrame:frame];
        [_navLeftBtn setImage:[UIImage imageNamed:@"current_location"] forState:UIControlStateNormal];
        _navLeftBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        NSString *city = [[HomeLocalData sharedInstance] getAMapLocationModel].city;
        [self setNavLeftBtnTitle:city];
    }
    
    return _navLeftBtn;
}

- (void) setNavLeftBtnTitle:(NSString *)title {
    NSString *city = title ? title : defaultCity;
    [_navLeftBtn setTitle:city forState:UIControlStateNormal];
    
    // UIButton的titleEdgeInsets和imageEdgeInsets属性 设置
    _navLeftBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _navLeftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // imageView在左 titleLabel在右
    [_navLeftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_navLeftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
}

- (HomeRightBarButtonItem *) rightBarButtonItem {
    if (!_rightBarButtonItem) {
        CGRect frame = CGRectMake(0, 0, 35, 40);
        _rightBarButtonItem = [[HomeRightBarButtonItem alloc] initWithFrame:frame];
        
        @weakify(self)
        [_rightBarButtonItem setClickListener:^ {
            @strongify(self)
            [self messageCenter];
        }];
    }
    
    return _rightBarButtonItem;
}

#pragma mark - 网络请求

// 获取最新消息数量
- (void) getNewMessageCount {
    if (self.loginModel.token) {
        [_mineNetData getMsgCountWithToken:self.loginModel.token tag:@"getMsgCountTag"];
    }
}

- (void) notiUpdateCarInfo {
    if (self.loginModel.token) {
        [self showHub];
    }
    
    [self getCarInfo];
}

// 车辆信息
- (void) getCarInfo {
    if (self.loginModel.token) {
        [_homeNetData queryCarIllegalInfoWithToken:self.loginModel.token userId:self.loginModel.loginID isPriorUseCache:YES tag:@"queryCarIllegalInfoTag"];
    } else {
        self.homeView.carIllegals = @[ [self addCarButtonInfo] ];
    }
}

// 轮播图
- (void) getAdvList {
    [_serviceNetData getAdvListById:@"21" tag:@"getAdvListTag"];
    
    [_serviceNetData getAdvertisementWithTag:@"getGuideAdv"];
}

// 新闻资讯
- (void) getNewsList {
    [_homeNetData getModularNewsWithTag:@"getModularNewsTag"];
}

- (void) getAppStoreVersion {
    if (!isGetAppStoreVersion) {
        isGetAppStoreVersion = YES;
        [_homeNetData getAppStoreVersionWithTag:@"getSppStoreVersionTag"];
    }
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"queryCarIllegalInfoTag"]) {
        [self hideHub];
        
        NSMutableArray *carIllegalArray = [CarIllegalInfoModel convertFromArray:result];
        
        if (carIllegalArray.count > 0) {
            [AppDelegate sharedDelegate].isBindCar = YES;// 有违章信息则肯定绑定车辆了
        } else {
            [AppDelegate sharedDelegate].isBindCar = NO;
        }
        
        // 最多只能绑定5辆车
        if (carIllegalArray.count < 5) {
            [carIllegalArray addObject:[self addCarButtonInfo]];
        }
        
        self.homeView.carIllegals = carIllegalArray;
    } else if ([tag isEqualToString:@"getAdvListTag"]) {
        [self hideHub];
        
        [self.homeView endRefreshing];
        NSArray *advArray = [AdvertisementModel convertFromArray:result];
        self.homeView.advertisements = advArray;
    } else if ([tag isEqualToString:@"getModularNewsTag"]) {
        NSArray *newsInfos = [NewsInfoModel convertFromArray:result];
        self.homeView.newsInfos = newsInfos;
    } else if ([tag isEqualToString:@"getSppStoreVersionTag"]) {
        // 处理结果
        NSArray *array = result[@"results"];
        NSDictionary *dict = [array lastObject];
        NSString *version = dict[@"version"];
        NSString *content = dict[@"releaseNotes"];
        
        // 比较版本
        if (![[VersionTool sharedInstance] isLastVersionWithNetVersion:version]) {
            VersionUpdateView *updateView = [[VersionUpdateView alloc] init];
            [updateView setContent:content];
            [updateView setUpdateVersionListener:^{
                NSURL *stpneUrl = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1052223055?mt=8"];
                [[UIApplication sharedApplication] openURL:stpneUrl];
            }];
            [updateView showView];
        }
    } else if ([tag isEqualToString:@"getMsgCountTag"]) {
        NSDictionary *dict = (NSDictionary *)result;
        int total = [dict[@"total"] intValue];
        
        [self.rightBarButtonItem setMsgCount:total];
    } else if ([tag isEqualToString:@"getGuideAdv"]) {// 更新广告页数据
        NSArray *dataArray = (NSArray *)result;
        if (dataArray && (dataArray.count > 0)) {
            NSArray *advs = [AdvertisementModel convertFromArray:dataArray];
            AdvertisementModel *advModel = advs[0];
            // 保存到本地
            [[AdvertisementLocalData sharedInstance] saveAdvertisementModel:advModel];
        } else {
            [[AdvertisementLocalData sharedInstance] removeAdvertisementModel];
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"queryCarIllegalInfoTag"]) {
        self.homeView.carIllegals = @[ [self addCarButtonInfo] ];
        [AppDelegate sharedDelegate].isBindCar = NO;// 查询不到违章信息，则没有车辆
    } else if ([tag isEqualToString:@"getAdvListTag"]) {
        [self.homeView endRefreshing];
        // 查询失败，暂时不做处理，显示一张默认图片
    } else if ([tag isEqualToString:@"getModularNewsTag"]) {
        // 查询失败，暂时不做处理，默认不显示
    }
}

- (CHomeView *) homeView {
    if (!_homeView) {
        float height = CTXScreenHeight - CTXTabBarHeight - CTXBarHeight - CTXNavigationBarHeight;
        CGRect frame = CGRectMake(0, 0, CTXScreenWidth, height);
        _homeView = [[CHomeView alloc] initWithFrame:frame];
        @weakify(self)
        
        // 下拉刷新
        [_homeView setRefreshHomeDataListener:^(BOOL isRequestFailure) {
            @strongify(self)
            
            // 获取最新消息数量
            [self getNewMessageCount];
            
            // 今日头条数据不正确, 则需要重新请求数据
            if (!self.homeView.isNewsInfoModelCorrect) {
                [self getNewsList];
            }
            // 重新请求广告数据
            [self getAdvList];
            // 每次更新车辆违章信息
            [self getCarInfo];
        }];
        // 轮播图
        [_homeView setClickADVListener:^(AdvertisementModel *model) {
            @strongify(self)
            CTXWKWebViewController *controller = [[CTXWKWebViewController alloc] init];
            controller.name = model.name;
            controller.url = [model getActualURLWithToken:self.loginModel.token userID:self.loginModel.loginID];
            controller.desc = model.desc;
            [self basePushViewController:controller];
        }];
        [_homeView setSelectCarListener:^(id result) {
            @strongify(self)
            CarIllegalInfoModel *model = (CarIllegalInfoModel *) result;
            // 添加绑定车辆 或者 查看违章信息
            if (!model.jdcjbxx.carID) {
                // 先登录
                if (!self.loginModel.token) {
                    [self loginFirstWithBlock:nil];
                } else {
                    BindCarViewController *controller = [[BindCarViewController alloc] initWithStoryboard];
                    controller.naviTitle = @"绑定车辆";
                    [self basePushViewController:controller];
                }
            } else {
                IllegalQueryViewController *controller = [[IllegalQueryViewController alloc] init];
                controller.currentCarModel = model;
                [self basePushViewController:controller];
            }
        }];
        // 服务
        [_homeView setSelectServeListener:^(id resullt) {
            @strongify(self)
            ServeModel *model = (ServeModel *) resullt;
            
            [ServeTool pushServeWithModel:model currentViewController:self block:^{
                self.homeView.selectServeListener(resullt);
            }];
        }];
        // 查看更多
        [_homeView setMoreNewsInfoClickListener:^{
            @strongify(self)
            NewsInfoViewController *controller = [[NewsInfoViewController alloc] init];
            [self basePushViewController:controller];
        }];
        // 新闻
        [_homeView setSelectNewsInfoCellListener:^(NewsInfoModel *model) {
            @strongify(self)
            CTXWKWebViewController *controller = [[CTXWKWebViewController alloc] init];
            controller.name = model.name;
            controller.url = model.appNewsUrl;
            controller.desc = model.title;
            [self basePushViewController:controller];
        }];
    }
    
    return _homeView;
}

/**
 读取所有的选中的服务
 */
- (void) readServeModels {
    // 获取选中的服务
    ServeSuperModel *serveSuperModel = [[ServeLocalData sharedInstance] readSelectedServe];
    
    if (serveSuperModel.serveArray.count < 8) {// 最多只有7个服务
        // 添加默认的ServeModel
        ServeModel *model = [[ServeModel alloc] init];
        model.name = @"编辑首页";
        model.image = @"bianji";
        [serveSuperModel.serveArray addObject:model];
    }
    
    _homeView.serveModels = serveSuperModel.serveArray;
}

- (CarIllegalInfoModel *) addCarButtonInfo {
    BoundCarModel *carInfoModel = [[BoundCarModel alloc] init];
    carInfoModel.carID = nil;
    
    CarIllegalInfoModel *model = [[CarIllegalInfoModel alloc] init];
    model.jdcjbxx = carInfoModel;
    
    return model;
}

@end
