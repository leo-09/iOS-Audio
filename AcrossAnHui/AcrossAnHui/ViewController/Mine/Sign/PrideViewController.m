//
//  PrideViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "PrideViewController.h"
#import "CPrideView.h"
#import "MineNetData.h"
#import "PrideModel.h"
#import "PrideInfoViewController.h"
#import "PrideGainerInfoView.h"

@interface PrideViewController ()

@property (nonatomic, retain) CPrideView *prideView;
@property (nonatomic, retain) MineNetData *mineNetData;

@end

@implementation PrideViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.prideView];
    [self.prideView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.left.equalTo(@0);
        make.bottom.equalTo(@(-64));
    }];
    
    [self showHub];
    
    _mineNetData = [[MineNetData alloc] init];
    _mineNetData.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getRewardList];
}

- (void) getRewardList {
    NSString *state = @"1";
    if ([self.viewTitle isEqualToString:@"未领取"]) {
        state = @"1";
    } else if ([self.viewTitle isEqualToString:@"已领取"]) {
        state = @"2";
    } else {
        state = @"3";
    }
    
    [_mineNetData getRewardListWithToken:self.loginModel.token
                                  userId:self.loginModel.loginID
                                   state:state
                                     tag:@"getRewardListTag"];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"getRewardListTag"]) {
        NSArray *prides = [PrideModel convertFromArray:(NSArray *)result];
        [_prideView setDataSource:prides viewTitle:self.viewTitle];
    }
    
    if ([tag isEqualToString:@"receivePrizesTag"]) {
        [self showTextHubWithContent:(result[@"msg"] ? result[@"msg"] : @"领取成功")];
        [self getRewardList];// 领取成功后，刷新界面
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"getRewardListTag"]) {
        [_prideView setDataSource:nil viewTitle:self.viewTitle];
    }
    
    if ([tag isEqualToString:@"receivePrizesTag"]) {
        [self showTextHubWithContent:tint];
    }
}

#pragma mark - getter/setter

- (CPrideView *)prideView {
    if (!_prideView) {
        _prideView = [[CPrideView alloc] init];
        
        @weakify(self)
        [_prideView setSelectCellModelListener:^(id result) {
            @strongify(self)
            PrideModel *model = (PrideModel *) result;
            
            if ([self.viewTitle isEqualToString:@"未领取"]) {
                // 领取奖品
                [self showPrideGainerInfoViewWithPrideModel:model];
            } else if ([self.viewTitle isEqualToString:@"已领取"]) {
                // 奖品详情
                PrideInfoViewController *controller = [[PrideInfoViewController alloc] initWithStoryboard];
                controller.model = model;
                [self basePushViewController:controller];
            }
        }];
        
        [_prideView setRefreshPrideListener:^(BOOL isRequestFailure) {
            @strongify(self)
            [self getRewardList];
        }];
    }
    
    return _prideView;
}

#pragma mark - CTXSegmentedPageViewControllerDelegate

- (NSString *)viewControllerTitle {
    return self.viewTitle ? self.viewTitle : self.title;
}

// 填写领取信息
- (void) showPrideGainerInfoViewWithPrideModel:(PrideModel *)model {
    PrideGainerInfoView *gainerInfoView = [[PrideGainerInfoView alloc] init];
    [gainerInfoView showWithName:self.loginModel.realName phone:self.loginModel.phone];
    
    [gainerInfoView setGainPrideListener:^(NSString *name, NSString *phone) {
        [self showHubWithLoadText:@"领取中..."];
        
        [self.mineNetData receivePrizesWithToken:self.loginModel.token prideID:model.prideID
                                            name:name phone:phone
                                       goodsName:model.goodsName tag:@"receivePrizesTag"];
        
    }];
}

@end
