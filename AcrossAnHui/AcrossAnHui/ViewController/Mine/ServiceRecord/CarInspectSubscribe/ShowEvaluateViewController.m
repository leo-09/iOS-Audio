//
//  ShowEvaluateViewController.m
//  AcrossAnHui
//
//  Created by ztd on 2017/8/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ShowEvaluateViewController.h"
#import "CarLookCommentStationView.h"
#import "CarInspectNetData.h"

@interface ShowEvaluateViewController (){
    int rememberSelectValue;
    int totalPage;
    NSString * allTotalCount;
    NSString * photoTotalCount;
    NSString * badTotalCount;
}

@property (nonatomic ,retain)CarLookCommentStationView * commentView;
@property (nonatomic ,retain)CarInspectNetData * carInspectNetData;
@property (nonatomic ,assign)int currentPage;
@property (nonatomic ,retain)NSMutableArray * dataArr;

@end

@implementation ShowEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    rememberSelectValue = 1000;
    self.dataArr = [NSMutableArray array];
    
    self.navigationItem.title = @"评价";
    self.view.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    
    [self initUI];
    
    [self showHubWithLoadText:@"查询中..."];
    
    _carInspectNetData = [[CarInspectNetData alloc]init];
    _carInspectNetData.delegate = self;
    
    [self.carInspectNetData queryStationEvaluateCountWithStationID:self.stationID tag:@"EvaluateCountTag"];
    [self.carInspectNetData queryStationCommentWithStationID:self.stationID assessStar:@"5" pageId:@"0" showCount:@"10" isContainImg:@"3" tag:@"commentTag"];
}

-(void)initUI{
    _commentView = [[CarLookCommentStationView alloc]initWithFrame:CGRectMake(0, 0, CTXScreenWidth, CTXScreenHeight)];
    [self.view addSubview:_commentView];
    @weakify(self)
    [_commentView setSelectBtnListener:^(int value){
        @strongify(self)
        rememberSelectValue = value;
        NSString * page = [NSString stringWithFormat:@"%d",self.currentPage];
        if (value==1000) {
        [self.dataArr removeAllObjects];
        [self.carInspectNetData queryStationCommentWithStationID:self.stationID assessStar:@"5" pageId:page showCount:@"10" isContainImg:@"3" tag:@"commentTag"];
        }
        
        if (value==1001) {
            
        if (!photoTotalCount&&[photoTotalCount isEqualToString:@"0"]) {
                [self.commentView refreshData:@[]];
                return ;
        }
        [self.dataArr removeAllObjects];
        [self.carInspectNetData queryStationCommentWithStationID:self.stationID assessStar:@"5" pageId:page showCount:@"10" isContainImg:@"1" tag:@"commentTag"];
        }
        
        if (value==1002) {
        if (!badTotalCount&&[badTotalCount isEqualToString:@"0"]) {
                [self.commentView refreshData:@[]];
                return ;
        }
        [self.dataArr removeAllObjects];
        [self.carInspectNetData queryStationCommentWithStationID:self.stationID assessStar:@"2" pageId:page showCount:@"10" isContainImg:@"3" tag:@"commentTag"];
        }
    
    }];
   
    [_commentView setRefreshParkingRecordDataListener:^(BOOL isFailure){
        @strongify(self);
        
        self.currentPage = 0;
        NSString * page = [NSString stringWithFormat:@"%d",self.currentPage];
        if (rememberSelectValue==1000) {
            [self.carInspectNetData queryStationCommentWithStationID:self.stationID assessStar:@"5" pageId:page showCount:@"10" isContainImg:@"3" tag:@"commentTag"];
        }
        
        if (rememberSelectValue==1001) {
            [self.carInspectNetData queryStationCommentWithStationID:self.stationID assessStar:@"5" pageId:page showCount:@"10" isContainImg:@"1" tag:@"commentTag"];
        }
        
        if (rememberSelectValue==1002) {
            [self.carInspectNetData queryStationCommentWithStationID:self.stationID assessStar:@"2" pageId:page showCount:@"10" isContainImg:@"3" tag:@"commentTag"];
        }
    }];
    
    //上拉加载
    [_commentView setFreshListener:^{
        @strongify(self)
           self.currentPage = self.currentPage + 1;
            NSString * page = [NSString stringWithFormat:@"%d",self.currentPage];
            if (rememberSelectValue==1000) {
                
                [self.carInspectNetData queryStationCommentWithStationID:self.stationID assessStar:@"5" pageId:page showCount:@"10" isContainImg:@"3" tag:@"commentTag"];
            }
            
            if (rememberSelectValue==1001) {
                [self.carInspectNetData queryStationCommentWithStationID:self.stationID assessStar:@"5" pageId:page showCount:@"10" isContainImg:@"1" tag:@"commentTag"];
            }
            
            if (rememberSelectValue==1002) {
                [self.carInspectNetData queryStationCommentWithStationID:self.stationID assessStar:@"2" pageId:page showCount:@"10" isContainImg:@"3" tag:@"commentTag"];
            }
        
    }];
    //下拉刷新
    [_commentView setRefreshListener:^{
      @strongify(self)
        self.currentPage = 0;
        [self.dataArr removeAllObjects];
        NSString * page = [NSString stringWithFormat:@"%d",self.currentPage];
        if (rememberSelectValue==1000) {
            [self.carInspectNetData queryStationCommentWithStationID:self.stationID assessStar:@"5" pageId:page showCount:@"10" isContainImg:@"3" tag:@"commentTag"];
        }
        
        if (rememberSelectValue==1001) {
            [self.carInspectNetData queryStationCommentWithStationID:self.stationID assessStar:@"5" pageId:page showCount:@"10" isContainImg:@"1" tag:@"commentTag"];
        }
        
        if (rememberSelectValue==1002) {
            [self.carInspectNetData queryStationCommentWithStationID:self.stationID assessStar:@"2" pageId:page showCount:@"10" isContainImg:@"3" tag:@"commentTag"];
        }
    }];
}

#pragma mark - CTXNetDataDelegate
- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [self hideHub];
    [super querySuccessWithTag:tag result:result tint:tint];
    [self.commentView cancelRefresh];

    if ([tag isEqualToString:@"commentTag"]) {
        // 处理数据结果
        NSArray *models = [StationCommentModel convertFromArray:(NSArray *)result];
        [self.dataArr addObjectsFromArray:models];
        if (models.count<10) {
           // [self showTextHubWithContent:@"已经是最后一页了"];
        }
        if (self.dataArr.count<1) {
            [self.commentView  refreshData:@[]];
            
            return ;
        }
        [self.commentView  refreshData:self.dataArr];
    }
    
    if ([tag isEqualToString:@"EvaluateCountTag"]) {
        NSArray * arr = (NSArray *)result;
        if (arr.count==3) {
            NSDictionary * dic1 = arr[0];
            allTotalCount = dic1[@"totalCount"];
            NSDictionary * dic2 = arr[1];
            photoTotalCount = dic2[@"totalCount"];
            NSDictionary * dic3 = arr[2];
            badTotalCount = dic3[@"totalCount"];
            [self.commentView refreshCommentTotal:allTotalCount photoTotal:photoTotalCount badTotal:badTotalCount];
            NSString * titleStr = [NSString stringWithFormat:@"评价(%@)",allTotalCount];
            self.title = titleStr;
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    [self hideHub];
    [self.commentView cancelRefresh];

    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    
    if ([tag isEqualToString:@"commentTag"]) {
         [self.commentView refreshData:nil];
    }
   
}

@end
