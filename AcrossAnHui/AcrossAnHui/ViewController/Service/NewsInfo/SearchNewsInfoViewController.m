//
//  SearchNewsInfoViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "SearchNewsInfoViewController.h"
#import "NewsInfoViewController.h"
#import "SearchNewsInfoLocalData.h"
#import "ServiceNetData.h"

@interface SearchNewsInfoViewController ()

@property (nonatomic, retain) ServiceNetData *serviceNetData;

@end

@implementation SearchNewsInfoViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.searchNewsInfoView];
    [self.searchNewsInfoView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.serviceNetData = [[ServiceNetData alloc] init];
    self.serviceNetData.delegate = self;
    [self.serviceNetData getHotkeywordsWithTag:@"getHotkeywordsTag"];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [self queryRecord];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"getHotkeywordsTag"]) {
        // 处理数据结果
        NSArray *keywordResult = (NSArray *)result;
        NSMutableArray *hotKeywords = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in keywordResult) {
            [hotKeywords addObject:dict[@"name"]];
        }
        
        // 添加到View中
        [_searchNewsInfoView setHotKeywords:hotKeywords];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    
    if ([tag isEqualToString:@"getHotkeywordsTag"]) {
        // 添加 空数据 到View中
        [_searchNewsInfoView setHotKeywords:nil];
    }
}

#pragma mark - getter/setter

- (CSearchNewsInfoView *) searchNewsInfoView {
    if (!_searchNewsInfoView) {
        _searchNewsInfoView = [[CSearchNewsInfoView alloc] init];
        
        @weakify(self)
        [_searchNewsInfoView setBackListener:^{
            @strongify(self)
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [_searchNewsInfoView setSearchListener:^(id result) {
            [[SearchNewsInfoLocalData sharedInstance] addRecord:(NSString *)result];
            @strongify(self)
            NewsInfoViewController * controller = [[NewsInfoViewController alloc] init];
            controller.naviTitle = @"搜索结果";
            controller.searchkeyWord = (NSString *)result;
            controller.nilDataTint = @"对不起，没有找到相关内容";
            [self basePushViewController:controller];

        }];
        [_searchNewsInfoView setClearRecordListener:^{
            @strongify(self)
            [self clearRecord];
        }];
    }
    
    return _searchNewsInfoView;
}

- (void) clearRecord {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                        message:@"确认清空历史搜索记录吗？"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[SearchNewsInfoLocalData sharedInstance] removeAllRecord];
        [self queryRecord];
    }];
    [controller addAction:cancelAction];
    [controller addAction:okAction];
    
    [self presentViewController:controller animated:YES completion:nil];
}

// 获取历史搜索记录
- (void) queryRecord {
    [[SearchNewsInfoLocalData sharedInstance] queryAllRecordWithBlock:^(NSString *key, id<NSCoding> object) {
        NSArray *records = (NSArray *)object;
        // 添加搜索记录
        dispatch_async(dispatch_get_main_queue(), ^{
            [_searchNewsInfoView setRecords:records];
        });
    }];
}

@end
