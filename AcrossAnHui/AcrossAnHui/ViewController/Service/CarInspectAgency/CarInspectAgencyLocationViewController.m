//
//  CarInspectAgencyLocationViewController.m
//  AcrossAnHui
//
//  Created by ztd on 2017/8/2.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectAgencyLocationViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <MAMapKit/MAMapView.h>
#import <AMapSearchKit/AMapSearchKit.h>
//#import "PlaceAroundTableView.h"
#import "DBMapTabView.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface CarInspectAgencyLocationViewController ()<AMapSearchDelegate, MAMapViewDelegate, PlaceAroundTableViewDeleagate,UITextFieldDelegate> {
    UITextField * searchField;
    
}
@property (nonatomic, strong) MAMapView            *mapView;
@property (nonatomic, strong) AMapSearchAPI        *search;


@property (nonatomic, strong) UIImageView          *centerAnnotationView;
@property (nonatomic, assign) BOOL                  isMapViewRegionChangedFromTableView;

@property (nonatomic, assign) BOOL                  isLocated;
@property (nonatomic, strong) DBMapTabView *tableview;
@property (nonatomic, strong) UIButton             *locationBtn;
@property (nonatomic, strong) UIImage              *imageLocated;
@property (nonatomic, strong) UIImage              *imageNotLocate;
@property (nonatomic, assign) NSInteger             searchPage;
@property (nonatomic, strong) UISegmentedControl    *searchTypeSegment;
@property (nonatomic, copy) NSString               *currentType;
@property (nonatomic, copy) NSArray                *searchTypes;
@property (nonatomic, copy) NSString               *selectAddress;
@property (nonatomic, copy) NSString               *selectLat;
@property (nonatomic, copy) NSString               *selectLNG;

@end

@implementation CarInspectAgencyLocationViewController

/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiWithCenterCoordinate:(CLLocationCoordinate2D )coord
{
    AMapPOIAroundSearchRequest*request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location = [AMapGeoPoint locationWithLatitude:coord.latitude  longitude:coord.longitude];
    
    request.radius   = 1000;
    request.types = self.currentType;
    request.sortrule = 0;
    request.page     = self.searchPage;
    
    [self.search AMapPOIAroundSearch:request];
}

- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
}

#pragma mark - MapViewDelegate

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (!self.isMapViewRegionChangedFromTableView && self.mapView.userTrackingMode == MAUserTrackingModeNone)
    {
        [self actionSearchAroundAt:self.mapView.centerCoordinate];
    }
    self.isMapViewRegionChangedFromTableView = NO;
    
}

#pragma mark - TableViewDelegate

- (void)didTableViewSelectedChanged:(AMapPOI *)selectedPoi
{
    // 防止连续点两次
    if(self.isMapViewRegionChangedFromTableView == YES)
    {
        return;
    }
    
    self.isMapViewRegionChangedFromTableView = YES;
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(selectedPoi.location.latitude, selectedPoi.location.longitude);
    
    [self.mapView setCenterCoordinate:location animated:YES];
    self.selectAddress = selectedPoi.name;
    self.selectLat = [NSString stringWithFormat:@"%f",selectedPoi.location.latitude];
    self.selectLNG = [NSString stringWithFormat:@"%f",selectedPoi.location.longitude];
}

- (void)didPositionCellTapped
{
    // 防止连续点两次
    if(self.isMapViewRegionChangedFromTableView == YES)
    {
        return;
    }
    
    self.isMapViewRegionChangedFromTableView = YES;
    
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
    self.selectAddress = self.currentAddress;
    self.selectLat = [NSString stringWithFormat:@"%0.6f",self.mapView.userLocation.coordinate.latitude];
    self.selectLNG = [NSString stringWithFormat:@"%0.6f",self.mapView.userLocation.coordinate.longitude];
}

- (void)didLoadMorePOIButtonTapped
{
    self.searchPage++;
    [self searchPoiWithCenterCoordinate:self.mapView.centerCoordinate];
}

#pragma mark - userLocation

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(!updatingLocation)
        return ;
    
    if (userLocation.location.horizontalAccuracy < 0)
    {
        return ;
    }
    
    // only the first locate used.
    if (!self.isLocated)
    {
        self.isLocated = YES;
        self.mapView.userTrackingMode = MAUserTrackingModeFollow;
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
        
        [self actionSearchAroundAt:userLocation.location.coordinate];
    }
}

