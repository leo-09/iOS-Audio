//
//  IllegalInfoViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/14.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "IllegalInfoViewController.h"
#import "CIllegalInfoView.h"
#import "GasStationViewController.h"

@interface IllegalInfoViewController ()

@property (nonatomic, retain) CIllegalInfoView *illegalInfoView;

@end

@implementation IllegalInfoViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"违章详情";
    
    [self.view addSubview:self.illegalInfoView];
    [self.illegalInfoView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    self.illegalInfoView.violationInfoModel = self.violationInfoModel;
}

#pragma mark - getter/setter

- (CIllegalInfoView *) illegalInfoView {
    if (!_illegalInfoView) {
        _illegalInfoView = [[CIllegalInfoView alloc] init];
        
        @weakify(self)
        [_illegalInfoView setShowIllegalDisposalSiteListener:^ {
            @strongify(self)
            
            // 通知NearbyViewController 显示加油站
            GasStationViewController *controller = [[GasStationViewController alloc] init];
            controller.isShowIllegalDisposalSite = YES;
            controller.titleName = @"附近违章处理点";
            [self basePushViewController:controller];
        }];
    }
    
    return _illegalInfoView;
}

@end
