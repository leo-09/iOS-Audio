//
//  SelectCarTypeViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "SelectCarTypeViewController.h"
#import "MineNetData.h"
#import "CarTypeModel.h"
#import "ChineseString.h"
#import "CSelectCarTypeView.h"

@interface SelectCarTypeViewController ()

@property (nonatomic, retain) MineNetData *mineNetData;
@property (nonatomic, retain) CSelectCarTypeView *selectCarTypeView;

@end

@implementation SelectCarTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"车型选择";
    
    [self.view addSubview:self.selectCarTypeView];
    [self.selectCarTypeView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.mineNetData = [[MineNetData alloc] init];
    self.mineNetData.delegate = self;
    
    [self showHub];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.mineNetData getCarTypeWithTag:@"getCarTypeTag"];
}

- (void) close:(id)sender {
    if ([self.selectCarTypeView canPopToNavigationController]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"getCarTypeTag"]) {
        [self hideHub];
        
        // 车型结果
        NSArray<CarTypeModel *> *carTypes = [CarTypeModel convertFromArray:(NSArray *)result];
        
        // 取出名称
        NSMutableArray *nameArray = [[NSMutableArray alloc] init];
        for (CarTypeModel *model in carTypes) {
            [nameArray addObject:model.cb.name];
        }
        
        NSMutableArray *titleArray = [ChineseString IndexArray:nameArray];// 返回tableview右方indexArray
        NSMutableArray *contentArray = [ChineseString LetterSortArray:nameArray];
        
        _selectCarTypeView.carTypes = carTypes;
        [_selectCarTypeView addTitleArray:titleArray contentArray:contentArray];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    
    if ([tag isEqualToString:@"getCarTypeTag"]) {
        [self hideHub];
        
        [_selectCarTypeView addTitleArray:nil contentArray:nil];
    }
}

#pragma mark - getter/setter

- (CSelectCarTypeView *)selectCarTypeView {
    if (!_selectCarTypeView) {
        _selectCarTypeView = [[CSelectCarTypeView alloc] init];
        
        @weakify(self)
        [_selectCarTypeView setSelectCBModelListener:^(id cbModel, id csModel) {
            @strongify(self)
            CBModel *carBrandModel = (CBModel *)cbModel;// 车品牌
            CBModel *carTypeModel = (CBModel *)csModel; // 车系
            
            NSDictionary *userInfo = @{@"carBrandModel": carBrandModel,
                                       @"carTypeModel": carTypeModel
                                      };
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SelectCarTypeNotificationName object:nil userInfo:userInfo];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [_selectCarTypeView setRefreshCarTypeModelListener:^(BOOL isRequestFailure) {
            @strongify(self)
            [self showHub];
            [self.mineNetData getCarTypeWithTag:@"getCarTypeTag"];
        }];
    }
    
    return _selectCarTypeView;
}

@end
