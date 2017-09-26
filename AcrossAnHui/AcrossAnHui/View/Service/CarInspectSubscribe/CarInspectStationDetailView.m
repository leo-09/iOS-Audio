//
//  CarInspectStationDetailView.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectStationDetailView.h"
#import "CarInSpectStationDetailFootview.h"
#import "CarInpactStationImageFoodView.h"
#import "YYKit.h"
#import "CarInspectFirstTableViewCell.h"
#import "CarinSpectSecondStationTableViewCell.h"
#import "CarInspectThirdStationTableViewCell.h"
#import "UILabel+lineSpace.h"
#import "KLCDTextHelper.h"
#import "ServeTool.h"

@interface CarInspectStationDetailView()<UITableViewDelegate,UITableViewDataSource>{
    CarInspectStationModel * _model;
    CGFloat _height;
    int _value;
}

@property (nonatomic,strong)NSMutableArray *muArray;//显示数组
@end

@implementation CarInspectStationDetailView

- (instancetype)initWithFrame:(CGRect)frame WithModel:(CarInspectStationModel *)model viewValue:(int)value{
    if (self = [super initWithFrame:frame]) {
        _model = model;
        _value = value;
        _muArray = [[NSMutableArray alloc]init];
        [self initUI];
    }
    return self;
}

- (void) refreshDataSource:(NSArray *)data {
    
    if (data.count>0) {
        _muArray = (NSMutableArray *)data;
        [self.tableView reloadData];
    }
}

-(void)initUI{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CTXScreenWidth, self.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    
    [self.tableView registerClass:[CarInSpectStationDetailFootview class] forHeaderFooterViewReuseIdentifier:@"foodView"];
    [self.tableView registerClass:[CarInpactStationImageFoodView class] forHeaderFooterViewReuseIdentifier:@"foodviewImage"];
    
    
    UIImageView * headView = [[UIImageView alloc]init];
    headView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [headView setImageWithURL:[NSURL URLWithString:_model.stationPic] placeholder:[UIImage imageNamed:@"xiangq"]];
    headView.bounds =  CGRectMake(0, 0, CTXScreenWidth, CTXScreenWidth/2);
    self.tableView.tableHeaderView  = headView;
    [headView addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark UITableViewDelegate,UITableViewDataSource代理

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else{
        
        if (self.muArray.count>=2) {
            return 3;
        }
        return self.muArray.count+1;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        static  NSString * IdentifierID = @"firstcell";
        CarInspectFirstTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:IdentifierID];
        if (cell == nil) {
            cell = [[CarInspectFirstTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IdentifierID];
        }
        [cell.locationButton addTarget:self action:@selector(online) forControlEvents:UIControlEventTouchUpInside];
        [cell.phoneButton addTarget:self action:@selector(phoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
        cell.stationModel = _model;
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 1){
        static NSString * cellID = @"secondCell";
        CarinSpectSecondStationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[CarinSpectSecondStationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        [cell stationModel:_model value:_value];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 0){
        static NSString * cellID = @"Cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        UILabel * lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 43, CTXScreenWidth, 1)];
        lineLab.backgroundColor = CTXColor(201, 201, 201);
        [cell addSubview:lineLab];
        if ([_model.totalCount integerValue]>0) {
            cell.textLabel.text = [NSString stringWithFormat:@"用户评价(%@)",_model.totalCount];
        }else{
            cell.textLabel.text =  @"用户评价(0)";
        }
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        
        return  cell;
        
        
    }
    static NSString * IdentifierIDCell = @"thirdcell";
    CarInspectThirdStationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:IdentifierIDCell];
    if (!cell) {
        cell = [[CarInspectThirdStationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IdentifierIDCell];
    }
    
    cell.model = self.muArray[indexPath.row-1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_muArray.count>0) {
        cell.model = _muArray[indexPath.row-1];
        
        if (_muArray.count>1) {
            if (indexPath.row == 2) {
                cell.lineLab.backgroundColor = [UIColor whiteColor];
            } else {
                cell.lineLab.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
            }
        } else {
            cell.lineLab.backgroundColor = [UIColor whiteColor];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1&&self.muArray.count>=1) {
        CarInSpectStationDetailFootview *FootView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footView"];
        if (FootView == nil) {
            FootView = [[CarInSpectStationDetailFootview alloc]initWithReuseIdentifier:@"footView"];
        }
        [FootView.moreButton addTarget:self action:@selector(moreButtonAction) forControlEvents:UIControlEventTouchUpInside];
        return FootView;
    }
    
    if (section ==1&&self.muArray.count<1) {
        CarInpactStationImageFoodView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"foodviewImage"];
        if (footView == nil) {
            footView = [[CarInpactStationImageFoodView alloc]initWithReuseIdentifier:@"foodviewImage"];
        }
        return footView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0)
    {
        return 10;
    }
    if (self.muArray.count<1) {
        return 200;
    }
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return  80;
        
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        UILabel * lab = [[UILabel alloc]init];
        lab.text = _model.stationAddr;
        lab.numberOfLines = 0;
        lab.font = [UIFont systemFontOfSize:14];
        CGFloat ff = [lab getLabelHeightWithLineSpace:5 WithWidth:CTXScreenWidth-30 WithNumline:0].height;
        
        NSMutableArray *array = [NSMutableArray array];
        if (_value == 1) {
            for (CarInspectCarType*checkCarlist in _model.carTypeList) {
                
                [array addObject:checkCarlist.carTypeName];
            }

        } else {
            for (CarInspectCarType*checkCarlist in _model.carTypeList) {
                
                [array addObject:checkCarlist.dictname];
            }

        
        }
        
        NSString *totalString = [array componentsJoinedByString:@","];
        NSString * str = [NSString stringWithFormat:@"检测车辆类型:%@",totalString];
        UILabel * lab1 = [[UILabel alloc]init];
        lab1.text = str;
        lab1.numberOfLines = 0;
        lab1.font = [UIFont systemFontOfSize:14];
        CGFloat ff1 = [lab1 getLabelHeightWithLineSpace:5 WithWidth:CTXScreenWidth-25 WithNumline:0].height;
      
        _height = ff1;
        return _height+165-20+ff+5;
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        return 44;
    }else{
        
        StationCommentModel *model = self.muArray[indexPath.row -1];

        //  计算字体的高度
        CGFloat infoHeight = [KLCDTextHelper HeightForText:model.assessContent withFontSize:14 withTextWidth:CGRectGetWidth(self.frame)-45];
        if (model.evalImgList.count <1) {
            return 80+infoHeight;
        }
        return 80+80+infoHeight;
        
    }
}

#pragma mark -查看更多界面

- (void)moreButtonAction{
    if (stationListener) {
        stationListener(2);
    }
}

//点击了电话按钮
-(void)phoneButtonClick{
    [ServeTool callPhone:_model.stationTel];
}

//点击表头视图的手势
-(void)tapClick
{
    if (stationListener) {
        stationListener(1);
    }
}

//地图
-(void)online{
    if (stationListener) {
        stationListener(3);
    }
}


-(void)setStationListener:(void (^)(NSInteger))listener{
    stationListener = listener;
}
-(void)sertstationLocationListener:(void (^)(id))listener{
    stationLocationListener = listener;
}
@end
