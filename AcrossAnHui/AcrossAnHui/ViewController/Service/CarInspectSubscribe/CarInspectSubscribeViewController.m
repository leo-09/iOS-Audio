//
//  CarInspectSubscribeViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectSubscribeViewController.h"
#import "CarInspectSeachStationViewController.h"
#import "CarInspectStationInfoViewController.h"
#import "CarInspectStationMapListViewController.h"
#import "CJStationView.h"
#import "CarInspectNetData.h"
#import "AreaModel.h"

#define countPerPage 10
#define startPage 0

@interface CarInspectSubscribeViewController () {
    NSString * _city;//当前所在城市
    NSString * _province;//当前所在省
    NSString * currentAddress;
}

@property (nonatomic, retain) CJStationView * stationView;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, retain) CarInspectNetData *carInspectNetData;
@property (nonatomic, copy) NSString *areaid;
@property (nonatomic, retain) NSMutableArray * dataArr;

@end

@implementation CarInspectSubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArr = [NSMutableArray array];
    
    self.navigationItem.title = @"选择车检站";
    
    self.view.backgroundColor = UIColorFromRGB(CTXBackGroundColor);
    
    _carInspectNetData = [[CarInspectNetData alloc] init];
    _carInspectNetData.delegate = self;
    
    [self createNavRightBarButton];
    [self getLoctationInfo];
}

#pragma mark - private method

// 获取定位信息
-(void)getLoctationInfo {
    [self startUpdatingLocationWithBlock:^{
        _city = [AppDelegate sharedDelegate].aMapLocationModel.city;
        _province = [AppDelegate sharedDelegate].aMapLocationModel.province;
        currentAddress = [AppDelegate sharedDelegate].aMapLocationModel.formattedAddress;
        
        [self initUI];
        [self getAllcityInfoWithProvince:_province city:_city];
    }];
}

// 创建导航右边的两个按钮
-(void)createNavRightBarButton{
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithImage: [UIImage imageNamed:@"sousuo"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBtnClick)];
    UIBarButtonItem *mapItem = [[UIBarButtonItem alloc]initWithImage: [UIImage imageNamed:@"ditu_6.png"]style:UIBarButtonItemStylePlain target:self action:@selector(mapBtnClick)];;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    negativeSpacer.width=-17;
    self.navigationItem.rightBarButtonItems =@[mapItem,negativeSpacer,searchItem];
}

// 初始化表格
-(void)initUI {
    if (!_stationView) {
        _stationView = [[CJStationView alloc] initWithFrame:self.view.frame WithCity:_city WithProvince:_province WithAddress:currentAddress];
        [self.view addSubview:_stationView];
        
        @weakify(self)
        
        [_stationView setRefreshStationListener:^(BOOL isRequestFailure) {
            @strongify(self)
            
            if (isRequestFailure) {// 点击刷新需要显示加载动画
                [self showHub];
            }
            
            self.currentPage = startPage - 1;
            [self stationList:1];
        }];
        
        [_stationView setLoadStationListener:^ {
            @strongify(self)
            
            [self stationList:1];
        }];
        
        [_stationView setSelectStationCellListener:^(id result) {
            @strongify(self)
            
            CarInspectStationInfoViewController * controller = [[CarInspectStationInfoViewController alloc]init];
            controller.stationModel = (CarInspectStationModel *)result;
            controller.carModel = self.carModel;
            [self basePushViewController:controller];
        }];
        
        [_stationView setRefreshListener:^(NSString *areaID, NSInteger value) {
            @strongify(self)
            
            self.areaid = areaID;
            if (value == 0) {               // 智能排序
                [self hideHub];
                self.currentPage = startPage - 1;
                [self stationList:1];
            } else if (value == 1) {        // 离我最近
                [self hideHub];
                self.currentPage = startPage - 1;
                [self stationList:1];
            } else if (value == 2) {        // 好评优先
                [self hideHub];
                self.currentPage = startPage - 1;
                [self stationList:2];
            } else if (value == 4) {        // 刷新
                self.currentPage = startPage - 1;
                [self hideHub];
                [self stationList:1];
            }
        }];
    }
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"StationListTag"]) {
        [_stationView endRefreshing];
        
        NSArray *models = [CarInspectStationModel convertFromArray:(NSArray *)result isCarInspectAgency:NO];
        
        // 没有回传最新当前页码，重新联网后的请求就会出错
        if (_currentPage <= startPage) {// 刷新
            _currentPage = startPage;// 因为网络请求失败了之后，_currentPage减1，则会出现小于startPage的情况
            [_stationView refreshDataSource:models];
            _dataArr = (NSMutableArray *)models;
        } else {// 加载
            [_stationView addDataSource:models page:_currentPage];
            [_dataArr addObjectsFromArray:models];
        }
        
        if (models.count < countPerPage) {  // 小于10跳数据，则就是最后一页数据了
            [_stationView removeFooter];    // 删除加载提示
        } else {
            [_stationView addFooter];
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self hideHub];
    [self showTextHubWithContent:tint];
    
    if ([tag isEqualToString:@"StationListTag"]) {
        [self hideHub];
        [_stationView endRefreshing];
        [_stationView hideFooter];
        
        if (_currentPage <= startPage) {// 刷新的时候才能展示nil界面
            [_stationView refreshDataSource:nil];
        } else {// 加载
            [_stationView addDataSource:@[] page:_currentPage];
        }
        
        _currentPage--;
    }
}

#pragma mark - 定位的城市信息
- (void) getAllcityInfoWithProvince:(NSString *)province city:(NSString *)city {
    [DES3Util getCityListWithCompletionBlock:^(NSMutableArray *cityArray) {
        NSArray<AreaModel *> *areaModels = [AreaModel convertFromArray:cityArray];
        
        for (AreaModel *areaModel in areaModels) {
            if ([areaModel.areaName containsString:province]) {
                NSArray<TownModel *> *townModels = areaModel.town;
                
                for (TownModel *townModel in townModels) {
                    
                    // 获取定位城市的model
                    if ([townModel.areaName containsString:city]) {
                        // 城市的区域列表
                        self.areaid = townModel.areaid;
                        self.currentPage = startPage - 1;
                        [self showHub];
                        [self stationList:1];
                        break;
                    }
                }
                
                break;
            }
        }
    }];
}

// 获取车检站列表
- (void) stationList:(int)sortKey {
    CLLocationDegrees latitude = [AppDelegate sharedDelegate].aMapLocationModel.latitude;
    CLLocationDegrees longitude = [AppDelegate sharedDelegate].aMapLocationModel.longitude;
    
    [self  showHubWithLoadText:@"加载中..."];
    
    // 请求下一页数据
    _currentPage++;
    [_carInspectNetData stationListWithLatitude:latitude longitude:longitude areaId:self.areaid
                                         pageId:_currentPage stationType:1 showCount:countPerPage
                                        sortKey:sortKey tag:@"StationListTag"];
}

#pragma mark - 搜索的点击事件

-(void)searchBtnClick {
    if (!self.areaid) {
        self.areaid = @"3401";
    }
    
    CarInspectSeachStationViewController * controller = [[CarInspectSeachStationViewController alloc]init];
    controller.areaID = self.areaid;
    controller.carModel = self.carModel;
    [self basePushViewController:controller];
}

#pragma mark - 车检站地图的点击事件

-(void)mapBtnClick{
    if (_dataArr.count>1) {
        CarInspectStationMapListViewController * controller = [[CarInspectStationMapListViewController alloc]init];
        controller.stationListArray = _dataArr;
        controller.value = 2;
        [self basePushViewController:controller];
    }
}

@end
