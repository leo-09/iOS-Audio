//
//  CIllegalQueryView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CIllegalQueryView.h"
#import "CIllegalQueryCell.h"
#import "CIllegalQueryHeaderView.h"
#import "CIllegalQueryEmptyDataCell.h"

#define HeaderViewHeight 265

@interface CIllegalQueryView () {
    BOOL isEmptyCell;
}

@property (nonatomic, retain) CIllegalQueryHeaderView *headerView;

@end

@implementation CIllegalQueryView

- (instancetype) init {
    if (self = [super init]) {
        _dataSource = [[NSMutableArray alloc] init];
        
        // 查看历史违章
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        [self addSubview:bottomView];
        [bottomView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(@52);
        }];
        
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = UIColorFromRGB(CTXThemeColor);
        [btn setTitle:@"查看历史违章" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        CTXViewBorderRadius(btn, 4.0, 0, [UIColor clearColor]);
        [btn addTarget:self action:@selector(showIllegalList) forControlEvents:UIControlEventTouchDown];
        [bottomView addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomView.centerY);
            make.height.equalTo(@40);
            make.left.equalTo(@60);
            make.right.equalTo(@(-60));
        }];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        
        // tableHeaderView
        CGRect frame = CGRectMake(0, 0, CTXScreenWidth, HeaderViewHeight);
        self.headerView = [[CIllegalQueryHeaderView alloc] initWithFrame:frame];
        
        @weakify(self)
        [self.headerView setSelectCurrentIndexListener:^(int index) {
            @strongify(self)
            [self setSelectedIndex:index];
            [self.tableView reloadData];
        }];
        [self.headerView setEditCarListener:^(id result) {
            @strongify(self)
            if (self.editCarListener) {
                self.editCarListener(result);
            }
        }];
        
        self.tableView.tableHeaderView = self.headerView;
        
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.top.equalTo(@0);
            make.bottom.equalTo(bottomView.top);
        }];
    }
    
    return self;
}

- (void)showIllegalList {
    if (self.showIllegalListListener) {
        if (_dataSource && _dataSource.count > _currentIndex) {
            CarIllegalInfoModel * model = _dataSource[_currentIndex];
            
            self.showIllegalListListener(model);
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataSource.count > 0) {
        if (_dataSource && _dataSource.count > _currentIndex) {
            CarIllegalInfoModel * model = _dataSource[_currentIndex];
            
            if (model.notPaid.count == 0) {
                isEmptyCell = YES;// 没有违章信息的cell
                return 1;
            } else {
                isEmptyCell = NO;
                return model.notPaid.count;
            }
        }
        
        isEmptyCell = YES;// 没有违章信息的cell
        return 1;
    } else {
        isEmptyCell = YES;
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isEmptyCell) {// 没有违章信息的cell,有可能系统维护，所以要判断success字段
        CIllegalQueryEmptyDataCell *cell = [CIllegalQueryEmptyDataCell cellWithTableView:tableView];
        
        CarIllegalInfoModel * model = _dataSource[_currentIndex];
        if ([model.jdcjbxx.success isEqualToString:@"1"]) {
            [cell setLabelText:@"恭喜您，暂时没有未处理的违章信息哦！"];
        } else {
            [cell setLabelText:@"系统维护中,暂时无法查询该车辆的违章信息"];
        }
        
        return cell;
    } else {
        CIllegalQueryCell *cell = [CIllegalQueryCell cellWithTableView:tableView];
        
        // 找出违章信息详情
        CarIllegalInfoModel * model = _dataSource[_currentIndex];
        ViolationInfoModel *violationInfoModel = model.notPaid[indexPath.row];
        cell.model = violationInfoModel;
        [cell setCountLabelText:[NSString stringWithFormat:@"%d", ((int)(indexPath.row) + 1)]];
        
        // 第一个cell 隐藏leftTopLineView
        if (indexPath.row == 0) {
            [cell showLeftTopLineView:YES];
        } else {
            [cell showLeftTopLineView:NO];
        }
        
        // 最后一个cell 隐藏bottomLineView
        if (indexPath.row == (model.notPaid.count - 1)) {
            [cell showBottomLineView:YES];
        } else {
            [cell showBottomLineView:NO];
        }
        
        return cell;
    }
}

#pragma mark UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isEmptyCell) {
        return (tableView.frame.size.height - HeaderViewHeight);
    } else {
        return 135;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!isEmptyCell) {
        if (_currentIndex < _dataSource.count) {
            // 找出违章信息详情
            CarIllegalInfoModel * model = _dataSource[_currentIndex];
            
            if (indexPath.row < model.notPaid.count) {
                if (self.selectCarIllegalInfoCellListener) {
                    self.selectCarIllegalInfoCellListener(model.notPaid[indexPath.row]);
                }
            }
        }
    }
}

#pragma mark - public method

- (void) setEditCarNote:(NSString *)note name:(NSString *)name carType:(NSString *)carType {
    [self.headerView setEditCarNote:note name:name carType:carType];
}

- (void) setSelectedIndex:(int)index  {
    if (_currentIndex == index) {
        return;
    }
    
    _currentIndex = index;
    [self.headerView setSelectedIndex:_currentIndex];
}

- (void) setDataSource:(NSArray<CarIllegalInfoModel *> *)dataSource selectedIndex:(int)index {
    if (!dataSource) {
        [self addNilDataView];
        [promptView setRequestFailureImageView];
        
        return;
    }
    
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:dataSource];
    
    if (_dataSource.count == 0) {
        [self addNilDataView];
        [promptView setNilDataWithImagePath:@"add_car" tint:@"您还没有绑定车辆，请先绑定您的爱车！" btnTitle:nil isNeedAddData:YES];
    } else {
        if (promptView) {
            [promptView removeFromSuperview];
            promptView = nil;
        }
        
        self.headerView.dataSource = _dataSource;
        [self setSelectedIndex:index];
        [self.tableView reloadData];
    }
}

- (void) addNilDataView {
    if (!promptView) {
        promptView = [[PromptView alloc] init];
        
        @weakify(self)
        [promptView setPromptRefreshListener:^{
            @strongify(self)
            if (!self.dataSource) {
                // 如果数据为nil，则需要刷新数据
                if (self.refreshCarIllegalInfoDataListener) {
                    self.refreshCarIllegalInfoDataListener(YES);
                }
            } else {
                // 如果数据为空，则需要绑定车辆
                if (self.bindCarListener) {
                    self.bindCarListener();
                }
            }
        }];
    }
    
    [self addSubview:promptView];
    [promptView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
