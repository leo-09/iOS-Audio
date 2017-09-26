//
//  CarInspectStationInfoViewController.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectStationInfoViewController.h"
#import "CarInspectStationDetailView.h"
#import "CarInspectNetData.h"
#import "StationCommentModel.h"
#import "CarInspetAppointmentViewController.h"
#import "CarInspectStationAlbumViewController.h"
#import "CarInspectStationMapListViewController.h"
#import "ShowEvaluateViewController.h"

@interface CarInspectStationInfoViewController ()
@property (nonatomic ,retain)CarInspectStationDetailView * detailView;
@property (nonatomic, retain) CarInspectNetData *carInspectNetData;
@end

@implementation CarInspectStationInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"车检站信息";
    _carInspectNetData = [[CarInspectNetData alloc] init];
    _carInspectNetData.delegate = self;
    [self initUI];
    [_carInspectNetData queryStationCommentWithStationID:_stationModel.stationid assessStar:@"5" pageId:@"0" showCount:@"8" isContainImg:@"3" tag:@"stationComment"];
}

-(void)initUI{
    _detailView = [[CarInspectStationDetailView alloc]initWithFrame:CGRectMake(0, 0, CTXScreenWidth, CTXScreenHeight-64-56) WithModel:_stationModel viewValue:1];
    [self.view addSubview:_detailView];
    @weakify(self)
    [_detailView setStationListener:^(NSInteger value) {
        @strongify(self)
        if (value == 1) {
            CarInspectStationAlbumViewController * controller = [[CarInspectStationAlbumViewController alloc]init];
            controller.stationid = self.stationModel.stationid;
            [self basePushViewController:controller];
            //跳转到车检站相册
        }else if (value == 2){
            //跳转到查看更多
            ShowEvaluateViewController * controller = [[ShowEvaluateViewController alloc]init];
            controller.stationID = self.stationModel.stationid;
            [self basePushViewController:controller];
        }else{
            // 地图
            NSMutableArray * arr = [NSMutableArray array];
            [arr addObject:self.stationModel];
            
            CarInspectStationMapListViewController * controller = [[CarInspectStationMapListViewController alloc]init];
            controller.value = 1;
            controller.stationListArray = arr;
            [self basePushViewController:controller];
        }
    }];
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, CTXScreenHeight-56-64, CTXScreenWidth, 56)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel * bottomLineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CTXScreenWidth, 1)];
    bottomLineLab.backgroundColor = CTXColor(201, 201, 201);
    [bgView addSubview:bottomLineLab];
    
    UILabel * orderPriceLab = [[UILabel alloc]initWithFrame:CGRectMake(12.5, 20, 85, 20)];
    orderPriceLab.font = [UIFont systemFontOfSize:15];
    orderPriceLab.text = @"预约价格：";
    [bgView addSubview:orderPriceLab];
    
    UILabel * priceLab =[[UILabel alloc]initWithFrame:CGRectMake(55+27, 15, 80, 30)];
    priceLab.font = [UIFont systemFontOfSize:15];
   // priceLab.textAlignment = NSTextAlignmentRight;
    priceLab.textColor = CTXColor(254, 110, 0);
    CGFloat price = [_stationModel.cjPrice floatValue];
    priceLab.text = [NSString stringWithFormat:@"%0.2f元",price];
    [bgView addSubview:priceLab];
    
    UIButton * orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    orderBtn.frame = CGRectMake(CTXScreenWidth-(CTXScreenWidth*0.35)-15, 15, CTXScreenWidth*0.35, 30);
    orderBtn.layer.borderWidth = 1;
    orderBtn.layer.borderColor = CTXColor(3, 163, 214).CGColor;
    [orderBtn setTitle:@"我要预约" forState:UIControlStateNormal];
    [orderBtn setTitleColor:CTXColor(3, 163, 214) forState:UIControlStateNormal];
    [orderBtn  addTarget:self action:@selector(desireBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:orderBtn];
    
}

//我要预约
-(void)desireBtnClick{
    CarInspetAppointmentViewController * controller = [[CarInspetAppointmentViewController alloc]initWithStoryboard];
    controller.model = _stationModel;
    controller.carModel = self.carModel;
    [self basePushViewController:controller];
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
