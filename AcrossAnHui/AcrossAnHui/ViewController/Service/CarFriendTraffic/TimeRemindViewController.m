//
//  TimeRemindViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/5.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "TimeRemindViewController.h"
#import "CoreServeNetData.h"
#import "OrderRoadModel.h"
#import "OrderRoadInfoViewController.h"
#import "AddOrderRoadViewController.h"

@interface TimeRemindViewController ()

@property (nonatomic, retain) CoreServeNetData *coreServeNetData;
@property (nonatomic, retain) NSMutableArray *orderRoads;

@end

@implementation TimeRemindViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"定制路况";
    
    [self.view addSubview:self.timeRemindView];
    [self.timeRemindView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    _coreServeNetData = [[CoreServeNetData alloc] init];
    _coreServeNetData.delegate = self;
    
    [self getUserCustomRoadList];
    
    // 编辑／添加路况的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserCustomRoadList) name:TimeRemindNotificationName object:nil];
}

- (void) getUserCustomRoadList {
    [self showHub];
    [_coreServeNetData getUserCustomRoadListWithToken:self.loginModel.token userId:self.loginModel.loginID tag:@"getUserCustomRoadListTag"];
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
    
    if ([tag isEqualToString:@"getUserCustomRoadListTag"]) {
        self.orderRoads = [OrderRoadModel convertFromArray:result];
        
        [self updateData];
    }
    
    if ([tag isEqualToString:@"delCustomRoadTag"]) {
        [self updateData];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self hideHub];
    [self showTextHubWithContent:tint];
    
    if ([tag isEqualToString:@"getUserCustomRoadListTag"]) {
        [self.timeRemindView refreshDataSource:nil];
    }
}

//更新显示的数据
- (void) updateData {
    if (self.orderRoads && (self.orderRoads.count > 0 && self.orderRoads.count < 3)) {
        [self addRightBarButtonItem];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (self.orderRoads && self.orderRoads.count > 0) {
        [self.timeRemindView refreshDataSource:self.orderRoads];
    } else {
        [self.timeRemindView refreshDataSource:@[]];
    }
}

#pragma mark - getter/setter

- (CTimeRemindView *) timeRemindView {
    if (!_timeRemindView) {
        _timeRemindView = [[CTimeRemindView alloc] init];
        
        @weakify(self)
        [_timeRemindView setAddRoadInfoCellListener:^{
            @strongify(self)
            [self addEditOrderRoadWithModel:nil];
        }];
        [_timeRemindView setShowRoadInfoCellListener:^(id result) {
            @strongify(self)
            OrderRoadModel *model = (OrderRoadModel *) result;
            
            OrderRoadInfoViewController *controller = [[OrderRoadInfoViewController alloc] init];
            
            // 取出起至点
            NSArray *startArray = [model originArray];
            NSArray *endArray = [model destinationArray];
            
            if (startArray) {
                controller.startPoint = [AMapNaviPoint locationWithLatitude:[startArray[0] doubleValue] longitude:[startArray[1] doubleValue]];
            }
            
            if (endArray) {
                controller.endPoint = [AMapNaviPoint locationWithLatitude:[endArray[0] doubleValue] longitude:[endArray[1] doubleValue]];
            }
            
            [self basePushViewController:controller];
        }];
        [_timeRemindView setEditRoadInfoCellListener:^(id result) {
            @strongify(self)
            OrderRoadModel *model = (OrderRoadModel *) result;
            [self addEditOrderRoadWithModel:model];
        }];
        [_timeRemindView setDeleteRoadInfoCellListener:^(id result) {
            @strongify(self)
            [self showHub];
            
            OrderRoadModel *model = (OrderRoadModel *) result;
            [self.coreServeNetData delCustomRoadWithRoadID:model.orderRoadID token:self.loginModel.token tag:@"delCustomRoadTag"];
            
            // 移除该model
            [self.orderRoads removeObject:model];
        }];
        [_timeRemindView setRefreshRoadInfoCellListener:^{
            @strongify(self)
            [self.coreServeNetData getUserCustomRoadListWithToken:self.loginModel.token userId:self.loginModel.loginID tag:@"getUserCustomRoadListTag"];
        }];
    }
    
    return _timeRemindView;
}

#pragma mark - private method

// “添加”按钮
- (void) addRightBarButtonItem {
    // rightBarButtonItem
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(addOrderRoadInfo)];
    [rightBarButtonItem setTintColor:[UIColor whiteColor]];
    NSDictionary *dict = @{ NSFontAttributeName: [UIFont systemFontOfSize:CTXTextFont] };
    [rightBarButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void) addOrderRoadInfo {
    [self addEditOrderRoadWithModel:nil];
}

// 去编辑／添加定制路况
- (void) addEditOrderRoadWithModel:(OrderRoadModel *)model {
    AddOrderRoadViewController *controller = [[AddOrderRoadViewController alloc] initWithStoryboard];
    controller.model = model;
    [self basePushViewController:controller];
}

@end
