//
//  IllegalListViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "IllegalListViewController.h"
#import "IllegalInfoViewController.h"
#import "CIllegalListView.h"

@interface IllegalListViewController ()

@property (nonatomic, retain) CIllegalListView *illegalListView;

@end

@implementation IllegalListViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"历史违章";
    
    [self.view addSubview:self.illegalListView];
    [self.illegalListView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    // 违章信息
    self.illegalListView.model = self.model;
}

#pragma mark - getter/setter

- (CIllegalListView *) illegalListView {
    if (!_illegalListView) {
        _illegalListView = [[CIllegalListView alloc] init];
        
        @weakify(self)
        [_illegalListView setSelectCarIllegalInfoCellListener:^(id result) {
            @strongify(self)
            ViolationInfoModel *violationInfoModel = (ViolationInfoModel *) result;
            
            IllegalInfoViewController *controller = [[IllegalInfoViewController alloc] init];
            controller.violationInfoModel = violationInfoModel;
            [self basePushViewController:controller];
        }];
    }
    
    return _illegalListView;
}

@end
