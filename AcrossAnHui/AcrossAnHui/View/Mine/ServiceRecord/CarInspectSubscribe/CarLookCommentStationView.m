//
//  CCarLookCommentStationView.m
//  AcrossAnHui
//
//  Created by ztd on 2017/8/10.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarLookCommentStationView.h"
#import "CarInspectThirdStationTableViewCell.h"
#import "MJRefresh.h"
#import "PromptView.h"
#import "CTXRefreshGifHeader.h"
#import "KLCDTextHelper.h"

@interface CarLookCommentStationView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView * tableView;
@property (nonatomic ,strong)NSMutableArray * dataArr;
@property (nonatomic ,strong)PromptView * promptView;

@end

@implementation CarLookCommentStationView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        //self.dataArr = [NSMutableArray array];
    }
    return self;
}

-(void)initUI{
    
    NSArray *titleArray = @[@"全部",@"晒图",@"差评"];
    NSArray *imageArray = @[@"",@"shait",@"chaping"];
    CGFloat buttonWidth = (CGRectGetWidth(self.frame)-(15*4))/titleArray.count;
    for (int i = 0; i<titleArray.count; i++) {
        UIButton *selectButton = [[UIButton alloc]initWithFrame:CGRectMake(15*(i+1)+i*buttonWidth, 15, buttonWidth,40)];
        selectButton.tag = i+1000;
        [self addSubview:selectButton];
        [selectButton setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        selectButton.imageEdgeInsets = UIEdgeInsetsMake(0,5,0,20);
        [selectButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [selectButton setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [selectButton setTitleColor:[UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1] forState:UIControlStateNormal];
        [selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        selectButton.layer.borderWidth = 0.5;
        [selectButton.layer setMasksToBounds:YES];
        selectButton.layer.cornerRadius = 5.0;
        selectButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [selectButton setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:0/255.0 green:163/255.0 blue:219/255.0 alpha:1]] forState:UIControlStateDisabled];
        [selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        
        if (i==0) {
            [selectButton setEnabled:NO];
        } else {
            [selectButton setEnabled:YES];
        }
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 134-64, CTXScreenWidth, self.frame.size.height-134)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    self.tableView.mj_header = [CTXRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshMoreNews)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreNews)];
    
}

-(void)selectButtonAction:(UIButton *)button{
    
    
    if (button.tag ==0+1000) {
        UIButton *button1 = (UIButton *)[self viewWithTag:1+1000];
        UIButton *button2 = (UIButton *)[self viewWithTag:2+1000];
        [button setEnabled:NO];
        [button1 setEnabled:YES];
        [button2 setEnabled:YES];
    } else if (button.tag ==1+1000){
        UIButton *button1 = (UIButton *)[self viewWithTag:0+1000];
        UIButton *button2 = (UIButton *)[self viewWithTag:2+1000];
        [button setEnabled:NO];
        [button1 setEnabled:YES];
        [button2 setEnabled:YES];
      
    } else if (button.tag ==2+1000){
        UIButton *button1 = (UIButton *)[self viewWithTag:1+1000];
        UIButton *button2 = (UIButton *)[self viewWithTag:0+1000];
        [button setEnabled:NO];
        [button1 setEnabled:YES];
        [button2 setEnabled:YES];
    }
    if (_selectBtnListener) {
        _selectBtnListener((int)button.tag);
    }
}

-(void)refreshCommentTotal:(NSString *)allTotal photoTotal:(NSString *)photoTotal badTotal:(NSString *)badTotal{
    UIButton *button1 = (UIButton *)[self viewWithTag:1+1000];
    UIButton *button2 = (UIButton *)[self viewWithTag:2+1000];
    NSString * str = [NSString stringWithFormat:@"晒图(%@)",photoTotal];
    NSString * str1 = [NSString stringWithFormat:@"差评(%@)",badTotal];
    [button1 setTitle:str forState:UIControlStateNormal];
    [button2 setTitle:str1 forState:UIControlStateNormal];
    
 
    button1.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,0);
    button2.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,0);

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"cell";
    CarInspectThirdStationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[CarInspectThirdStationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    StationCommentModel * model = _dataArr[indexPath.row];
    cell.model = model;
    if (_dataArr.count>0) {
        if (indexPath.row == _dataArr.count-1) {
            cell.lineLab.backgroundColor = [UIColor whiteColor];
        }else{
            cell.lineLab.backgroundColor = UIColorFromRGB(CTXBLineViewColor);

        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
        StationCommentModel *model = self.dataArr[indexPath.row];
        //  计算字体的高度
        CGFloat infoHeight = [KLCDTextHelper HeightForText:model.assessContent withFontSize:15 withTextWidth:CGRectGetWidth(self.frame)-20-5-20];
        if (model.evalImgList.count <1) {
            return 80+infoHeight;
        }
        return 80+80+infoHeight;
}


-(void)refreshMoreNews{
    if (refreshListener) {
        refreshListener();
    }
}

-(void)loadMoreNews{
    if (freshListener) {
        freshListener();
    }
}

-(void)refreshData:(NSArray *)dataArr{
    
    if (!dataArr) {
        if (self.dataArr && self.dataArr.count > 0) {
            return;
        }
        
        [self addNilNetDataView];
        [_promptView setRequestFailureImageView];
        
        return;
    }
    
    self.dataArr = (NSMutableArray *)dataArr;
    if (self.dataArr.count == 0) {
        [self addNilDataView];
        _promptView.frame = CGRectMake(0, 134-64, CTXScreenWidth, self.frame.size.height-134+64);
        [_promptView setNilDataWithImagePath:@"sb_1" tint:@"暂无评价" btnTitle:@""];
        @weakify(self)
        [_promptView setPromptRefreshListener:^{
            @strongify(self)
            if (self.refreshParkingRecordDataListener) {
                
                self.refreshParkingRecordDataListener(YES);
            }
            
        }];
    } else {
        if (_promptView) {
            [_promptView removeFromSuperview];
            _promptView = nil;
        }
        
        [self.tableView reloadData];
        
    }
    
    [self cancelRefresh];
    [self.tableView reloadData];
    
}

-(void)cancelRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}

- (void) addNilDataView {
    if (!_promptView) {
        _promptView = [[PromptView alloc] init];
        
        [self addSubview:_promptView];
//        [_promptView makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
//        }];
    }
}

- (void) addNilNetDataView {
    if (!_promptView) {
        _promptView = [[PromptView alloc] init];
        
        [self addSubview:_promptView];
        [_promptView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
}

-(void)setFreshListener:(void (^)())listener{
    
    freshListener = listener;
    
}

-(void)setRefreshListener:(void (^)())listener{
    
    refreshListener = listener;
}

#pragma mark - UIColor 转UIImage

- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
