//
//  EventDetailViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/5.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "EventDetailViewController.h"
#import "CoreServeNetData.h"
#import "CEventDetailView.h"
#import "EventDetailModel.h"

@interface EventDetailViewController ()

@property (nonatomic, retain) CEventDetailView *eventDetailView;
@property (nonatomic, retain) CoreServeNetData *coreServeNetData;

@property (nonatomic, retain) SuperEventDetailModel *cityModel;
@property (nonatomic, retain) SuperEventDetailModel *labelModel;

@end

@implementation EventDetailViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"事件订阅";
    
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
    
    [self showHub];
    
    _coreServeNetData = [[CoreServeNetData alloc] init];
    _coreServeNetData.delegate = self;
    
    [self.coreServeNetData getTrafficLabelWithOnlyCache:NO tag:@"getTrafficLabelTag"];
}

- (void) submitEvent {
    if (!self.eventDetailView.selectedcity || [self.eventDetailView.selectedcity isEqualToString:@""]) {
        [self showTextHubWithContent:@"请选择城市"];
        return;
    }
    if (!self.eventDetailView.selectedLabel || self.eventDetailView.selectedLabel.count == 0) {
        [self showTextHubWithContent:@"请选择标签"];
        return;
    }
    
    [self showHubWithLoadText:@"正在订阅..."];
    
    NSString *city = self.eventDetailView.selectedcity;
    if (![self.eventDetailView.selectedcity containsString:@"市"]) {
        city = [NSString stringWithFormat:@"%@市", city];
    }
    
    NSString *labels = [self.eventDetailView.selectedLabel componentsJoinedByString:@","];
    [self.coreServeNetData addEventWithToken:self.loginModel.token city:city label:labels tag:@"addEventTag"];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"getTrafficLabelTag"]) {
        NSArray *labels = (NSArray *)result;
        
        _labelModel = [[SuperEventDetailModel alloc] init];
        _labelModel.labelList = [EventDetailModel convertFromArray:labels];
        _labelModel.title = @"选择标签";
        _labelModel.isCity = NO;
        
        // 获取完标签，再更新已订阅的信息
        [self.coreServeNetData getEventWithToken:self.loginModel.token userId:self.loginModel.loginID tag:@"getEventTag"];
    }
    
    if ([tag isEqualToString:@"getEventTag"]) {
        [self hideHub];
        
        NSDictionary *dict = (NSDictionary *)result;
        
        // 获取已订阅的信息
        NSString *selectedCity = dict[@"city"];
        NSString *label = dict[@"label"];
        NSMutableArray *selectedLabels = [[NSMutableArray alloc] initWithArray:[label componentsSeparatedByString:@","]];
        
        // 标签/标注已订阅的信息
        [_eventDetailView setDataSource:@[ [self cityModel], _labelModel ] selectCity:selectedCity selectLabels:selectedLabels];
    }
    
    if ([tag isEqualToString:@"addEventTag"]) {
        [self hideHub];
        [self showTextHubWithContent:@"订阅成功"];
        
        // 订阅成功，通知开启事件订阅开关
        [[NSNotificationCenter defaultCenter] postNotificationName:AddEventNotificationName object:nil userInfo:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    
    if ([tag isEqualToString:@"getTrafficLabelTag"]) {
        _labelModel = [[SuperEventDetailModel alloc] init];
        _labelModel.labelList = @[];
        _labelModel.title = @"选择标签";
        _labelModel.isCity = NO;
        
        // 获取完标签，再更新已订阅的信息
        [self.coreServeNetData getEventWithToken:self.loginModel.token userId:self.loginModel.loginID tag:@"getEventTag"];
    }
    
    if ([tag isEqualToString:@"getEventTag"]) {
        [self hideHub];
        // 标签／标注已订阅的信息
        [_eventDetailView setDataSource:@[ [self cityModel], _labelModel ] selectCity:nil selectLabels:nil];
    }
    
    if ([tag isEqualToString:@"addEventTag"]) {
        [self hideHub];
    }
}

#pragma mark - private method

- (NSArray *) readCityData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AnHui" ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:path];;
}

- (SuperEventDetailModel *) cityModel {
    if (!_cityModel) {
        _cityModel = [[SuperEventDetailModel alloc] init];
        
        NSMutableArray<EventDetailModel *> *models = [[NSMutableArray alloc] init];
        
        NSArray *cityArray = [self readCityData];
        for (NSString *city in cityArray) {
            EventDetailModel *model = [[EventDetailModel alloc] init];
            model.name = city;
            [models addObject:model];
        }
        
        _cityModel.labelList = models;
        _cityModel.title = @"选择城市";
        _cityModel.isCity = YES;
    }
    
    return _cityModel;
}

#pragma mark - getter/setter

- (CEventDetailView *) eventDetailView {
    if (!_eventDetailView) {
        _eventDetailView = [[CEventDetailView alloc] init];
    }
    
    return _eventDetailView;
}

@end
