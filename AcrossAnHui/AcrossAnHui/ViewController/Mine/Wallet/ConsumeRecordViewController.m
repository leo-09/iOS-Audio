//
//  ConsumeRecordViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ConsumeRecordViewController.h"
#import "ConsumeRecordModel.h"
#import "CConsumeRecordView.h"
#import "LDCalendarView.h"
#import "WalletNetData.h"

@interface ConsumeRecordViewController ()

@property (nonatomic, retain) CConsumeRecordView *consumeRecordView;

@property (nonatomic, retain) LDCalendarView *calendarView;
@property (nonatomic, copy) NSString *addTime;// 查询消费记录开始时间 YYYY-MM-DD hh:mm:ss
@property (nonatomic, copy) NSString *endTime;// 查询消费记录截止时间 YYYY-MM-DD hh:mm:ss

@property (nonatomic, retain) WalletNetData *walletNetData;

@end

#define startPage 1

@implementation ConsumeRecordViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消费记录";
    
    // rightBarButtonItem
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_rq"] style:UIBarButtonItemStyleDone target:self action:@selector(selectDateRange)];
    [rightBarButtonItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self.view addSubview:self.consumeRecordView];
    [self.consumeRecordView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    _walletNetData = [[WalletNetData alloc] init];
    _walletNetData.delegate = self;
    
    [self showHub];
    _currentPage = startPage - 1;
    [self costRecords];
}

// 选择日期
- (void) selectDateRange {
    if (!self.calendarView) {
        self.calendarView = [[LDCalendarView alloc] init];
    }
    
    [self.calendarView showWithSuperView:self.view];
    
    @weakify(self)
    [self.calendarView setComplete:^(NSString *start, NSString *end) {
        @strongify(self)
        
        [self.calendarView removeFromSuperview];
        
        if (start && end) {
            self.addTime = [NSString stringWithFormat:@"%@ 00:00:00", start];
            self.endTime = [NSString stringWithFormat:@"%@ 23:59:59", end];
        } else {
            self.addTime = nil;
            self.endTime = nil;
        }
        
        [self showHub];
        self.currentPage = startPage - 1;
        [self costRecords];
    }];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"costRecordsTag"]) {
        [_consumeRecordView endRefreshing];
        
        int totalPage = [result[@"totalPage"] intValue];
        
        if ([[result allKeys] containsObject:@"currentPage"]) {
            _currentPage = [result[@"currentPage"] intValue];// 获取最新的当前页，重新联网后的请求就不会出错了
        }
        
        // 获取充值记录并分组
        NSArray<ConsumeRecordModel *> *records = [ConsumeRecordModel convertFromArray:result[@"costList"]];
        
        // 没有回传最新当前页码，重新联网后的请求就会出错
        if (_currentPage <= startPage) {// 刷新
            _currentPage = startPage;// 因为网络请求失败了之后，_currentPage减1，则会出现小于startPage的情况
            [_consumeRecordView refreshDataSource:records];
        } else {
            [_consumeRecordView addDataSource:records];
        }
        
        if (_currentPage >= totalPage) {
            [_consumeRecordView removeFooter];
        } else {
            [_consumeRecordView addFooter];
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"costRecordsTag"]) {
        [_consumeRecordView endRefreshing];
        [_consumeRecordView hideFooter];
        
        if (_currentPage <= startPage) {
            [_consumeRecordView refreshDataSource:nil];
        } else {
            [_consumeRecordView addDataSource:@[]];
        }
        
        _currentPage--;
    }
}

#pragma mark - getter/setter

- (CConsumeRecordView *) consumeRecordView {
    if (!_consumeRecordView) {
        _consumeRecordView = [[CConsumeRecordView alloc] init];
        
        @weakify(self)
        [_consumeRecordView setRefreshRecordDataListener:^(BOOL isRequestFailure) {
            @strongify(self)
            
            if (isRequestFailure) {
                [self showHub];
            }
            
            self.currentPage = startPage - 1;
            [self costRecords];
        }];
        [_consumeRecordView setLoadRecordDataListener:^ {
            @strongify(self)
            
            [self costRecords];
        }];
    }
    
    return _consumeRecordView;
}

#pragma mark - netWork

// 消费记录查询
- (void)costRecords {
    // 请求下一页数据
    _currentPage++;
    [_walletNetData costRecordsWithToken:self.loginModel.token
                                  userId:self.loginModel.loginID
                                 addTime:_addTime
                                 endTime:_endTime
                                    page:_currentPage
                                     tag:@"costRecordsTag"];
}

@end
