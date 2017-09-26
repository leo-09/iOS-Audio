//
//  ParkingRecordViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ParkingRecordViewController.h"
#import "ParkRecordView.h"
#import "ParkRecordHeadView.h"
#import "ParkRecordDetailViewController.h"
#import "NetURLManager.h"
#import "ParkRecordModel.h"
#import "CarInspectRecordNetData.h"
#import "PromptView.h"

@interface ParkingRecordViewController() {
    NSInteger totalPage;
    BOOL isHash;
    
    UIView *bgView;
}

@property (nonatomic, retain) ParkRecordView *tableView;
@property (nonatomic, retain) ParkRecordHeadView *headView;

@property (nonatomic, retain) NSMutableArray *dataArr;
@property (nonatomic, retain) NSMutableArray *plateNumberArr;
@property (nonatomic, retain) NSString *selectPlateNumberStr;
@property (nonatomic, assign) NSString *selectPayStatusStr;
@property (nonatomic, assign) int currentPage;

@property (nonatomic, retain) CarInspectRecordNetData *carInspectRecordNetData;
@property (nonatomic, retain) PromptView * promptView;

@end

@implementation ParkingRecordViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _carInspectRecordNetData = [[CarInspectRecordNetData alloc]init];
    _carInspectRecordNetData.delegate = self;
    
    isHash = YES;
    _dataArr = [NSMutableArray array];
    _plateNumberArr  = [NSMutableArray array];
    
    if (_isPay) {
        _selectPayStatusStr = @"1";
    } else {
        _selectPayStatusStr = @"";
    }
    
    _selectPlateNumberStr = @"";
    _currentPage = 1;
    totalPage = 1;
    self.title = @"停车记录";
    
    [self initUI];
    
    [self showHub];
    [self getData:_selectPlateNumberStr currentPage:_currentPage isPay:_selectPayStatusStr];
    
    //第三方支付成功后的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(update) name:ParkingPaySuccessNotificationName object:nil];
    //钱包充值成功后的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(update) name:ParkingRechargeSuccessNotificationName object:nil];
    
    // 停车记录的筛选按钮 显示/隐藏筛选内容的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showParkingRecord) name:ParkingRecordShowNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideParkingRecord) name:ParkingRecordHideNotificationName object:nil];
}

// 微信、支付支付成功后刷新数据
-(void)update {
    [self performSelector:@selector(replyTime) withObject:self afterDelay:2];
}

-(void)replyTime {
    _currentPage = 1;
    [self getData:_selectPlateNumberStr currentPage:_currentPage isPay:_selectPayStatusStr];
}

-(void)initUI {
    self.tableView = [[ParkRecordView alloc] initWithFrame:CGRectMake(0, 0, CTXScreenWidth, CTXScreenHeight - 64 - 50)];
    [self.view addSubview:self.tableView];
    
    @weakify(self)
    [self.tableView setSelectCellListener:^(ParkRecordModel *model) {
        @strongify(self)
        
        ParkRecordDetailViewController * controller = [[ParkRecordDetailViewController alloc] init];
        controller.model = model;
        [self basePushViewController:controller];
        
        [controller setSelectCellListener:^{
            @strongify(self)
            
            [self showHub];
            self.currentPage = 1;
            [self getData:self.selectPlateNumberStr currentPage:self.currentPage isPay:self.selectPayStatusStr];
        }];
    }];
    
    [self.tableView setRefreshParkingRecordDataListener:^(BOOL isFailure){
        @strongify(self);
       
        self.currentPage = 1;
        [self getData:self.selectPlateNumberStr currentPage:self.currentPage isPay:self.selectPayStatusStr];
    }];
    
    //上拉加载
    [self.tableView setFreshListener:^{
        @strongify(self)
        
        self.currentPage = self.currentPage + 1;
        
        if (self.currentPage <= totalPage) {
            [self getData:self.selectPlateNumberStr currentPage:self.currentPage isPay:self.selectPayStatusStr];
        } else {
            [self.tableView removeFoodView];
        }
        
    }];
    
    //下拉刷新
    [self.tableView setRefreshListener:^{
        @strongify(self)
        
        self.currentPage = 1;
        [self getData:self.selectPlateNumberStr currentPage:self.currentPage isPay:self.selectPayStatusStr];
    }];
}

