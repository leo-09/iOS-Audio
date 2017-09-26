//
//  NearbyStationView.m
//  AcrossAnHui
//
//  Created by ztd on 17/6/8.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "NearbyStationView.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "GZStationTableViewCell.h"
#import "CWStarRateView.h"
#import "DES3Util.h"
#import "NetURLManager.h"
#import "CarInspectStationModel.h"
#import "YYKit.h"

@interface NearbyStationView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSUserDefaults *userDefault;
@property (nonatomic,strong)UIViewController *controller;
@end

@implementation NearbyStationView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.stationArray = [[NSMutableArray alloc]init];
        self.controller = [self viewController];
        [self initUI];
         //[self initData];
    }
    return self;
}
-(void)initUI{

    self.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    [self headView];
}
- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initUI];
       // [self initData];
    }
    return self;
}

-(void)refreshDataArr:(NSMutableArray *)stationArry{
    _stationArray = stationArry;
    [self.tableView reloadData];

}
-(void)headView{
    UIView * bgview =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, CTXScreenWidth, 45)];
    bgview.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    self.tableView.tableHeaderView = bgview;
  
    UIView * labView = [[UIView alloc]init];
    labView.backgroundColor = [UIColor whiteColor];
    [bgview addSubview:labView];
    labView.frame = CGRectMake(0, 0, CTXScreenWidth, 43.5);
   
    UILabel * noteLab = [[UILabel alloc]init];
    [labView addSubview:noteLab];
  
    noteLab.frame = CGRectMake(12.5, 15, CTXScreenWidth-25, 13);
    noteLab.textColor = UIColorFromRGB(CTXBaseFontColor);
    noteLab.font = [UIFont systemFontOfSize:12];
    noteLab.text = @"系统已为您推荐最近车检站";
}

-(void)refreshAddress{


}
#pragma tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
       return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
       return self.stationArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString *cellID = @"cell";
        GZStationTableViewCell *cell = [[GZStationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CarInspectStationModel *stationlist = self.stationArray[indexPath.row];
        [cell.stationBackView setImageWithURL:[NSURL URLWithString:stationlist.stationPic] placeholder:[UIImage imageNamed:@"zet-1.png"]];
        cell.stationNamelabel.text = stationlist.stationName;
        cell.stationplacelabel.text = stationlist.stationAddr;
        cell.evaluatelabel.text = [NSString stringWithFormat:@"%@条评价",stationlist.totalCount];
        cell.evaluatelabel.font = [UIFont systemFontOfSize:15];
        cell.evaluatelabel.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
        ;
        cell.distanceView.image = [UIImage imageNamed:@"iconfont-sevenbabicon.png"];
        
        cell.distanceLabel.text = [NSString stringWithFormat:@"%@km",stationlist.distance];
        CWStarRateView *bar = [[CWStarRateView alloc] initWithFrame:CGRectMake(135.5,35, self.frame.size.width*0.35, 15)];
    
        bar.scorePercent = [stationlist.avgStar floatValue]/5;
        [cell addSubview:bar];
        
        
        if ([stationlist.isCanOnlinePay isEqualToString:@"1"] ) {
            if ([stationlist.personyh isEqualToString:@"0"]) {
                cell.zhifuView.image=[UIImage imageNamed:@"zhifu_chejian"];
                cell.zhifuLabel.text=@"支持线上支付";
                cell.lineLab.backgroundColor=[UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0];
            } else {
                cell.zhifuView.image=[UIImage imageNamed:@"zhifu_chejian"];
                cell.zhifuLabel.text=@"支持线上支付";
                cell.lineLab.backgroundColor=[UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0];
                cell.GoodsView.image=[UIImage imageNamed:@"jianmian_chejian"];
                NSString * str = [NSString stringWithFormat:@"线上支付减%@元",stationlist.personyh];
                cell.GoodsLabel.text=str;
            }
        }
        return cell;
}

//点击cell的代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarInspectStationModel *stationlist = self.stationArray[indexPath.row];
    if (stationListener) {
        stationListener(stationlist);
    }
}

-(void)setStationListener:(void (^)(CarInspectStationModel *))listener{
        stationListener = listener;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 114;
    
}

@end
