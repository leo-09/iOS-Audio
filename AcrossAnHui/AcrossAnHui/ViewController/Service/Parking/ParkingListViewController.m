//
//  ParkingListViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ParkingListViewController.h"
#import "ParkingInfoViewController.h"
#import "YZPullDownMenu.h"
#import "CParkingListView.h"
#import "ParkingNetData.h"

#define startPage 1

@interface ParkingListViewController ()<YZPullDownMenuDataSource> {
    YZPullDownMenu *menu;
}

@property (nonatomic, retain) CParkingListView *parkingListView;
@property (nonatomic, retain) ParkingNetData *parkingNetData;

@end

@implementation ParkingListViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"附近停车位";
    // rightBarButtonItem
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_map"] style:UIBarButtonItemStyleDone target:self action:@selector(close:)];
    [rightBarButtonItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    // 初始化标题
    titles = @[ @"区域选择", @"道路选择", @"智能排序" ];
    // 排序规则：1:离我最近;2:费用最低;3:空座最多;4:最多人停
    sortTitles = @[ @"离我最近", @"费用最低", @"空座位多", @"最多人停" ];
    
    // 创建下拉菜单
    menu = [[YZPullDownMenu alloc] init];
    menu.dataSource = self;// 设置下拉菜单代理
    [self.view addSubview:menu];
    [menu makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(@0);
        make.width.equalTo(CTXScreenWidth);
        make.height.equalTo(YZPullDownMenuHeight);
    }];
    
    [self setupAllChildViewController];// 添加子控制器
    
    [self.view addSubview:self.parkingListView];
    [self.parkingListView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(menu.bottom);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    // 更新下拉菜单标题通知名称
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMenuTitleNote:) name:YZUpdateMenuTitleNote object:nil];
    
    _parkingNetData = [[ParkingNetData alloc] init];
    _parkingNetData.delegate = self;
    
    [self showHub];
    [self selectAreaGroupList];
    [self defaultQueryParkList];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [menu dismissByViewController];
}

// 移除观察者
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) defaultQueryParkList {
    // 请求默认条件的 停车位列表数据
    _currentArea = [[ParkingAreaModel alloc] init];
    _currentArea.areacode = @"";
    
    _currentRoad = [[ParkingRoadModel alloc] init];
    _currentRoad.roadID = @"";
    
    _currentSmart = [[ParkingRoadModel alloc] init];
    _currentSmart.roadID = @"";
    
    _currentPage = startPage - 1;
    [self queryParkList];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"selectAreaGroupListTag"]) {
        NSMutableArray *areas = [ParkingAreaModel convertFromArray:result];
        
        // 添加 '全部' 标示的区域
        ParkingAreaModel *model = [[ParkingAreaModel alloc] init];
        model.areaname = @"全部";
        model.areacode = @"";
        model.siteList = [[NSMutableArray alloc] init];
        [areas insertObject:model atIndex:0];
        
        // _areaSortController
        _areaSortController.titleArray = areas;
        
        //_roadSortController
        if (areas.count > 0) {
            ParkingAreaModel *areaModel = areas.firstObject;
            _roadSortController.titleArray = areaModel.siteList;
        }
        
        // smartSortController
        NSMutableArray *sorts = [[NSMutableArray alloc] init];
        for (int i = 0; i < sortTitles.count; i++) {
            ParkingRoadModel *sortModel = [[ParkingRoadModel alloc] init];
            sortModel.sitename = sortTitles[i];
            sortModel.roadID = [NSString stringWithFormat:@"%d", (i + 1)];
            
            [sorts addObject:sortModel];
        }
        _smartSortController.titleArray = sorts;
        _currentSmart = sorts[0];
    }
    
    if ([tag isEqualToString:@"selectSiteListTag"]) {
        [_parkingListView endRefreshing];
        
        int totalPage = [result[@"totalPage"] intValue];
        _currentPage = [result[@"currentPage"] intValue];// 获取最新的当前页，重新联网后的请求就不会出错了
        NSArray *siteList = [SiteModel convertFromArray:result[@"siteList"]];
        
        if (_currentPage <= startPage) {// 刷新
            _currentPage = startPage;// 因为网络请求失败了之后，_currentPage减1，则会出现小于startPage的情况
            [_parkingListView refreshDataSource:siteList];
        } else {
            [_parkingListView addDataSource:siteList page:_currentPage];
        }
        
        if (_currentPage >= totalPage) {
            [_parkingListView removeFooter];// 删除加载提示
        } else {
            [_parkingListView addFooter];
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"selectSiteListTag"]) {
        [_parkingListView endRefreshing];
        [_parkingListView hideFooter];
        
        if (_currentPage <= startPage) {
            [_parkingListView refreshDataSource:nil];
        } else {
            [_parkingListView addDataSource:@[] page:_currentPage];
        }
        
        _currentPage--;
    }
}

