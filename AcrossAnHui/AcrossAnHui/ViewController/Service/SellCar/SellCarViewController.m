//
//  CarValuationViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "SellCarViewController.h"
#import "SubmitRecordViewController.h"
#import "CarInfoViewController.h"

@interface SellCarViewController ()

@end

@implementation SellCarViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我要卖车";
    // rightBarButtonItem
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交记录" style:UIBarButtonItemStyleDone target:self action:@selector(submitRecord)];
    [rightBarButtonItem setTintColor:[UIColor whiteColor]];
    NSDictionary *dict = @{ NSFontAttributeName: [UIFont systemFontOfSize:CTXTextFont] };
    [rightBarButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self.view addSubview:self.sellCarView];
    [self.sellCarView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void) submitRecord {
    SubmitRecordViewController *controller = [[SubmitRecordViewController alloc] init];
    [self basePushViewController:controller];
}

#pragma mark - getter/setter

- (CSellCarView *) sellCarView {
    if (!_sellCarView) {
        _sellCarView = [[CSellCarView alloc] init];
        
        @weakify(self)
        [_sellCarView setSellCarListener:^(){
            @strongify(self)
            CarInfoViewController *controller = [[CarInfoViewController alloc] initWithStoryboard];
            [self basePushViewController:controller];
        }];
    }
    
    return _sellCarView;
}

@end