- (void)mapView:(MAMapView *)mapView  didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated
{
    if (mode == MAUserTrackingModeNone)
    {
        [self.locationBtn setImage:self.imageNotLocate forState:UIControlStateNormal];
    }
    else
    {
        [self.locationBtn setImage:self.imageLocated forState:UIControlStateNormal];
    }
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"error = %@",error);
}

#pragma mark - Handle Action

- (void)actionSearchAroundAt:(CLLocationCoordinate2D)coordinate
{
    [self searchReGeocodeWithCoordinate:coordinate];
    [self searchPoiWithCenterCoordinate:coordinate];
    
    self.searchPage = 1;
    [self centerAnnotationAnimimate];
}

- (void)actionLocation
{
    if (self.mapView.userTrackingMode == MAUserTrackingModeFollow)
    {
        [self.mapView setUserTrackingMode:MAUserTrackingModeNone animated:YES];
    }
    else
    {
        self.searchPage = 1;
        
        [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            // 因为下面这句的动画有bug，所以要延迟0.5s执行，动画由上一句产生
            [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        });
    }
}

- (void)actionTypeChanged:(UISegmentedControl *)sender
{
    self.currentType = self.searchTypes[sender.selectedSegmentIndex];
    [self actionSearchAroundAt:self.mapView.centerCoordinate];
}

#pragma mark - Initialization

- (void)initMapView
{
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), self.view.bounds.size.height/2)];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    self.isLocated = NO;
}

- (void)initSearch
{
    self.searchPage = 1;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self.tableview;
}

- (void)initTableview
{
    self.tableview = [[DBMapTabView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height/2-64, CGRectGetWidth(self.view.bounds), self.view.bounds.size.height/2-70)];
    self.tableview.delegate = self;
    
    [self.view addSubview:self.tableview];
}

- (void)initCenterView
{
    self.centerAnnotationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wateRedBlank"]];
    self.centerAnnotationView.center = CGPointMake(self.mapView.center.x, self.mapView.center.y - CGRectGetHeight(self.centerAnnotationView.bounds) / 2);
    
    [self.mapView addSubview:self.centerAnnotationView];
}

- (void)initLocationButton
{
    self.imageLocated = [UIImage imageNamed:@"gpssearchbutton"];
    self.imageNotLocate = [UIImage imageNamed:@"gpsnormal"];
    
    self.locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.mapView.bounds) - 40, CGRectGetHeight(self.mapView.bounds) - 50, 32, 32)];
    self.locationBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.locationBtn.backgroundColor = [UIColor whiteColor];
    
    self.locationBtn.layer.cornerRadius = 3;
    [self.locationBtn addTarget:self action:@selector(actionLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.locationBtn setImage:self.imageNotLocate forState:UIControlStateNormal];
    [self.view addSubview:self.locationBtn];
}

- (void)initSearchTypeView
{
    self.searchTypes = @[@"住宅", @"学校", @"楼宇", @"商场"];
    
    self.currentType = self.searchTypes.firstObject;
    
    self.searchTypeSegment = [[UISegmentedControl alloc] initWithItems:self.searchTypes];
    self.searchTypeSegment.frame = CGRectMake(10, CGRectGetHeight(self.mapView.bounds) - 50, CGRectGetWidth(self.mapView.bounds) - 80, 32);
    self.searchTypeSegment.layer.cornerRadius = 3;
    self.searchTypeSegment.backgroundColor = [UIColor whiteColor];
    self.searchTypeSegment.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.searchTypeSegment.selectedSegmentIndex = 0;
    [self.searchTypeSegment addTarget:self action:@selector(actionTypeChanged:) forControlEvents:UIControlEventValueChanged];
    // [self.view addSubview:self.searchTypeSegment];
    
}

/* 移动窗口弹一下的动画 */
- (void)centerAnnotationAnimimate
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGPoint center = self.centerAnnotationView.center;
                         center.y -= 20;
                         [self.centerAnnotationView setCenter:center];}
                     completion:nil];
    
    [UIView animateWithDuration:0.45
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGPoint center = self.centerAnnotationView.center;
                         center.y += 20;
                         [self.centerAnnotationView setCenter:center];}
                     completion:nil];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // self.title = @"位置";
    [self initTableview];
    
    [self initSearch];
    [self initMapView];
    
}

