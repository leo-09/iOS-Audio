//
//  CarInspectAgencyViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectAgencyViewController.h"
#import "Masonry.h"
#import "NearbyStationView.h"

#import "NetURLManager.h"
#import "DES3Util.h"
#import "CarInspectAgencyLocationViewController.h"
#import "CarInspectNetData.h"
#import "UILabel+lineSpace.h"
#import "PromptView.h"
#import "CarInspectStationModel.h"
#import "CarInspectAgencyStationInfoViewController.h"

@interface CarInspectAgencyViewController (){
    
    NearbyStationView * stationListView;
    UILabel * currentAddressLab;
    UIView * noStationView;

    CGSize size ;
    NSString * _city;//当前所在城市
    NSString * _province;//当前所在省
   
}

@property (nonatomic,retain)CarInspectNetData * carInspectNet;
@property (nonatomic,retain)PromptView * promotView;
@property (nonatomic,assign)double latStr;
@property (nonatomic,assign)double lngStr;
@property (nonatomic,copy) NSString * currentAddress;

@end

@implementation CarInspectAgencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    _carInspectNet = [[CarInspectNetData alloc]init];
    _carInspectNet.delegate = self;
    self.title = @"车检站";
    [self createNavUI];
    [self initUI];
    [self getLoctationInfo];

}

#pragma mark - 获取定位信息
-(void)getLoctationInfo{
    [self startUpdatingLocationWithBlock:^{
        _latStr = [AppDelegate sharedDelegate].aMapLocationModel.latitude;
        _lngStr = [AppDelegate sharedDelegate].aMapLocationModel.longitude;
        _currentAddress = [AppDelegate sharedDelegate].aMapLocationModel.formattedAddress;
        currentAddressLab.text = [NSString stringWithFormat:@"当前位置:%@",_currentAddress];
        size = [currentAddressLab getLabelHeightWithLineSpace:3 WithWidth:CTXScreenWidth-25 WithNumline:0];
        currentAddressLab.frame = CGRectMake(12.5, 15, self.view.frame.size.width-25, size.height);
        stationListView.frame = CGRectMake(0, 30+size.height, CTXScreenWidth, CTXScreenHeight-30-size.height);
        [self.carInspectNet queryNearbyStatationWithLatitude:_latStr longitude:_lngStr pageId:@"1" from:@"App" showCount:@"10" tag:@"nearbyStation"];
    }];
}

#pragma 导航左右按钮
-(void)createNavUI{
    //导航栏右侧按钮
    [self customRightBarButton];
}

#pragma  自定义右边按钮
-(void)customRightBarButton{
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    UIBarButtonItem * addressRight = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    rightView.backgroundColor = [UIColor clearColor];
    self.navigationItem.rightBarButtonItem = addressRight;
    
    UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 2.5, 15, 20)];
    imageview.image = [UIImage imageNamed:@"db_location"];
    [rightView addSubview:imageview];
    
    UILabel * changeAddressLab = [[UILabel alloc]initWithFrame:CGRectMake(22, 2, 65, 20)];
    changeAddressLab.text = @"更改位置";
    changeAddressLab.textColor = [UIColor whiteColor];
    [rightView addSubview:changeAddressLab];
    changeAddressLab.font =  [UIFont systemFontOfSize:15];
    
    UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(22+65, 8, 15, 9)];
    img.image = [UIImage imageNamed:@"db_more"];
    [rightView addSubview:img];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
    tap.cancelsTouchesInView = NO;
    [rightView addGestureRecognizer:tap];
}

