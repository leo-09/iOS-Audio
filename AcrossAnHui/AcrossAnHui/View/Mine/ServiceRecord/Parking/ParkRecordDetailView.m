//
//  ParkRecordDetailView.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ParkRecordDetailView.h"
#import "ParkRecordTableViewCell.h"
#import "UILabel+lineSpace.h"
#import "Masonry.h"

@interface ParkRecordDetailView ()<UITableViewDataSource,UITableViewDelegate>{
    UIView * foodView ;
}

@property (nonatomic ,retain)UITableView * tableView;
@property (nonatomic ,retain)NSMutableArray * dataArr;

@end

@implementation ParkRecordDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = CTXColor(244, 244, 244);
        _dataArr = [NSMutableArray array];
        [self initUI];
    }
    
    return self;
}

-(void)initUI {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CTXScreenWidth, CTXScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
}

-(void)freshData:(NSArray *)dataArr {
    _dataArr = (NSMutableArray *)dataArr;
    [self.tableView reloadData];
    ParkRecordModel * model = _dataArr[0];
    if ([model.isPay isEqualToString:@"1"]) {
        [self createFoodView];
    } else {
        if (foodView) {
            [foodView removeFromSuperview];
            foodView = nil;
        }
    }
}

-(void)createFoodView {
    foodView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CTXScreenWidth, 100)];
    self.tableView.tableFooterView = foodView;
    
    UIButton * payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [foodView addSubview:payBtn];
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@15);
        make.right.equalTo(@(-12));
        make.height.equalTo(@40);
    }];
    payBtn.layer.cornerRadius = 5;
    payBtn.layer.masksToBounds = YES;
    [payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBtn.backgroundColor = CTXColor(3, 163, 214);
    [payBtn addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)payClick {
    if (selectCellListener) {
        selectCellListener();
    }
}

#pragma mark UITableViewDataSource,UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ParkRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ParkRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    ParkRecordModel * model = _dataArr[indexPath.row];
    
    cell.model = model;
    if ([model.isPay isEqualToString:@"1"]) {
        cell.payStatusLab.textColor = [UIColor redColor];
    } else {
        cell.payStatusLab.textColor = CTXColor(108, 108, 108);
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ParkRecordModel * model = _dataArr[indexPath.row];
    UILabel * lab = [[UILabel alloc]init];
    lab.text = model.sitename;
    lab.font = [UIFont systemFontOfSize:15];
    CGFloat hight = [lab getLabelHeightWithLineSpace:10 WithWidth:CTXScreenWidth-12-20-10-12 WithNumline:0].height;
    return 200+hight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  0.01;
}

-(void)setSelectCellListener:(void (^)())listener{
    selectCellListener = listener;
}

@end
