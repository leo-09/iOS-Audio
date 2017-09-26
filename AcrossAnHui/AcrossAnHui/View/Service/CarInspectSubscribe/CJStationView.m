 //
//  CJStationView.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/3.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CJStationView.h"
#import "CJStationTableViewCell.h"
#import "DES3Util.h"
#import "CapacityTableViewCell.h"
#import "KLCDTextHelper.h"

@interface CJStationView()<UITableViewDelegate,UITableViewDataSource> {
    UIView * bgView;
    NSString * currentStr;
}

@property(nonatomic,strong)NSUserDefaults *userDefault;
@property (nonatomic,strong)UIViewController *controller;
@property (nonatomic,retain)UITableView * CitytableView;
@property (nonatomic,retain)UITableView * DistancetableView;
@property (nonatomic,strong)UILabel *currLocation;
@property (nonatomic,retain)NSMutableArray * quArray;
@property (nonatomic,assign)int value;
@property (nonatomic,retain)NSString* areaID;

@end

@implementation CJStationView

- (instancetype)initWithFrame:(CGRect)frame WithCity:(NSString *)cityStr WithProvince:(NSString *)provinceStr WithAddress:(NSString *)currentAddress{
    if (self = [super initWithFrame:frame]) {
        _value = 0;
        self.dataSource = [NSMutableArray array];
        self.citystring = cityStr;
        self.province = provinceStr;
        currentStr = currentAddress;
        self.backgroundColor = [UIColor clearColor];
        self.quArray = [NSMutableArray array];
        [self getCityInfo];
        _areaID = [_quArray[0] objectForKey:@"areaid"];
        NSLog(@"%@",_areaID);
        [self createUI];
    }
    return self;
}
-(void)getCityInfo{
    
    [DES3Util getCityListWithCompletionBlock:^(NSMutableArray *cityArray) {
        NSArray *array;
        for(int i = 0; i < cityArray.count; i++) {
            if ([_province isEqualToString:[cityArray[i] objectForKey:@"areaName"]]) {
                array = [cityArray[i] objectForKey:@"town"];
                
                for (int j = 0; j < [array count]; j++) {
                    if ([[array[j] objectForKey:@"areaName"]isEqualToString:_citystring]) {
                        
                        NSDictionary *cityDic = @{@"areaid" : [array[j] objectForKey:@"areaid"],
                                                  @"areaName" : [array[j] objectForKey:@"areaName"]};
                        
                        [self.quArray addObject:cityDic];
                        [self.quArray addObjectsFromArray:[array[j]objectForKey:@"village"]];
//                            self.qArray = [array[j] objectForKey:@"village"];
                    }
                }
                
            }
        }
    }];
    
}

