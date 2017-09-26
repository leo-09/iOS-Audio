//
//  CCarInspectLogisticsView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/21.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CCarInspectLogisticsView.h"
#import "CCarInspectLogisticsCell.h"
#import "CTXRefreshGifHeader.h"
#import "CarInspectLogistics.h"

@interface CCarInspectLogisticsView()

@property (nonatomic, retain) CCarInspectLogisticsCell *tempCell;

@end

@implementation CCarInspectLogisticsView

- (instancetype) init {
    if (self = [super init]) {
        _dataSource = [[NSMutableArray alloc] init];
        
        [self addTopView];
        [self addInfoView];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self.tableView registerClass:[CCarInspectLogisticsCell class] forCellReuseIdentifier:@"CCarInspectLogisticsCell"];
        // 刷新header
        self.tableView.mj_header = [CTXRefreshGifHeader headerWithRefreshingBlock:^{
            if (self.refreshDataListener) {
                self.refreshDataListener(NO);
            }
        }];
        
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.top.equalTo(self.infoView.bottom);
        }];
        
        // 创建cell
        self.tempCell = [[CCarInspectLogisticsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CCarInspectLogisticsCell"];
    }
    
    return self;
}

// 寄往车检站 寄回用户
- (void) addTopView {
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topView];
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@50);
    }];
    
    // stationBtn
    self.stationBtn = [[UIButton alloc] init];
    [self.stationBtn setTitle:@"寄往车检站" forState:UIControlStateNormal];
    self.stationBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [self.stationBtn setTitleColor:UIColorFromRGB(CTXThemeColor) forState:UIControlStateSelected];
    [self.stationBtn setTitleColor:UIColorFromRGB(CTXTextBlackColor) forState:UIControlStateNormal];
    [self.stationBtn addTarget:self action:@selector(station) forControlEvents:UIControlEventTouchDown];
    [self.topView addSubview:self.stationBtn];
    [self.stationBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.width.equalTo(CTXScreenWidth / 2);
    }];
    
    // 默认选中
    self.stationBtn.selected = YES;
    
    // userBtn
    self.userBtn = [[UIButton alloc] init];
    [self.userBtn setTitle:@"寄往用户" forState:UIControlStateNormal];
    self.userBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [self.userBtn setTitleColor:UIColorFromRGB(CTXThemeColor) forState:UIControlStateSelected];
    [self.userBtn setTitleColor:UIColorFromRGB(CTXTextBlackColor) forState:UIControlStateNormal];
    [self.userBtn addTarget:self action:@selector(user) forControlEvents:UIControlEventTouchDown];
    [self.topView addSubview:self.userBtn];
    [self.userBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.width.equalTo(CTXScreenWidth / 2);
    }];
    
    // 分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
    [self.topView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.topView.center);
        make.width.equalTo(@1);
        make.height.equalTo(@35);
    }];
}

- (void) addInfoView {
    self.infoView = [[UIView alloc] init];
    self.infoView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    [self addSubview:self.infoView];
    [self.infoView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(_topView.bottom);
        make.height.equalTo(@110);
    }];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShunFeng"]];
    [self.infoView addSubview:iv];
    [iv makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.centerY.equalTo(self.infoView.centerY);
        make.width.equalTo(60.0 * 169.0 / 127.0);
        make.height.equalTo(@60);
    }];
    
    _busCodeLabel = [[UILabel alloc] init];
    _busCodeLabel.text = @"订单编号：";
    _busCodeLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
    _busCodeLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [self.infoView addSubview:_busCodeLabel];
    [_busCodeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iv.right).offset(15);
        make.centerY.equalTo(self.infoView.centerY);
        make.right.equalTo(@(-12));
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"承运物流：";
    _nameLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
    _nameLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [self.infoView addSubview:_nameLabel];
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_busCodeLabel.left);
        make.right.equalTo(_busCodeLabel.right);
        make.bottom.equalTo(_busCodeLabel.top).offset(-8);
    }];
    
    _phoneLabel = [[UILabel alloc] init];
    _phoneLabel.text = @"官方电话：";
    _phoneLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
    _phoneLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [self.infoView addSubview:_phoneLabel];
    [_phoneLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_busCodeLabel.left);
        make.right.equalTo(_busCodeLabel.right);
        make.top.equalTo(_busCodeLabel.bottom).offset(8);
    }];
}

#pragma mark - event response

// 寄往车检站
- (void) station {
    self.stationBtn.selected = YES;
    self.userBtn.selected = NO;
    
    if (self.logisticsListener) {
        self.logisticsListener(0);
    }
}

// 寄往用户
- (void) user {
    self.stationBtn.selected = NO;
    self.userBtn.selected = YES;
    
    if (self.logisticsListener) {
        self.logisticsListener(1);
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCarInspectLogisticsCell *cell = [CCarInspectLogisticsCell cellWithTableView:tableView];
    
    CarInspectLogistics *model = _dataSource[indexPath.row];
    
    BOOL isFirstCell = NO;
    if (indexPath.row == 0) {
        isFirstCell = YES;
    }
    
    BOOL isLastCell = NO;
    if (indexPath.row == _dataSource.count - 1) {
        isLastCell = YES;
    }
    
    [cell setModel:model isFirstCell:isFirstCell isLastCell:isLastCell];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarInspectLogistics *model = _dataSource[indexPath.row];
    if (model.cellHeight == 0) {
        CGFloat cellHeight = [self.tempCell heightForModel:model isFirstCell:(indexPath.row == 0 ? YES : NO)];
        model.cellHeight = cellHeight;// 缓存给model
        return cellHeight;
    } else {
        return model.cellHeight;
    }
}

#pragma mark - getter/setter

- (void) setCarInspectLogisticsInfo:(CarInspectLogisticsInfo *)model {
    if (model) {
        _nameLabel.text = [NSString stringWithFormat:@"承运物流：%@", [model typeName]];
        _busCodeLabel.text = [NSString stringWithFormat:@"订单编号：%@", model.businessCode ? model.businessCode : @"--"];
        _phoneLabel.text = [NSString stringWithFormat:@"官方电话：%@", model.tel ? model.tel : @"--"];
    } else {
        _nameLabel.text = @"承运物流：";
        _busCodeLabel.text = @"订单编号：";
        _phoneLabel.text = @"官方电话：";
    }
}

- (void) endRefreshing {
    [self.tableView.mj_header endRefreshing];
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
        [promptView setNilDataWithImagePath:@"" tint:@"暂无物流信息" btnTitle:nil];
    } else {
        if (promptView) {
            [promptView removeFromSuperview];
            promptView = nil;
        }
    }
    
    [self.tableView reloadData];
}

- (void) addNilDataView {
    if (!promptView) {
        promptView = [[PromptView alloc] init];
        
        @weakify(self)
        [promptView setPromptRefreshListener:^{
            @strongify(self)
            if (self.refreshDataListener) {
                self.refreshDataListener(YES);
            }
        }];
    }
    
    [self addSubview:promptView];
    [promptView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.top.equalTo(self.infoView.bottom);
    }];
}

@end
