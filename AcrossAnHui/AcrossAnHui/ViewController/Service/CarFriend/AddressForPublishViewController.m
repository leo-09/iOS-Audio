//
//  AddressForPublishViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "AddressForPublishViewController.h"
#import "CTXRefreshGifFooter.h"
#import "CAddressForPublishcell.h"

static int offset = 30;

@interface AddressForPublishViewController () {
    BOOL isSelectAnno;  // 是否选择某个点
}

@property (nonatomic, retain) NSMutableArray *annotations;

@property (nonatomic, retain) CarFriendMAPointAnnotation * currentAnno;
@property (nonatomic, retain) NSIndexPath *selectIndexPath;             // 选中的NSIndexPath

@end

@implementation AddressForPublishViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.annotations = [[NSMutableArray alloc] init];
    isSelectAnno = NO;
    
    self.navigationItem.title = @"位置";
    
    // rightBarButtonItem
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(sureAddress)];
    [rightBarButtonItem setTintColor:[UIColor whiteColor]];
    NSDictionary *dict = @{ NSFontAttributeName: [UIFont systemFontOfSize:CTXTextFont] };
    [rightBarButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    _aMapSearchAPI = [[AMapSearchAPI alloc] init];
    _aMapSearchAPI.delegate = self;
    
    [self addMapView];
    [self addTableView];
    [self addCenterImageView];
}

// 确定当前位置
- (void) sureAddress {
    if (self.selectAnno) {
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:CurrentAddressNotificationName object:self.selectAnno userInfo:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self showTextHubWithContent:@"请选择具体的位置"];
    }
}

#pragma mark - MAMapViewDelegate

// 地图移动结束后调用此接口
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    [self centerAnnotationAnimimate];
    
    if (isSelectAnno) {
        isSelectAnno = NO;
        return;
    }
    
    // 清除原来的点
    [self.annotations removeAllObjects];
    [self removeFooter];
    self.currentPage = 0;

    // 第一个默认是当前位置的点
    if (self.currentAnno) {
        self.currentAnno.isSelected = YES;
        [self.annotations addObject:self.currentAnno];
        
        // 默认选择第一个地址
        self.selectAnno = self.currentAnno;
        self.selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    [self.tableView reloadData];
    
    [self searchPoiWithCenterCoordinate:self.mapView.centerCoordinate];
}

#pragma mark - AMapSearchDelegate

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    // 信息检索错误
    [self hideHub];
    [self.tableView.mj_footer endRefreshing];
    
    [self showTextHubWithContent:@"信息检索错误, 请重新切换位置"];
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    [self hideHub];
    [self.tableView.mj_footer endRefreshing];
    
    // 默认一页搜索30个记录
    if (response.pois.count < offset) {
        [self removeFooter];
    } else {
        [self addFooter];
    }
    
    // 添加最新的点
    for (AMapPOI *aPOI in response.pois) {
        CarFriendMAPointAnnotation *anno = [[CarFriendMAPointAnnotation alloc] init];
        anno.coordinate = CLLocationCoordinate2DMake(aPOI.location.latitude, aPOI.location.longitude);
        anno.title = aPOI.name;
        
        anno.province = aPOI.province;
        anno.city = aPOI.city;
        anno.district = aPOI.district;
        anno.address = aPOI.address;
        anno.longitude = aPOI.location.longitude;
        anno.latitude = aPOI.location.latitude;
        
        [self.annotations addObject:anno];
    }
    
    // 更新UI
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.annotations.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CAddressForPublishcell *cell = [CAddressForPublishcell cellWithTableView:tableView];
    cell.anno = self.annotations[indexPath.row];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 更新原来选中的点
    if (self.selectAnno) {
        self.selectAnno.isSelected = NO;
        
        if (self.selectIndexPath) {
            [self.tableView reloadRowAtIndexPath:self.selectIndexPath withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
    // 更新UI
    self.selectAnno = self.annotations[indexPath.row];
    self.selectAnno.isSelected = YES;
    self.selectIndexPath = indexPath;
    [self.tableView reloadRowAtIndexPath:self.selectIndexPath withRowAnimation:UITableViewRowAnimationNone];
    
    // 地图中心点
    isSelectAnno = YES;
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(self.selectAnno.coordinate.latitude, self.selectAnno.coordinate.longitude);
}

#pragma mark - 搜索

/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiWithCenterCoordinate:(CLLocationCoordinate2D )coord {
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location = [AMapGeoPoint locationWithLatitude:coord.latitude  longitude:coord.longitude];
    request.sortrule = 0;       // 距离排序
    request.offset = offset;    // 每页记录数
    request.page = self.currentPage++;
    request.requireExtension = YES; // 返回扩展信息
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    request.types = @"汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
    
    [self.aMapSearchAPI AMapPOIAroundSearch:request];
}

// 设置当前位置的点
- (void) setCurrentAnno {
    CLLocationDegrees latitude = [AppDelegate sharedDelegate].aMapLocationModel.latitude;
    CLLocationDegrees longitude = [AppDelegate sharedDelegate].aMapLocationModel.longitude;
    
    self.currentAnno = [[CarFriendMAPointAnnotation alloc] init];
    self.currentAnno.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    self.currentAnno.title = @"[当前位置]";
    self.currentAnno.address = [[AppDelegate sharedDelegate].aMapLocationModel areaAddress];
}

#pragma mark - view

- (void)addMapView {
    self.mapView = [[MAMapView alloc] init];
    [self.view addSubview:self.mapView];
    [self.mapView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo((CTXScreenHeight - CTXNavigationBarHeight - CTXBarHeight) / 2);
    }];
    
    self.mapView.delegate = self;
    self.mapView.zoomLevel = 15;
    self.mapView.showTraffic = NO;
    self.mapView.showsCompass = NO;
    self.mapView.rotateEnabled = NO;
    self.mapView.rotateCameraEnabled = NO;
    self.mapView.showsScale = NO;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    // 定位
    [self startUpdatingLocationWithBlock:^{
        [self setCurrentAnno];
        
        CLLocationDegrees latitude = [AppDelegate sharedDelegate].aMapLocationModel.latitude;
        CLLocationDegrees longitude = [AppDelegate sharedDelegate].aMapLocationModel.longitude;
        self.mapView.centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    }];
}

- (void) addTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 55;
    [self.tableView registerClass:[CAddressForPublishcell class] forCellReuseIdentifier:@"CAddressForPublishcell"];
    
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapView.bottom);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
}

- (void) addCenterImageView {
    self.iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wateRedBlank"]];
    [self.view addSubview:self.iv];
    [self.iv makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo((CTXScreenHeight - CTXNavigationBarHeight - CTXBarHeight) / 4 - 28);
    }];
}

// 移动窗口弹一下的动画
- (void)centerAnnotationAnimimate {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGPoint center = self.iv.center;
        center.y -= 20;
        [self.iv setCenter:center];
    } completion:nil];
    
    [UIView animateWithDuration:0.45 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGPoint center = self.iv.center;
        center.y += 20;
        [self.iv setCenter:center];
    } completion:nil];
}

- (void) removeFooter {
    self.tableView.mj_footer = nil;
}

- (void) addFooter {
    if (!self.tableView.mj_footer) {
        self.tableView.mj_footer = [CTXRefreshGifFooter footerWithRefreshingBlock:^{
            [self searchPoiWithCenterCoordinate:self.mapView.centerCoordinate];
        }];
    }
}

@end
