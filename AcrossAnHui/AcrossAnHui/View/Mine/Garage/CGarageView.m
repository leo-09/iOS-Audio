//
//  CGarageView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/14.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CGarageView.h"
#import "CGarageCell.h"

@implementation CGarageView

- (instancetype) init {
    if (self = [super init]) {
        _dataSource = [[NSMutableArray alloc] init];
        
        self.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self addBottomView];
        [self addTableView];
    }
    
    return self;
}

// 设为默认车辆／删除的view,默认添加
- (void) addBottomView {
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = UIColorFromRGB(CTXThemeColor);
    [self addSubview:_bottomView];
    [_bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.bottom.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@0);
    }];
    
    // 设置为停车车辆 button
    _defaultCarBtn = [[UIButton alloc] init];
    _defaultCarBtn.hidden = YES;
    _defaultCarBtn.backgroundColor = [UIColor clearColor];
    [_defaultCarBtn setTitle:@"设置为停车车辆" forState:UIControlStateNormal];
    [_defaultCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _defaultCarBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [_defaultCarBtn addTarget:self action:@selector(setDefaultCar) forControlEvents:UIControlEventTouchDown];
    [_bottomView addSubview:_defaultCarBtn];
    [_defaultCarBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@2);
        make.bottom.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(CTXScreenWidth / 2);
    }];
    
    // 删除 button
    _deleteCarBtn = [[UIButton alloc] init];
    _deleteCarBtn.hidden = YES;
    _deleteCarBtn.backgroundColor = [UIColor clearColor];
    [_deleteCarBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _deleteCarBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [_deleteCarBtn addTarget:self action:@selector(deleteCar) forControlEvents:UIControlEventTouchDown];
    [_bottomView addSubview:_deleteCarBtn];
    [_deleteCarBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-2);
        make.bottom.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(CTXScreenWidth / 2);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor whiteColor];
    [_bottomView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_bottomView.center);
        make.width.equalTo(@0.8);
        make.height.equalTo(@30);
    }];
}

- (void) addTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 135;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[CGarageCell class] forCellReuseIdentifier:@"CGarageCell"];
    
    [self addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(0);
    }];
    
    [self addBottomView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGarageCell *cell = [CGarageCell cellWithTableView:tableView];
    
    BoundCarModel *model = _dataSource[indexPath.row];
    cell.model = model;
    
    return cell;
}

// 侧滑允许编辑cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // _defaultCarBtn隐藏，则不是编辑状态，才可以点击
    if (_defaultCarBtn.isHidden) {
        return YES;
    } else {
        return NO;
    }
}

// 侧滑出现的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"默认车辆";
}

// 执行策划操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.defaultCarListener) {
        self.defaultCarListener(self.dataSource[indexPath.row]);
    }
}


#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // _defaultCarBtn隐藏，则不是编辑状态，才可以点击
    if (_defaultCarBtn.isHidden) {
        if (indexPath.row < self.dataSource.count) {
            if (self.editCarListener) {
                self.editCarListener(self.dataSource[indexPath.row]);
            }
        }
    }
}

#pragma mark - public method

- (void) refreshDataSource:(NSArray *)data {
    // 隐藏bottomView的操作
    _defaultCarBtn.hidden = YES;
    _deleteCarBtn.hidden = YES;
    _footerView.hidden = NO;
    [_bottomView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
    }];
    
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
        [promptView setNilDataWithImagePath:@"car_mytt" tint:@"" btnTitle:@"暂无车辆,快去绑定车辆吧" isNeedAddData:YES];
    } else {
        if (promptView) {
            [promptView removeFromSuperview];
            promptView = nil;
        }
    }
    
    if (self.dataSource.count >= 5) {
        self.tableView.tableFooterView = nil;
    } else {
        self.tableView.tableFooterView = self.footerView;
    }
    
    [self.tableView reloadData];
}

