//
//  TrafficRecordViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "TrafficRecordViewController.h"
#import "CTrafficRecordView.h"
#import "PickerSelectorView.h"
#import "CarFriendRecordNetData.h"
#import "DateTool.h"
#import "CarFriendTrafficRecordModel.h"

#define startPage 1

@interface TrafficRecordViewController ()

@property (nonatomic, retain) CarFriendRecordNetData *carFriendRecordNetData;
@property (nonatomic, copy) NSString *selectDate;

@property (nonatomic, retain) CTrafficRecordView *trafficRecordView;

@end

@implementation TrafficRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"上报记录";
    // rightBarButtonItem
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStyleDone target:self action:@selector(filter)];
    [rightBarButtonItem setTintColor:[UIColor whiteColor]];
    NSDictionary *dict = @{ NSFontAttributeName: [UIFont systemFontOfSize:CTXTextFont] };
    [rightBarButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self.view addSubview:self.trafficRecordView];
    [self.trafficRecordView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    _carFriendRecordNetData = [[CarFriendRecordNetData alloc] init];
    _carFriendRecordNetData.delegate = self;
    
    [self showHub];
    
    // 默认请求当前月的数据
    self.selectDate = [[DateTool sharedInstance] currentDataWithFormat:YYYYMM];
    
    _currentPage = startPage - 1;
    [self getTrafficCount];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"getTrafficCountTag"]) {
        [_trafficRecordView endRefreshing];
        
        NSDictionary *dict = (NSDictionary *)result;
        int pages = [dict[@"pageCount"] intValue];// 总页数
        _currentPage = [dict[@"offset"] intValue];// 获取最新的当前页，重新联网后的请求就不会出错了
        NSArray *models = [CarFriendTrafficRecordModel convertFromArray:result[@"data"]];
        
        // 本月上报 / 已采用
        [_trafficRecordView setTotalRecords:dict[@"totalRecords"] usedCount:dict[@"IsSuccess"]];
        
        if (_currentPage <= startPage) {// 刷新
            _currentPage = startPage;// 因为网络请求失败了之后，_currentPage减1，则会出现小于startPage的情况
            [_trafficRecordView refreshDataSource:models];
        } else {// 加载
            [_trafficRecordView addDataSource:models page:_currentPage];
        }
        
        if (_currentPage >= pages) {
            // 删除加载提示
            [_trafficRecordView removeFooter];
        } else {
            [_trafficRecordView addFooter];
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"getTrafficCountTag"]) {
        [_trafficRecordView endRefreshing];
        [_trafficRecordView hideFooter];
        
        if (_currentPage <= startPage) {// 刷新的时候才能展示nil界面
            [_trafficRecordView refreshDataSource:nil];
        } else {// 加载
            [_trafficRecordView addDataSource:@[] page:_currentPage];
        }
        
        _currentPage--;
    }
}

#pragma mark - getter/setter

- (CTrafficRecordView *) trafficRecordView {
    if (!_trafficRecordView) {
        _trafficRecordView = [[CTrafficRecordView alloc] init];
        
        @weakify(self)
        [_trafficRecordView setRefreshNewsInfoDataListener:^ (BOOL isRequestFailure) {
            @strongify(self)
            
            if (isRequestFailure) {
                [self showHub];
            }
            
            self.currentPage = startPage - 1;
            [self getTrafficCount];
        }];
        
        [_trafficRecordView setLoadNewsInfoDataListener:^ {
            @strongify(self)
            
            [self getTrafficCount];
        }];
    }
    
    return _trafficRecordView;
}

#pragma mark - private method

- (void) getTrafficCount {
    // 请求下一页数据
    _currentPage++;
    [_carFriendRecordNetData getTrafficCountWithToken:self.loginModel.token
                                               userId:self.loginModel.loginID
                                          currentPage:_currentPage
                                                 date:self.selectDate
                                                  tag:@"getTrafficCountTag"];
}

// 筛选
- (void) filter {
    PickerSelectorView *pickerView = [[PickerSelectorView alloc] init];
    
    NSMutableArray *years = [[NSMutableArray alloc] init];
    for (int i = 1970; i <= [[DateTool sharedInstance] getCurrentYear]; i++) {
        [years addObject:[NSString stringWithFormat:@"%d年", i]];
    }
    
    NSArray *months = @[ @"01月", @"02月", @"03月", @"04月", @"05月", @"06月",
                         @"07月", @"08月", @"09月", @"10月", @"11月", @"12月" ];
    
    pickerView.dataSource = @[ years, months ];
    NSArray *dateArr = [self.selectDate componentsSeparatedByString:@"-"];
    [pickerView setCurrentValue:dateArr];
    
    [pickerView setSelectorResultListener:^(id result) {
        NSArray *arr = (NSArray *)result;
        NSMutableString *date = [[NSMutableString alloc] initWithString:[arr componentsJoinedByString:@""]];
        [date replaceCharactersInRange:NSMakeRange(4, 1) withString:@"-"];
        [date replaceCharactersInRange:NSMakeRange(7, 1) withString:@""];
        
        self.selectDate = date;
        _currentPage = startPage - 1;
        [self getTrafficCount];
    }];
    
    [pickerView showView];
}


@end
