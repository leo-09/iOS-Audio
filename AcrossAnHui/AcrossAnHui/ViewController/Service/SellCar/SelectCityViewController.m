//
//  SelectCityViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/14.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "SelectCityViewController.h"
#import "CoreServeNetData.h"
#import "CEventDetailView.h"
#import "EventDetailModel.h"

@interface SelectCityViewController ()

@property (nonatomic, retain) CEventDetailView *eventDetailView;

@end

@implementation SelectCityViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"城市选择";
    
    // rightBarButtonItem
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(submitEvent)];
    [rightBarButtonItem setTintColor:[UIColor whiteColor]];
    NSDictionary *dict = @{ NSFontAttributeName: [UIFont systemFontOfSize:CTXTextFont] };
    [rightBarButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self.view addSubview:self.eventDetailView];
    [self.eventDetailView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    // 显示城市, 标注已选择的城市
    [_eventDetailView setDataSource:@[ [self cityModel] ] selectCity:self.selectedCity selectLabels:nil];
}

- (void) submitEvent {
    if (!self.eventDetailView.selectedcity || [self.eventDetailView.selectedcity isEqualToString:@""]) {
        [self showTextHubWithContent:@"请选择城市"];
        return;
    }
    
    NSString *city = self.eventDetailView.selectedcity;
    if (![self.eventDetailView.selectedcity containsString:@"市"]) {
        city = [NSString stringWithFormat:@"%@市", city];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SelectCityNotificationName object:nil userInfo:@{@"city": city}];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private method

- (NSArray *) readCityData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AnHui" ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:path];;
}

- (SuperEventDetailModel *) cityModel {
    SuperEventDetailModel *cityModel = [[SuperEventDetailModel alloc] init];
    
    NSMutableArray<EventDetailModel *> *models = [[NSMutableArray alloc] init];
    
    NSArray *cityArray = [self readCityData];
    for (NSString *city in cityArray) {
        EventDetailModel *model = [[EventDetailModel alloc] init];
        model.name = city;
        [models addObject:model];
    }
    
    cityModel.labelList = models;
    cityModel.title = @"安徽所有城市";
    cityModel.isCity = YES;
    
    return cityModel;
}

#pragma mark - getter/setter

- (CEventDetailView *) eventDetailView {
    if (!_eventDetailView) {
        _eventDetailView = [[CEventDetailView alloc] init];
    }
    
    return _eventDetailView;
}

@end
