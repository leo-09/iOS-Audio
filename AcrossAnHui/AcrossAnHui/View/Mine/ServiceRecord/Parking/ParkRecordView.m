//
//  ParkRecordView.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ParkRecordView.h"
#import "ParkRecordTableViewCell.h"
#import "UILabel+lineSpace.h"
#import "MJRefresh.h"
#import "PromptView.h"
#import "CTXRefreshGifHeader.h"
#import "CTXRefreshGifFooter.h"

@interface ParkRecordView ()<UITableViewDataSource,UITableViewDelegate> {
    PromptView *promptView;
}

@property(nonatomic,retain)UITableView * tableView;
@property(nonatomic,retain)NSMutableArray * dataArr;

@end

@implementation ParkRecordView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        self.dataArr = [[NSMutableArray alloc]init];
    }
    
    return self;
}

-(void)initUI {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 1, self.frame.size.width, self.frame.size.height-1) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    
    self.tableView.mj_header = [CTXRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshMoreNews)];
}

-(void)refreshMoreNews {
    if (refreshListener) {
        refreshListener();
    }
}

-(void)loadMoreNews {
    if (freshListener) {
        freshListener();
    }
}

-(void)refreshData:(NSArray *)dataArr {
    if (!dataArr) {
        if (self.dataArr && self.dataArr.count > 0) {
            return;
        }
        
        [self addNilDataView];
        [promptView setRequestFailureImageView];
        
        return;
    }
    
    // 赋值
    self.dataArr = (NSMutableArray *)dataArr;
    
    if (self.dataArr.count > 3) {
        if (!self.tableView.mj_footer) {
            self.tableView.mj_footer = [CTXRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreNews)];
        }
    } else {
        [self removeFoodView];
    }
    
    if (self.dataArr.count == 0) {
        [self addNilDataView];
        [promptView setNilDataWithImagePath:@"park_zwtcjl" tint:@"暂无停车记录" btnTitle:@""];
        @weakify(self)
        [promptView setPromptRefreshListener:^{
            @strongify(self)
            if (self.refreshParkingRecordDataListener) {
                self.refreshParkingRecordDataListener(YES);
            }
        }];
    } else {
        if (promptView) {
            [promptView removeFromSuperview];
            promptView = nil;
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

-(void)removeFoodView {
    if (self.tableView.mj_footer) {
        self.tableView.mj_footer = nil;
    }
}

#pragma mark UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParkRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ParkRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    ParkRecordModel * model = self.dataArr[indexPath.section];
    [cell setModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel * lab = [[UILabel alloc]init];
    ParkRecordModel * model = _dataArr[indexPath.section];
    
    lab.text = [NSString stringWithFormat:@"停车地址:%@",model.sitename];
    lab.font = [UIFont systemFontOfSize:15];
    lab.numberOfLines = 0;
    CGFloat hight = [lab getLabelHeightWithLineSpace:10 WithWidth:CTXScreenWidth-12-20-10-12 WithNumline:0].height;
    
    return 200 + hight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  0.01;
}

 -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     ParkRecordModel * model = _dataArr[indexPath.section];
    if (selectCellListener) {
        selectCellListener(model);
    }
}

- (void) addNilDataView {
    if (!promptView) {
        promptView = [[PromptView alloc] init];
        
        [self addSubview:promptView];
        [promptView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@1);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
    }
}

-(void)setSelectCellListener:(void (^)(ParkRecordModel *))listener {
    selectCellListener = listener;
}

-(void)setFreshListener:(void (^)())listener {
    freshListener = listener;
}

-(void)setRefreshListener:(void (^)())listener {
    refreshListener = listener;
}

@end
