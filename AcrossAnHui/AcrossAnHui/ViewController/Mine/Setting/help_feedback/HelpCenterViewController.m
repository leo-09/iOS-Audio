//
//  HelpCenterViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/9.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "HelpCenterViewController.h"
#import "MineNetData.h"
#import "CHelpCenterView.h"
#import "HelpCenterModel.h"

@interface HelpCenterViewController ()

@property (nonatomic, retain) CHelpCenterView *helpCenterView;
@property (nonatomic, retain) MineNetData *mineNetData;

@end

@implementation HelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"帮助中心";
    
    [self.view addSubview:self.helpCenterView];
    [self.helpCenterView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.left.equalTo(@0);
        make.bottom.equalTo(@(-64));
    }];
    
    self.mineNetData = [[MineNetData alloc] init];
    self.mineNetData.delegate = self;
    
    [self showHub];
    [self.mineNetData getHelpListWithTag:@"getHelpListTag"];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"getHelpListTag"]) {
        NSArray *helps = [HelpCenterModel convertFromArray:(NSArray *)result];
        [self.helpCenterView refreshDataSource:helps];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self hideHub];
    [self showTextHubWithContent:tint];
    
    [self.helpCenterView refreshDataSource:nil];
}

#pragma mark - getter/setter

- (CHelpCenterView *) helpCenterView {
    if (!_helpCenterView) {
        _helpCenterView = [[CHelpCenterView alloc] init];
        
        @weakify(self)
        [_helpCenterView setRefreshHelpInfoDataListener:^(BOOL isRequestFailure) {
            @strongify(self)
            
            [self showHub];
            [self.mineNetData getHelpListWithTag:@"getHelpListTag"];
        }];
    }
    
    return _helpCenterView;
}

#pragma mark - CTXSegmentedPageViewControllerDelegate

- (NSString *)viewControllerTitle {
    return self.viewTitle ? self.viewTitle : self.title;
}

@end