-(void)createUI{
    //页面上部选择部分
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CTXScreenWidth, 55)];
    selectView.backgroundColor = [UIColor whiteColor];
    [self addSubview:selectView];
    
    
    UIButton *cityButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CTXScreenWidth/2, 55)];
    cityButton.tag = 1;
    [cityButton setTitle:_citystring forState:UIControlStateNormal];
    cityButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cityButton setTitleEdgeInsets:UIEdgeInsetsMake(20, -15, 20, 5)];
    [cityButton setImage:[UIImage imageNamed:@"select_date"] forState:UIControlStateNormal];
    
    CGFloat textWidth = [KLCDTextHelper WidthForText:_citystring withFontSize:CTXTextFont withTextHeight:CTXScreenWidth];
    
    // UIButton的titleEdgeInsets和imageEdgeInsets属性 设置
    cityButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    cityButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // imageView在右 titleLabel在左
    [cityButton setImageEdgeInsets:UIEdgeInsetsMake(0, (CTXScreenWidth/2 - textWidth) / 2 + textWidth, 0, 0)];
    [cityButton setTitleEdgeInsets:UIEdgeInsetsMake(0, (CTXScreenWidth/2 - textWidth) / 2 - 20, 0, 0)];
    //[cityButton setImageEdgeInsets:UIEdgeInsetsMake(20, 45+15+20+18, 20, 5)];
    [cityButton addTarget:self action:@selector(cityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:cityButton];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(CTXScreenWidth/2-0.5, 2, 1, 51)];
    lineLabel.backgroundColor = [UIColor colorWithRed:201.0/255.0 green:201.0/255.0 blue:201.0/255.0 alpha:1.0];
    [selectView addSubview:lineLabel];
    
    
    UIButton *rankButton = [[UIButton alloc] initWithFrame:CGRectMake(CTXScreenWidth/2, 0, CTXScreenWidth/2,55)];
    rankButton.tag = 2;
    
    [rankButton setTitle:@"智能排序" forState:UIControlStateNormal];
    rankButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rankButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [rankButton setTitleEdgeInsets:UIEdgeInsetsMake(20, -15, 20, 10)];
    NSString * rankStr = @"智能排序";
    CGFloat ranktextWidth = [KLCDTextHelper WidthForText:rankStr withFontSize:CTXTextFont withTextHeight:CTXScreenWidth];
    
    // UIButton的titleEdgeInsets和imageEdgeInsets属性 设置
    rankButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    rankButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // imageView在右 titleLabel在左
    [rankButton setImageEdgeInsets:UIEdgeInsetsMake(0, (CTXScreenWidth/2 - ranktextWidth) / 2 + ranktextWidth, 0, 0)];
    [rankButton setTitleEdgeInsets:UIEdgeInsetsMake(0, (CTXScreenWidth/2 - ranktextWidth) / 2 - 20, 0, 0)];
    [rankButton setImage:[UIImage imageNamed:@"select_date"] forState:UIControlStateNormal];
    //[rankButton setImageEdgeInsets:UIEdgeInsetsMake(20, 45+15+20+18+8, 20, 28)];
    [rankButton addTarget:self action:@selector(rankButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:rankButton];
    
    UIView *bjView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, CTXScreenWidth, 40)];
    bjView.backgroundColor = UIColorFromRGB(CTXBackGroundColor);
    [self addSubview:bjView];
    
    _currLocation = [[UILabel alloc] init];
    _currLocation.font = [UIFont systemFontOfSize:12];
    [bjView addSubview:_currLocation];
    _currLocation.frame = CGRectMake(7,15, CTXScreenWidth-28, 15);
    _currLocation.text = currentStr;
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CTXScreenWidth-25, 15, 14, 12.5)];
    imageView.image=[UIImage imageNamed:@"iconfont-shuaxin"];
    [bjView addSubview:imageView];
    
    UIButton *refLocation = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CTXScreenWidth, 40)];
    [refLocation addTarget:self action:@selector(refreshButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bjView addSubview:refLocation];
    
    
    self.backgroundColor = UIColorFromRGB(CTXBackGroundColor);
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+40, self.bounds.size.width, self.bounds.size.height-64-40-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = UIColorFromRGB(CTXBackGroundColor);
    _tableView.tag=3;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    // 刷新header
    self.tableView.mj_header = [CTXRefreshGifHeader headerWithRefreshingBlock:^{
        if (self.refreshStationListener) {
            self.refreshStationListener(NO);
        }
    }];

}
- (void) refresh {
    if (self.refreshStationListener) {
        self.refreshStationListener(YES);
    }
}

#pragma  mark 点击城市选择
-(void)cityButtonClick:(UIButton *)btn{
    
    UIButton * cityBtn = (UIButton *)[self viewWithTag:2];
    [cityBtn setTitle:@"智能排序" forState:UIControlStateNormal];
    [cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cityBtn setImage:[UIImage imageNamed:@"select_date"] forState:UIControlStateNormal];
    [btn setTitleColor:CTXColor(3, 163, 214) forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"shangla"] forState:UIControlStateNormal];
    if (_DistancetableView) {
        [_DistancetableView removeFromSuperview];
        [bgView removeFromSuperview];
        _DistancetableView = nil;
        bgView = nil;
    }
    if (bgView==nil) {
        bgView = [[UIView alloc]init];
        [self addSubview:bgView];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.3;
        bgView.frame = CGRectMake(0, 55, CTXScreenWidth, CTXScreenHeight-55) ;
    }
    if (self.CitytableView==nil) {
        self.CitytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 55, CTXScreenWidth, 44*_quArray.count) style:UITableViewStylePlain];
        self.CitytableView.tag = 1;
        self.CitytableView.delegate = self;
        self.CitytableView.dataSource = self;
        [self addSubview:_CitytableView];
    }
}