#pragma - MARK 导航右侧按钮的触摸方法
-(void)tapGesture{
    CarInspectAgencyLocationViewController * controller = [[CarInspectAgencyLocationViewController alloc] init];
    
    @weakify(self)
    [controller setCallBackBlock:^(NSString *text, NSString * lat ,NSString * lng){
        @strongify(self)
        
        if (text == nil || [text isEqualToString:@""]) {
            return ;
        } else {
            _latStr = lat.doubleValue;
            _lngStr = lng.doubleValue;
            self.currentAddress = text;
            currentAddressLab.text = [NSString stringWithFormat:@"当前位置:%@",text];
            size = [currentAddressLab getLabelHeightWithLineSpace:3 WithWidth:CTXScreenWidth-25 WithNumline:0];
            currentAddressLab.frame = CGRectMake(12.5, 15, self.view.frame.size.width-25, size.height);
            
            stationListView.frame = CGRectMake(0, 30+size.height, CTXScreenWidth, CTXScreenHeight-30-size.height);
            [self.carInspectNet queryNearbyStatationWithLatitude:self.latStr longitude:self.lngStr pageId:@"1" from:@"App" showCount:@"10" tag:@"nearbyStation"];
        }
    }];
    
    [self basePushViewController:controller];
}

#pragma - MARK  初始化界面
-(void)initUI{
    
    currentAddressLab = [[UILabel alloc]init];
    [self.view addSubview:currentAddressLab];
    currentAddressLab.font = [UIFont systemFontOfSize:13];
    currentAddressLab.text = @"";
    currentAddressLab.numberOfLines = 0;
    currentAddressLab.textColor = CTXColor(108, 108, 108);
    
    self.automaticallyAdjustsScrollViewInsets=false;
    stationListView = [[NearbyStationView alloc]initWithFrame:CGRectMake(0, 30+size.height, CTXScreenWidth, CTXScreenHeight-30-size.height)];
    [self.view addSubview:stationListView];
    @weakify(self)
    [stationListView setStationListener:^(CarInspectStationModel *model) {
        @strongify(self)
        CarInspectAgencyStationInfoViewController * controller = [[CarInspectAgencyStationInfoViewController alloc]init];
        controller.stationModel = model;
        controller.carModel = self.carModel;
        controller.latStr = self.latStr;
        controller.lngStr = self.lngStr;
        controller.addressStr = self.currentAddress;
        [self basePushViewController:controller];
    }];
}

-(void)nearbyNotStationViewUI{
    if (noStationView == nil) {
        noStationView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, CTXScreenWidth, CTXScreenHeight-45)];
        noStationView.backgroundColor = CTXColor(244, 244, 244);
        [self.view addSubview:noStationView];
    }
    
    UILabel * notenameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, CTXScreenWidth, 20)];
    notenameLab.text = @"附近没有合作的车检站";
    notenameLab.textAlignment = NSTextAlignmentCenter;
    notenameLab.font = [UIFont systemFontOfSize:18];
    [noStationView addSubview:notenameLab  ];
}

#pragma mark - CTXNetDataDelegate
- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    if ([tag isEqualToString:@"nearbyStation"]) {
        // 处理数据结果
        
        NSMutableArray * arr = [NSMutableArray array];
        NSArray * dataArr = (NSArray *)result;
        if (self.promotView) {
            [self.promotView removeFromSuperview];
            self.promotView = nil;
        }
        if (noStationView) {
            [noStationView removeFromSuperview];
        }
        if (dataArr.count<1) {
            [self nearbyNotStationViewUI];
            return;
        }
        NSArray * models = (NSArray *)[CarInspectStationModel convertFromArray:dataArr isCarInspectAgency:NO];
        [arr addObjectsFromArray:models];
        [stationListView refreshDataArr:arr];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    if (self.promotView==nil) {
        self.promotView = [[PromptView alloc]initWithFrame:CGRectMake(0, 0, CTXScreenWidth, CTXScreenHeight)];
        [self.view addSubview:self.promotView];
        [self.promotView setRequestFailureImageView];
        @weakify(self)
        [self.promotView setPromptRefreshListener:^{
            @strongify(self)
            [self.carInspectNet queryNearbyStatationWithLatitude:self.latStr longitude:self.lngStr pageId:@"1" from:@"App" showCount:@"10" tag:@"nearbyStation"];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
