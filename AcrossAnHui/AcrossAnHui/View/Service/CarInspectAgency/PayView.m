//
//  PayView.m
//  AcrossAnHui
//
//  Created by ztd on 17/5/24.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "PayView.h"
#import "GZPayThirdTableViewCell.h"
@interface PayView ()<UITableViewDataSource,UITableViewDelegate>{
    CGFloat detailAddr_h;
    CGFloat sjDetailAdd_h;
    UITableView *_tableView;
    NSInteger _selectIndex;
    
    CGFloat h1;
    CGFloat h2;
    
    int reocdeToken;
}
@property (nonatomic,strong)NSUserDefaults *userDefault;
@property (nonatomic,strong)NSMutableArray *imageArray;//图片数组
@property (nonatomic,strong)UIButton *chooseButton;

@end

@implementation PayView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
        }
    return self;
}

-(void)createUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,self.bounds.size.width , self.bounds.size.height) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    [self addSubview:_tableView];
}

#pragma tableView的代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSArray *imageArray =[NSArray arrayWithObjects:@"ZFB.png",@"weixin.png", nil];
        NSArray *payNameArray = [NSArray arrayWithObjects:@"支付宝",@"微信", nil];
        NSArray *introlArray = [NSArray arrayWithObjects:@"推荐有支付宝账号的用户使用",@"推荐安装微信5.0及以上版本的用户使用",nil];
        
        static NSString *cellID = @"cell2";
        GZPayThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            
            cell = [[GZPayThirdTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.leftImageView.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
        cell.paylabel.text = [payNameArray objectAtIndex:indexPath.row];
        cell.introlabel.text = [introlArray objectAtIndex:indexPath.row];
        cell.introlabel.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
        [cell.selectButton setImage:[UIImage imageNamed:@"weigoux_car"] forState:UIControlStateNormal];
        
        cell.selectButton.tag = indexPath.row+1;
        [cell.selectButton setImage:[UIImage imageNamed:@"iconfont-gouxuan.png"] forState:UIControlStateSelected];
        [cell.selectButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.selectButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        if (cell.selectButton.tag == 1) {
            cell.selectButton.selected = YES;
            _selectIndex = cell.selectButton.tag;
            self.chooseButton = cell.selectButton;
        }
        return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
       return 75;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(void)payButtonClick:(UIButton*)payButton
{
    GZPayThirdTableViewCell *cell = (GZPayThirdTableViewCell *)[[[payButton superview] superview] superview] ;
    UIButton *lastButton = [cell viewWithTag:_selectIndex];
    
    lastButton.selected = NO;
    payButton.selected = YES;
    _selectIndex = payButton.tag;
    
    self.chooseButton = payButton;
    
    if (PayWay) {
        PayWay(_selectIndex);
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(void)setPayWay:(void (^)(NSInteger))listener
{
    PayWay = listener;

}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self createUI];
    }
    return self;
}


@end