#pragma mark 点击智能选择
-(void)rankButtonClick:(UIButton *)btn{
    
    UIButton * cityBtn = (UIButton *)[self viewWithTag:1];
    [cityBtn setTitle:_citystring forState:UIControlStateNormal];
    [cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cityBtn setImage:[UIImage imageNamed:@"select_date"] forState:UIControlStateNormal];
    [btn setTitleColor:CTXColor(3, 163, 214) forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"shangla"] forState:UIControlStateNormal];
    
    if (_CitytableView) {
        [_CitytableView removeFromSuperview];
        [bgView removeFromSuperview];
        _CitytableView = nil;
        bgView = nil;
    }
    if (bgView==nil) {
        bgView = [[UIView alloc]init];
        [self addSubview:bgView];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.3;
        bgView.frame = CGRectMake(0, 55, CTXScreenWidth, CTXScreenHeight-55) ;
    }
    if (self.DistancetableView==nil) {
        self.DistancetableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 55, CTXScreenWidth, 44*3) style:UITableViewStyleGrouped];
        self.DistancetableView.tag = 2;
        self.DistancetableView.delegate = self;
        self.DistancetableView.dataSource = self;
        [self addSubview:_DistancetableView];
    }
    
}
#pragma mark 重新刷新数据
-(void)refreshButtonClick{
    if (_quArray.count>0) {
        _citystring = [_quArray[0] objectForKey:@"areaName"];
    }
    UIButton * cityBtn = (UIButton *)[self viewWithTag:1];
    [cityBtn setTitle:_citystring forState:UIControlStateNormal];
    [cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIButton * but = (UIButton *)[self viewWithTag:2];
    [but setTitle:@"智能排序" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"select_date"] forState:UIControlStateNormal];

    if (refreshListener) {
        
        _areaID = [_quArray[0] objectForKey:@"areaid"];
        NSLog(@"%@",_areaID);
        refreshListener(_areaID,4);
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag==3) {
        return self.dataSource.count;
    }else if (tableView.tag==1) {
        return _quArray.count;
    }
    return  3;
}

-(void)setRefreshListener:(void (^)(NSString *, NSInteger))listener{
    refreshListener = listener;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==3) {
        
        static NSString *cellID = @"cell";
        CJStationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[CJStationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        CarInspectStationModel * model = self.dataSource[indexPath.row];
        [cell setModel:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell  layoutSubviews];
        return cell;
        
    }else if (tableView.tag == 1) {
        static NSString * cellID = @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        cell.textLabel.text = [_quArray[indexPath.row] objectForKey:@"areaName"];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
    }else{
        static NSString * IdentifierID = @"Identifiercell";
        NSArray * nameArr = @[@"智能排序",@"离我最近",@"好评优先"];
        NSArray * nameImgArr = @[@"zhinengpaixu",@"juli",@"haopin"];
        CapacityTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:IdentifierID];
        if (!cell) {
            cell = [[CapacityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IdentifierID];
        }
        cell.nameImg.image = [UIImage imageNamed:nameImgArr[indexPath.row] ];
        cell.nameLab.text = nameArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==3) {
        if (self.selectStationCellListener) {
            CarInspectStationModel * model = _dataSource[indexPath.row];
            self.selectStationCellListener(model);
        }
    } else if (tableView.tag==1) {
        self.areaID = [_quArray[indexPath.row] objectForKey:@"areaid"];
        NSLog(@"%@",self.areaID);
        _citystring = [_quArray[indexPath.row] objectForKey:@"areaName"];
        UIButton * but = (UIButton *)[self viewWithTag:1];
        [but setTitle:[_quArray[indexPath.row] objectForKey:@"areaName"] forState:UIControlStateNormal];
        refreshListener(self.areaID,_value);
    }else{
        
         UIButton * but = (UIButton *)[self viewWithTag:2];
        NSArray * nameArr = @[@"智能排序",@"离我最近",@"好评优先"];
         [but setTitle:nameArr[indexPath.row] forState:UIControlStateNormal];
        _value = (int)indexPath.row;
        refreshListener(self.areaID,_value);
        
    }
    [bgView removeFromSuperview];
    [_CitytableView removeFromSuperview];
    [_DistancetableView removeFromSuperview];
    bgView = nil;
    _DistancetableView = nil;
    _CitytableView = nil;
    
}