-(void)getData:(NSString *)magCard currentPage:(int)currentpage isPay:(NSString *)isPay {
    [_carInspectRecordNetData queryParkingRecordListWithToken:self.loginModel.token
                                                       userId:self.loginModel.loginID
                                                      magCard:magCard
                                                  currentPage:currentpage
                                                        isPay:isPay
                                                          tag:@"ParkingRecord"];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"ParkingRecord"]) {
        [self.tableView cancelRefresh];
        
        NSDictionary * dataDic = (NSDictionary *)result;
        NSArray * parkingListArr = dataDic[@"parkingList"];
        if (!parkingListArr||parkingListArr.count<1) {
          
            [_tableView refreshData:@[]];
            return ;
        }
        
        NSString * carNumber = dataDic[@"carNumber"];
        _currentPage = [dataDic[@"currentPage"] intValue];
        totalPage = [dataDic[@"totalPage"] integerValue];
        
        if (![carNumber isEqualToString:@""]) {
            NSArray *carArr = [carNumber componentsSeparatedByString:@","];
            self.plateNumberArr = (NSMutableArray *)carArr;
        }
        
        NSMutableArray * arr = [NSMutableArray array];
        for (NSDictionary * Ddictionary  in parkingListArr) {
            ParkRecordModel * model = [ParkRecordModel convertFromDict:Ddictionary];
            [arr addObject:model];
        }
        
        if ([dataDic[@"currentPage"] integerValue] == 1) {
            self.dataArr = arr;
        } else {
            [self.dataArr addObjectsFromArray:arr];
        }
        
        [_tableView refreshData:self.dataArr];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
    
    if (_currentPage == 1) {// 刷新的时候才能展示nil界面
        [_tableView refreshData:nil];
        if (isHash == YES) {
            isHash = NO;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ParkingRecordDeleteNotificationName object:nil userInfo:nil];
        }
    } else {// 加载
        [_tableView refreshData:@[]];
    }
    
    _currentPage--;
}

#pragma mark - CTXSegmentedPageViewControllerDelegate

- (NSString *)viewControllerTitle {
    return self.viewTitle ? self.viewTitle : self.title;
}

#pragma 导航右按钮：筛选

- (void) showParkingRecord {
    bgView = [[UIView alloc]initWithFrame:self.view.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.4;
    [self.view addSubview:bgView];
    
    UITapGestureRecognizer * Recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(delectbgview)];
    Recognizer.cancelsTouchesInView=false;
    [bgView addGestureRecognizer:Recognizer];
    
    if (_plateNumberArr.count < 1) {
        self.headView = [[ParkRecordHeadView alloc] initWithFrame:CGRectMake(0, 0.5, CTXScreenWidth, 50) dataArr:_plateNumberArr];
    }else{
        self.headView = [[ParkRecordHeadView alloc] initWithFrame:CGRectMake(0, 0.5, CTXScreenWidth, 100) dataArr:_plateNumberArr];
    }
    
    [self.view addSubview:self.headView];
    
    @weakify(self)
    [self.headView setSelectCarListener:^(NSString *plateNumber, NSString *value) {
        @strongify(self)
        
        self.selectPlateNumberStr = plateNumber;
        self.selectPayStatusStr = value;
    }];
}

- (void) hideParkingRecord {
    [bgView removeFromSuperview];
    bgView = nil;
    [self.headView removeFromSuperview];
    self.headView = nil;
    
    //开始筛选
    _currentPage = 1;
    [self getData:_selectPlateNumberStr currentPage:_currentPage isPay:_selectPayStatusStr];
}

// 开始筛选
-(void)delectbgview {
    [[NSNotificationCenter defaultCenter] postNotificationName:ParkingRecordRestoreNotificationName object:nil userInfo:nil];
    
    [bgView removeFromSuperview];
    bgView = nil;
    
    [self.headView removeFromSuperview];
    self.headView = nil;
    _currentPage = 1;
    [self getData:_selectPlateNumberStr currentPage:_currentPage isPay:_selectPayStatusStr];
}

@end
