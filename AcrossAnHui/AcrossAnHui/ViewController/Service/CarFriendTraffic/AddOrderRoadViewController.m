//
//  AddOrderRoadViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/5.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "AddOrderRoadViewController.h"
#import "SearchAddressViewController.h"
#import "NearByMAPointAnnotation.h"
#import "OneListSelectorView.h"
#import "PickerSelectorView.h"

@implementation AddOrderRoadViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"CarFriendTraffic" bundle:nil] instantiateViewControllerWithIdentifier:@"AddOrderRoadViewController"];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"定制路况";
    CTXViewBorderRadius(_sureLabel, 5.0, 0, [UIColor clearColor]);
    
    if (self.model) {
        self.startAddressLabel.text = self.model.originAddr;
        self.stopAddressLabel.text = self.model.destinationAddr;
        self.timeLabel.text = self.model.time;
        self.weekLabel.text = [self.model weekDesc];
        
        isAddOrderRoad = NO;// 编辑定制路况
    } else {
        self.model = [[OrderRoadModel alloc] init];
        isAddOrderRoad = YES;// 添加定制路况
    }
    
    self.coreServeNetData = [[CoreServeNetData alloc] init];
    self.coreServeNetData.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAddress:) name:SearchAddressNotificationName object:nil];
}

// 移除观察者
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) getAddress:(id)sender {
    NSNotification *noti = (NSNotification *) sender;
    NSDictionary *userInfo = noti.userInfo;
    
    NearByMAPointAnnotation *selectedAnnotation = userInfo[@"selectedAnnotation"];
    if ([userInfo[@"resource"] isEqualToString:@"start"]) {
        
        self.model.originAddr = selectedAnnotation.title;
        self.model.origin = [NSString stringWithFormat:@"%f,%f", selectedAnnotation.coordinate.latitude, selectedAnnotation.coordinate.longitude];
        
        self.startAddressLabel.text = selectedAnnotation.title;
    } else {
        
        self.model.destinationAddr = selectedAnnotation.title;
        self.model.destination = [NSString stringWithFormat:@"%f,%f", selectedAnnotation.coordinate.latitude, selectedAnnotation.coordinate.longitude];
        
        self.stopAddressLabel.text = selectedAnnotation.title;
    }
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1:{// 起点
            SearchAddressViewController *controller = [[SearchAddressViewController alloc] init];
            
            // 编辑模式或者已经选择一个点，默认显示点
            NSArray *array = [self.model originArray];
            if (array) {
                NearByMAPointAnnotation *anno = [[NearByMAPointAnnotation alloc] init];
                anno.coordinate = CLLocationCoordinate2DMake([array[0] doubleValue], [array[1] doubleValue]);
                anno.title = self.model.originAddr;
                anno.tag = @"MapSearchView";
                controller.selectedAnnotation = anno;
            }
            
            controller.resource = @"start";
            [self basePushViewController:controller];
        }
            break;
        case 2: {// 终点
            SearchAddressViewController *controller = [[SearchAddressViewController alloc] init];
            
            // 编辑模式或者已经选择一个点，默认显示点
            NSArray *array = [self.model destinationArray];
            if (array) {
                NearByMAPointAnnotation *anno = [[NearByMAPointAnnotation alloc] init];
                anno.coordinate = CLLocationCoordinate2DMake([array[0] doubleValue], [array[1] doubleValue]);
                anno.title = self.model.destinationAddr;
                anno.tag = @"MapSearchView";
                controller.selectedAnnotation = anno;
            }
            
            controller.resource = @"end";
            [self basePushViewController:controller];
        }
            break;
        case 3:// 提醒时间
            [self addSelectTimeView];
            break;
        case 4:// 重复
            [self addSelectWeekView];
            break;
        case 6:// 确认
            [self submit];
            break;
        default:
            break;
    }
}

#pragma mark - 显示子view

- (void) addSelectTimeView {
    PickerSelectorView *pickerView = [[PickerSelectorView alloc] init];
    
    NSArray *hours = @[ @"00", @"01", @"02", @"03", @"04", @"05",
                         @"06", @"07", @"08", @"09", @"10", @"11",
                         @"12", @"13", @"14", @"15", @"16", @"17",
                         @"18", @"19", @"20", @"21", @"22", @"23" ];
    NSArray *minutes = @[ @"00", @"05", @"10", @"15", @"20", @"25",
                          @"30", @"35", @"40", @"45", @"50", @"55" ];
    
    pickerView.dataSource = @[ hours, minutes ];
    
    if (self.model.time) {
        [pickerView setCurrentValue:[self.model.time componentsSeparatedByString:@":"]];
    } else {
        [pickerView setCurrentValue:@[ @"7", @"00"]];
    }
    
    [pickerView setSelectorResultListener:^(id result) {
        NSArray *arr = (NSArray *)result;
        
        self.model.time = [arr componentsJoinedByString:@":"];
        self.timeLabel.text = self.model.time;
    }];
    
    [pickerView showView];
}

- (void) addSelectWeekView {
    OneListSelectorView *selectorView = [[OneListSelectorView alloc] init];
    selectorView.isMultiSelect = YES;
    
    // 添加内容
    NSArray *selectWeekArray = [self.model weekArray];
    NSArray *weekArray = @[ @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六" ];
    NSMutableArray *dataSource = [[NSMutableArray alloc] init];
    for (NSString *week in weekArray) {
        OneListSelectorModel *model = [[OneListSelectorModel alloc] init];
        // 设置值
        model.name = week;
        model.isSelected = NO;
        // 选择
        for (NSString *selectWeek in selectWeekArray) {
            if ([selectWeek isEqualToString:week]) {
                model.isSelected = YES;
                break;
            }
        }
        
        [dataSource addObject:model];
    }
    
    selectorView.dataSource = dataSource;
    
    [selectorView setSelectorResultListener:^(id result) {
        self.model.week = (NSString *)result;
        self.weekLabel.text = [self.model weekDesc];
    }];
    [selectorView showView];
}

#pragma mark - 提交

- (void) submit {
    if (!self.model.origin || [self.model.origin isEqualToString:@""]) {
        [self showTextHubWithContent:@"请选择起点"];
        return;
    }
    
    if (!self.model.destination || [self.model.destination isEqualToString:@""]) {
        [self showTextHubWithContent:@"请选择终点"];
        return;
    }
    
    if (!self.model.time || [self.model.time isEqualToString:@""]) {
        [self showTextHubWithContent:@"请选择提醒时间"];
        return;
    }
    
    if (!self.model.week || [self.model.week isEqualToString:@""]) {
        [self showTextHubWithContent:@"请选择重复次数"];
        return;
    }
    
    if (isAddOrderRoad) {
        [self showHubWithLoadText:@"添加定制路况中..."];
        [self.coreServeNetData addCustomRoadWithToken:self.loginModel.token orderRoadModel:self.model tag:@"addCustomRoadTag"];
    } else {
        [self showHubWithLoadText:@"编辑定制路况中..."];
        [self.coreServeNetData updateCustomRoadWithToken:self.loginModel.token orderRoadModel:self.model tag:@"updateCustomRoadTag"];
    }
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"addCustomRoadTag"]) {
        [self showTextHubWithContent:@"添加定制路况完成"];
    }
    
    if ([tag isEqualToString:@"updateCustomRoadTag"]) {
        [self showTextHubWithContent:@"编辑定制路况完成"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TimeRemindNotificationName object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self hideHub];
    [self showTextHubWithContent:tint];
}

@end