#pragma mark - netWork

// 查询所有区域及对应的路段分组
- (void) selectAreaGroupList {
    [_parkingNetData selectAreaGroupListWithCityName:self.cityName tag:@"selectAreaGroupListTag"];
}

// 查询附近列表页
- (void) queryParkList {
    // 请求下一页数据
    _currentPage++;
    [_parkingNetData selectSiteListWithSiteID:_currentRoad.roadID siteName:@""
                                     areacode:_currentArea.areacode sorttype:_currentSmart.roadID
                                    longitude:_coordinate.longitude latitude:_coordinate.latitude
                                         page:_currentPage tag:@"selectSiteListTag"];
}

#pragma mark - getter/setter

- (CParkingListView *) parkingListView {
    if (!_parkingListView) {
        _parkingListView = [[CParkingListView alloc] init];
        
    }
    
    @weakify(self)
    [_parkingListView setSelectListener:^(id result) {
        @strongify(self);
        
        SiteModel *model = (SiteModel *) result;
        
        ParkingInfoViewController * controller = [[ParkingInfoViewController alloc] init];
        controller.siteID = model.siteID;
        controller.siteName = model.sitename;
        controller.coordinate = self.coordinate;
        [self basePushViewController:controller];
    }];
    
    [_parkingListView setRefreshParkDataListener:^(BOOL isRequestFailure) {
        @strongify(self);
        
        if (isRequestFailure) {
            [self showHub];
        }
        
        self.currentPage = startPage - 1;
        [self queryParkList];
    }];
    [_parkingListView setLoadParkDataListener:^{
        @strongify(self);
        [self queryParkList];
    }];
    
    return _parkingListView;
}

#pragma mark - 添加子控制器

- (void)setupAllChildViewController {
    _areaSortController = [[YZSortViewController alloc] init];
    _areaSortController.ctxTag = @"areaSort";
    _roadSortController = [[YZSortViewController alloc] init];
    _roadSortController.ctxTag = @"roadSort";
    _smartSortController = [[YZSortViewController alloc] init];
    _smartSortController.ctxTag = @"smartSort";
    
    [self addChildViewController:_areaSortController];
    [self addChildViewController:_roadSortController];
    [self addChildViewController:_smartSortController];
}

// 更新下拉菜单标题
- (void) updateMenuTitleNote:(NSNotification *)noti {
    if (noti.object == _areaSortController) {
        // 获取选中的区域model
        _currentArea = (ParkingAreaModel *) noti.userInfo[YZUpdateMenuTitleDictKey];
        // 展示区域对应的道路列表
        _roadSortController.titleArray = _currentArea.siteList;
        
        // 默认 道路
        _currentRoad = [[ParkingRoadModel alloc] init];
    } else if (noti.object == _roadSortController) {
        _currentRoad = (ParkingRoadModel *) noti.userInfo[YZUpdateMenuTitleDictKey];
    } else {
        _currentSmart = (ParkingRoadModel *) noti.userInfo[YZUpdateMenuTitleDictKey];
    }
    
    // 是否每次选择都需要重新请求数据
    _currentPage = startPage - 1;
    [self queryParkList];
}

#pragma mark - YZPullDownMenuDataSource

// 返回下拉菜单多少列
- (NSInteger)numberOfColsInMenu:(YZPullDownMenu *)pullDownMenu {
    return 3;
}

// 返回下拉菜单每列按钮
- (UIButton *)pullDownMenu:(YZPullDownMenu *)pullDownMenu buttonForColAtIndex:(NSInteger)index {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [button setTitle:titles[index] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(CTXThemeColor) forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:@"iconfont_xl"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"iconfont_xld"] forState:UIControlStateSelected];
    
    return button;
}

// 返回下拉菜单每列对应的控制器
- (UIViewController *)pullDownMenu:(YZPullDownMenu *)pullDownMenu viewControllerForColAtIndex:(NSInteger)index {
    return self.childViewControllers[index];
}

// 返回下拉菜单每列对应的高度
- (CGFloat)pullDownMenu:(YZPullDownMenu *)pullDownMenu heightForColAtIndex:(NSInteger)index {
    return CTXScreenHeight / 2;
}

@end