-(void)setStationListener:(void (^)(NSInteger))listener{
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
    
    if (tableView.tag==3) {
          CarInspectStationModel * model = self.dataSource[indexPath.row];
        if ([model.isCanOnlinePay isEqualToString:@"1"]) {
            if ([model.personyh integerValue]==0) {
                 return  172-20-5;
            }else{
            return  172-20-5;
            }
        }else{
        return 114;
        }
    }
    return 44;
    
}

- (void) hideFooter {
    CGFloat y = self.tableView.contentOffset.y;
    CGFloat height = self.tableView.mj_footer.frame.size.height;
    CGPoint offset = CGPointMake(0, y - height);
    [self.tableView setContentOffset:offset animated:YES];
}

- (void) removeFooter {
    self.tableView.mj_footer = nil;
}

- (void) addFooter {
    if (!self.tableView.mj_footer) {
        self.tableView.mj_footer = [CTXRefreshGifFooter footerWithRefreshingBlock:^{
            if (self.loadStationListener) {
                self.loadStationListener();
            }
        }];
    }
}
- (void) endRefreshing {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void) addDataSource:(NSArray *)data page:(int)page {
    if (!data || data.count == 0) {
        return;
    }
    
    // 找出本页数据开始的下标
    int startIndex = countPerPage * page;  // 因为分页从0开始
    startIndex = (startIndex < 0 ? 0 : startIndex);
    
    // 1、还没有到该页数据, 说明是加载缓存数据，则直接添加
    if (_dataSource.count < startIndex) {
        [_dataSource addObjectsFromArray:data];
    } else {
        // 2、再进来，就是加载的网络数据，则需要替换掉缓存数据
        
        int endIndex = countPerPage * (page + 1);    // 下一页开始的下标
        NSRange range;                                  // 当前页的下标范围
        
        if (_dataSource.count < endIndex) {             // _dataSource数据不足当前页的最大下标
            int lack = endIndex - (int)_dataSource.count;   // _dataSource中缺少该页数据的个数
            range = NSMakeRange(startIndex, countPerPage - lack);
        } else {
            range = NSMakeRange(startIndex, countPerPage);
        }
        
        // 替换掉缓存数据
        [_dataSource replaceObjectsInRange:range withObjectsFromArray:data];
    }
    
    [self.tableView reloadData];
}

- (void) refreshDataSource:(NSArray *)data {
    if (!data) {
        if (_dataSource && _dataSource.count > 0) {
            return;
        }
        
        [self addNilDataView];
        [promptView setRequestFailureImageView];
        
        return;
    }
    
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:data];
    
    if (_dataSource.count == 0) {
        [self addNilDataView];
        [promptView setNilDataWithImagePath:@"" tint:@"暂无车检站信息" btnTitle:nil];
    } else {
        if (promptView) {
            [promptView removeFromSuperview];
            promptView = nil;
        }
    }
    
    countPerPage = (int) _dataSource.count;// 第一页数据个数就是每页的个数，否则就没有下一页了
    [self.tableView reloadData];
}

- (void) addNilDataView {
    if (!promptView) {
        promptView = [[PromptView alloc] init];
        
        @weakify(self)
        [promptView setPromptRefreshListener:^{
            @strongify(self)
            if (self.refreshStationListener) {
                self.refreshStationListener(YES);
            }
        }];
    }
    
    [self addSubview:promptView];
    [promptView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.bottom.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
    }];
}

@end
