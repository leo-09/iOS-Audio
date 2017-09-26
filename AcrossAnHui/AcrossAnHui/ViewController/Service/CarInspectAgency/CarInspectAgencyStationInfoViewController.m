//
//  CarInspectAgencyStationInfoViewController.m
//  AcrossAnHui
//
//  Created by ztd on 2017/8/2.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectAgencyStationInfoViewController.h"

#import "CarInspectStationDetailView.h"
#import "CarInspectNetData.h"
#import "StationCommentModel.h"
#import "CarInspetAppointmentViewController.h"
#import "CarInspectStationAlbumViewController.h"
#import "CarInspectStationMapListViewController.h"
#import "DBStationInfoBottomView.h"
#import "CarInspectAgencySubmitViewController.h"
#import "ShowEvaluateViewController.h"

@interface CarInspectAgencyStationInfoViewController ()

@property (nonatomic ,retain)CarInspectStationDetailView * detailView;
@property (nonatomic, retain) CarInspectNetData *carInspectNetData;

@end

@implementation CarInspectAgencyStationInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"车检站信息";
    _carInspectNetData = [[CarInspectNetData alloc] init];
    _carInspectNetData.delegate = self;
    [self initUI];
    [_carInspectNetData queryStationCommentWithStationID:_stationModel.stationid assessStar:@"5" pageId:@"0" showCount:@"8" isContainImg:@"3" tag:@"stationComment"];
    [self createBottomView];
}

-(void)initUI{
    _detailView = [[CarInspectStationDetailView alloc]initWithFrame:CGRectMake(0, 0, CTXScreenWidth, CTXScreenHeight-64-130) WithModel:_stationModel viewValue:2];
    [self.view addSubview:_detailView];
    @weakify(self)
    [_detailView setStationListener:^(NSInteger value) {
        @strongify(self)
        if (value == 1) {
            // 跳转到车检站相册
            CarInspectStationAlbumViewController * controller = [[CarInspectStationAlbumViewController alloc]init];
            controller.stationid = self.stationModel.stationid;
            [self basePushViewController:controller];
        }else if (value == 2){
            //跳转到查看更多
            ShowEvaluateViewController * controller = [[ShowEvaluateViewController alloc]init];
            controller.stationID = self.stationModel.stationid;
            [self basePushViewController:controller];
        }else{
            //地图
            NSMutableArray * arr = [NSMutableArray array];
            [arr addObject:self.stationModel];
            
            CarInspectStationMapListViewController * controller = [[CarInspectStationMapListViewController alloc]init];
            controller.value = 1;
            controller.stationListArray = arr;
            [self basePushViewController:controller];
        }
    }];
    
}

#pragma 创建底部界面
-(void)createBottomView{
    DBStationInfoBottomView * view = [[DBStationInfoBottomView alloc]initWithFrame:CGRectMake(0, CTXScreenHeight-130-64, CTXScreenWidth, 130)];
    view.StationModel = self.stationModel;
    [self.view addSubview:view];
    @weakify(self)
    [view setCallWay:^{
        @strongify(self)
        CarInspectAgencySubmitViewController * controller = [[CarInspectAgencySubmitViewController alloc]initWithStoryboard];
        controller.stationModel = self.stationModel;
        controller.carModel = self.carModel;
        controller.latStr = self.latStr;
        controller.lngStr = self.lngStr;
        controller.addressStr = self.addressStr;
        [self basePushViewController:controller];
    }];
    
}

#pragma mark - CTXNetDataDelegate
- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"stationComment"]) {
        // 处理数据结果
        
        NSMutableArray * arr = [NSMutableArray array];
        for (NSDictionary * dic in (NSArray *)result) {
            StationCommentModel *models = [StationCommentModel convertFromDict:dic];
            [arr addObject:models];
        }
        [_detailView  refreshDataSource:arr];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
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