- (void) addNilDataView {
    if (!promptView) {
        promptView = [[PromptView alloc] init];
        
        @weakify(self)
        [promptView setPromptRefreshListener:^{
            @strongify(self)
            if (!self.dataSource) {// 网络错误，刷新车辆
                if (self.refreshCarDataListener) {
                    self.refreshCarDataListener(YES);
                }
            }
        }];
        [promptView setPromptOperationListener:^{
            @strongify(self)
            
            // 没有车辆，去绑定
            [self bindCar];
        }];
    }
    
    [self addSubview:promptView];
    [promptView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void) showBottomView {
    _footerView.hidden = YES;
    _defaultCarBtn.hidden = NO;
    _deleteCarBtn.hidden = NO;
    
    [_bottomView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
    }];
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-50);
    }];
    
    for (BoundCarModel *model in self.dataSource) {
        model.isShowSelect = YES;
    }
    
    [self.tableView reloadData];
}

- (void) hideBottomView {
    _footerView.hidden = NO;
    _defaultCarBtn.hidden = YES;
    _deleteCarBtn.hidden = YES;
    [_bottomView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
    }];
    
    for (BoundCarModel *model in self.dataSource) {
        model.isShowSelect = NO;
    }
    [self.tableView reloadData];
}

#pragma mark - private method

// 设为默认车辆
- (void) setDefaultCar {
    if (self.parkingCarListener) {
        NSMutableArray *models = [[NSMutableArray alloc] init];
        for (BoundCarModel *model in self.dataSource) {
            if (model.isSelected) {
                [models addObject:model];
            }
        }
        
        if (models.count > 3) {
            [self showTextHubWithContent:@"最多只能设置3辆车为停车车辆"];
            return;
        }
        
        self.parkingCarListener(models);
    }
}

// 删除
- (void) deleteCar {
    if (self.deleteCarListener) {
        NSMutableArray *models = [[NSMutableArray alloc] init];
        for (BoundCarModel *model in self.dataSource) {
            if (model.isSelected) {
                [models addObject:model];
            }
        }
        
        if (models.count == 0) {
            [self showTextHubWithContent:@"请选择车辆"];
            return;
        }
        
        self.deleteCarListener(models);
    }
}

#pragma mark - footerView

- (UIView *) footerView {
    if (!_footerView) {
        CGFloat height = 12 + 102 + 12 + 20 + 12;
        CGRect frame = CGRectMake(0, 0, CTXScreenWidth, height);
        _footerView = [[UIView alloc] initWithFrame:frame];
        
        // 图标
        CGRect imageBtnFrame = CGRectMake((CTXScreenWidth-103) / 2 + 12, 32, 103, 102);
        UIButton *imageBtn = [[UIButton alloc] initWithFrame:imageBtnFrame];
        [imageBtn setImage:[UIImage imageNamed:@"add_car1"] forState:UIControlStateNormal];
        [imageBtn addTarget:self action:@selector(bindCar) forControlEvents:UIControlEventTouchDown];
        [_footerView addSubview:imageBtn];
        
        // 文字
        CGRect textBtnFrame = CGRectMake(12, 32 + 102 - 20, CTXScreenWidth - 24, 20);
        UIButton *textBtn = [[UIButton alloc] initWithFrame:textBtnFrame];
        textBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        textBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [textBtn setTitleColor:UIColorFromRGB(CTXBaseFontColor) forState:UIControlStateNormal];
        [textBtn setTitle:@"添加车辆" forState:UIControlStateNormal];
        [textBtn addTarget:self action:@selector(bindCar) forControlEvents:UIControlEventTouchDown];
        [_footerView addSubview:textBtn];
    }
    
    return _footerView;
}

- (void) bindCar {
    if (self.dataSource && self.dataSource.count > 0) {
        // 车库有车辆，则弹出 “添加新车辆／绑定停车服务”
        if (!self.addCarView) {
            self.addCarView = [[CGarageAddCarView alloc] init];
        }
        [self.addCarView showView];
        
        @weakify(self)
        
        [self.addCarView setAddCarListener:^ {
            @strongify(self)
            
            if (self.bindCarListener) {
                self.bindCarListener();
            }
        }];
        
        [self.addCarView setBindParkingListener:^ {
            @strongify(self)
            
            if (self.bindOrDeleteCarListener) {
                self.bindOrDeleteCarListener();
            }
        }];
    } else {
        // 车库没有车辆，则直接 “添加新车辆”
        if (self.bindCarListener) {
            self.bindCarListener();
        }
    }
}

@end
