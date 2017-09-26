//
//  CarInspectTimeView.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectTimeView.h"
#import "CarInspectOrderDateTableViewCell.h"
#import "StationOrderTime.h"

@implementation CarInspectTimeView

- (instancetype)initWithFrame:(CGRect)frame arr:(NSArray *)arr{
    if (self = [super initWithFrame:frame]) {
        
        UIView * bgview =[[UIView alloc]initWithFrame:self.frame];
        bgview.backgroundColor = [UIColor blackColor];
        bgview.alpha = 0.3;
        [self addSubview:bgview];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissView:)];
        tap.cancelsTouchesInView = false;
        [bgview addGestureRecognizer:tap];
         
        _dataSource = [[NSMutableArray alloc]init];
         [_dataSource addObjectsFromArray:arr];
        [self initUI];
    }
    return self;
}

-(void)initUI{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(23, 15+64, CTXScreenWidth-46, self.dataSource.count*44+62) style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.layer.cornerRadius = 10;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.userInteractionEnabled = true;
    [self addSubview:self.tableView];
    
   
    
    UIView *dateheaderView1 = [[UIView alloc] init];
    dateheaderView1.bounds = CGRectMake(0, 0, CTXScreenWidth-46, 62);
    dateheaderView1.tintColor = [UIColor cyanColor];
    UIView *dateheaderView2 = [[UIView alloc] init];
    dateheaderView2.bounds = CGRectMake(0, 0, CTXScreenWidth-46, 62);
    dateheaderView2.tintColor = [UIColor cyanColor];
    _tableView.tableHeaderView = dateheaderView1;
    _tableView.tableFooterView = dateheaderView2;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissView:)];
    tap.cancelsTouchesInView = NO;
    [dateheaderView1 addGestureRecognizer:tap];
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissView:)];
    tap1.cancelsTouchesInView = NO;
    [dateheaderView2 addGestureRecognizer:tap1];
    
    UILabel *orderheaderlabel = [[UILabel alloc] init];
    orderheaderlabel.text = @"预约时间段";
    orderheaderlabel.font = [UIFont systemFontOfSize:15];
    orderheaderlabel.frame = CGRectMake(0, 21, CTXScreenWidth-46, 20);
    orderheaderlabel.textAlignment = NSTextAlignmentCenter;
    [dateheaderView1 addSubview:orderheaderlabel];
    
    UILabel *carlinelabel = [[UILabel alloc] init];
    carlinelabel.frame = CGRectMake(0, 61, CTXScreenWidth-46, 1);
    carlinelabel.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0];
    [dateheaderView1 addSubview:carlinelabel];

}

- (void) refreshDataSource:(NSArray *)data {
    
    if (data.count>0) {
        [self.tableView reloadData];
    }
}

#pragma tableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StationOrderTime *stationOrderTime = self.dataSource[indexPath.row];
    static NSString *cellID = @"cell";
    CarInspectOrderDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CarInspectOrderDateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.orderDatelabel.text = [NSString stringWithFormat:@"%@-%@",stationOrderTime.startTime,stationOrderTime.endTime];
    cell.orderDatelabel.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    StationOrderTime *stationOrderTime = self.dataSource[indexPath.row];
    if (self.selectStationCellListener) {
        self.selectStationCellListener(stationOrderTime);
    }
   // self..text = [NSString stringWithFormat:@"%@-%@",stationOrderTime.startTime,stationOrderTime.endTime];
    [self removeFromSuperview];
}



-(void)dismissView:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
}

@end
