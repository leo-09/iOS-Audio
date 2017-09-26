//
//  ServiceViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ServiceViewController.h"
#import "ServiceNetData.h"
#import "AdvertisementModel.h"
#import "ServeLocalData.h"
#import "CTXWKWebViewController.h"
#import "ServeTool.h"
#import "LoginInfoLocalData.h"

@interface ServiceViewController ()

@property (nonatomic, retain) ServiceNetData *serviceNetData;

@end

@implementation ServiceViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.serviceView];
    
    // 获取轮播图的地址
    self.serviceNetData = [[ServiceNetData alloc] init];
    self.serviceNetData.delegate = self;
    [self getAdvList];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.parentViewController.title = @"服务";
    self.parentViewController.navigationItem.leftBarButtonItem = nil;
    self.parentViewController.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"getAdvListTag"]) {
        self.advModels = [AdvertisementModel convertFromArray:(NSArray *) result];
        NSMutableArray *imagePaths = [[NSMutableArray alloc] init];
        for (AdvertisementModel *model in self.advModels) {
            [imagePaths addObject:model.img];
        }
        
        // 滚动图 赋值
        [_serviceView setImagePaths:imagePaths];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    
    // 查询失败，暂时不做处理，显示一张默认图片
}

#pragma mark - getter/setter

- (CServiceView *) serviceView {
    if (!_serviceView) {    
        float height = CTXScreenHeight - CTXTabBarHeight - CTXBarHeight - CTXNavigationBarHeight;
        CGRect frame = CGRectMake(0, 0, CTXScreenWidth, height);
        _serviceView = [[CServiceView alloc] initWithFrame:frame];
        
        // 获取所有服务的集合
        _serveModels = [[ServeLocalData sharedInstance] readLocalServeCollection];
        [_serviceView setServeModels:_serveModels];
        
        @weakify(self)
        [_serviceView setSelectCellListener:^(int section, int index){
            @strongify(self)
            ServeSuperModel *superModel = self.serveModels[section];
            ServeModel *model = superModel.serveArray[index];
            
            [ServeTool pushServeWithModel:model currentViewController:self block:^{
                self.serviceView.selectCellListener(section, index);
            }];
        }];
        [_serviceView setClickADVListener:^(int index) {
            @strongify(self)
            if (index < self.advModels.count) {
                AdvertisementModel *adv = self.advModels[index];
                CTXWKWebViewController *controller = [[CTXWKWebViewController alloc] init];
                controller.name = adv.name;
                controller.url = [adv getActualURLWithToken:self.loginModel.token userID:self.loginModel.loginID];
                controller.desc = adv.desc;
                [self basePushViewController:controller];
            }
        }];
        [_serviceView setRefreshAdvDataListener:^(BOOL isRequestFailure){
            @strongify(self)
            [self getAdvList];
        }];
    }
    
    return _serviceView;
}

- (void) getAdvList {
    [self.serviceNetData getAdvListById:@"22" tag:@"getAdvListTag"];
}

@end