-(void)selectRightAction
{
    
    _callBackBlock(_selectAddress,self.selectLat,self.selectLNG);
    [self.navigationController popViewControllerAnimated:true];
    
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initCenterView];
    [self initLocationButton];
    [self initSearchTypeView];
    [self initSearchView];
    self.mapView.zoomLevel = 17;
    self.mapView.showsUserLocation = YES;
    [self initBottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)close:(id)sender{
    [super close:sender];
    [self.mapView removeFromSuperview];
    self.mapView.delegate = self;
    self.mapView = nil;
}

-(void)initSearchView
{
    //260/320.0
    UIView * searchView1 = [[UIView alloc]init];
    searchView1.center = self.navigationItem.titleView.center;
    searchView1.bounds = CGRectMake(0, 0, (260/320.0*self.view.frame.size.width), 35);
    self.navigationItem.titleView = searchView1;
    searchView1.backgroundColor = [UIColor clearColor];
    
    UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (260/320.0*self.view.frame.size.width)-60, 35)];
    [searchView1 addSubview:searchView];
    searchView.backgroundColor = [UIColor whiteColor];
    
    UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 22, 22)];
    img.image = [UIImage imageNamed:@"search_6"];
    [searchView addSubview:img];
    
    searchField = [[UITextField alloc]initWithFrame:CGRectMake(27, 10, 150, 15)];
    searchField.placeholder = @"请输入要搜索的地名";
    searchField.font = [UIFont systemFontOfSize:14];
    searchField.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
    [searchView addSubview:searchField];
    searchField.tag = 10;
    searchField.delegate = self;
    UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setImage:[UIImage imageNamed:@"iconfont-quxiao"] forState:UIControlStateNormal];
    but.frame = CGRectMake((260/320.0*self.view.frame.size.width)-90, 5, 25, 25);
    [but addTarget:self action:@selector(clierBtn) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:but];
    // but.imageEdgeInsets=UIEdgeInsetsMake(5, 5, 5, 5);
    
    
    UIButton * Searchbut = [UIButton buttonWithType:UIButtonTypeCustom];
    Searchbut.frame = CGRectMake((260/320.0*self.view.frame.size.width)-60, 5, 50, 25);
    Searchbut.titleLabel.font = [UIFont systemFontOfSize:15];
    [Searchbut setTitle:@"搜索" forState:UIControlStateNormal];
    [Searchbut addTarget:self action:@selector(searchBtn) forControlEvents:UIControlEventTouchUpInside];
    [Searchbut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchView1 addSubview:Searchbut];
}

-(void)clierBtn
{
    searchField.text = @"";
}

-(void)searchBtn
{
    [searchField resignFirstResponder];
    if (searchField.text.length<1) {
        [self showTextHubWithContent:@"请输入关键字"];
        
        return ;
    }
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"City"] == nil) {
        [self updateSearchResultsForSearchController:@"合肥市"];
    }else{
        
        [self updateSearchResultsForSearchController:[[NSUserDefaults standardUserDefaults]objectForKey:@"City"]];
    }
}

-(void)initBottomView
{
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-70, self.view.frame.size.width, 70)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(tiJiaoClick) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor colorWithRed:3/255.0 green:163/255.0 blue:214/255.0 alpha:1.0];
    [bottomView addSubview:button];
    button.frame = CGRectMake(12.5, 15, self.view.frame.size.width-25, 40);
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    
}

-(void)tiJiaoClick{
    _callBackBlock(_selectAddress,self.selectLat,self.selectLNG);
    [self.navigationController popViewControllerAnimated:true];
}

-(void)updateSearchResultsForSearchController:(NSString *)city{
    if (_search==nil) {
        self.search = [[AMapSearchAPI alloc] init];
    }
    
    self.search.delegate = self;
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.keywords=searchField.text;
    request.city    = city;
    
    request.requireExtension    = YES;
    
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    //    request.cityLimit           = YES;
    //    request.requireSubPOIs      = YES;
    [self.search AMapPOIKeywordsSearch:request];
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    NSMutableArray *searchList = [NSMutableArray array];
    for (AMapPOI *p in response.pois) {
        //把搜索结果存在数组
        [searchList addObject:p];
        NSLog(@"%@",p.name);
    }
    [self.tableview getSearchdata:searchList];
    //解析response获取POI信息，具体解析见 Demo
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    return YES;
}

- (BOOL) gestureRecognizerShouldBegin {
    return NO;  // 关闭侧滑
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"Error: %@", error);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
