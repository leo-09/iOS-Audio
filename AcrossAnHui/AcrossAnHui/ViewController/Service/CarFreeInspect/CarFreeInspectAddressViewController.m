//
//  CarFreeInspectAddressViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/28.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarFreeInspectAddressViewController.h"
#import "CCarFreeInspectAddressView.h"

@interface CarFreeInspectAddressViewController ()

@property (nonatomic, retain) CCarFreeInspectAddressView *carFreeInspectAddressView;

@end

@implementation CarFreeInspectAddressViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加地址";
    
    [self.view addSubview:self.carFreeInspectAddressView];
    [self.carFreeInspectAddressView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];

    // 快递只能支持安徽省
    [self getAllcityInfoWithProvince:@"安徽"];
}

// 定位的城市信息
- (void) getAllcityInfoWithProvince:(NSString *)province {
    [DES3Util getCityListWithCompletionBlock:^(NSMutableArray *cityArray) {
        NSArray<AreaModel *> *areaModels = [AreaModel convertFromArray:cityArray];
        
        for (AreaModel *areaModel in areaModels) {
            if ([areaModel.areaName containsString:province]) {
                
                NSArray<TownModel *> *townModels = areaModel.town;
                [_carFreeInspectAddressView setTownModels:townModels model:self.model];
                
                break;
            }
        }
    }];
}

#pragma mark - getter/setter

- (CCarFreeInspectAddressView *) carFreeInspectAddressView {
    if (!_carFreeInspectAddressView) {
        _carFreeInspectAddressView = [[CCarFreeInspectAddressView alloc] init];
        
        @weakify(self)
        [_carFreeInspectAddressView setAddAddressListener:^(id result) {
            @strongify(self)
            
            self.model = (CarFreeInspectAddressModel *)result;
            NSDictionary *userInfo = @{@"model": self.model,
                                       @"fetchAddress": self.fetchAddress};
            [[NSNotificationCenter defaultCenter] postNotificationName:SelectAddressNotificationName object:nil userInfo:userInfo];
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
    return _carFreeInspectAddressView;
}

@end
