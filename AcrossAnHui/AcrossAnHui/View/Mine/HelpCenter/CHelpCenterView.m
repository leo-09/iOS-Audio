//
//  CHelpCenterView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CHelpCenterView.h"
#import "CHelpCenterCell.h"
#import "SelectView.h"
#import "UILabel+lineSpace.h"

@interface CHelpCenterView()

@property (nonatomic, strong) CHelpCenterCell *tempCell;

@end

@implementation CHelpCenterView

- (instancetype) init {
    if (self = [super init]) {
        
        _dataSource = [[NSMutableArray alloc] init];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self.tableView registerClass:[CHelpCenterCell class] forCellReuseIdentifier:@"CHelpCenterCell"];
        
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@1);
            make.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
        }];
        
        // 创建cell
        self.tempCell = [[CHelpCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CHelpCenterCell"];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HelpCenterModel *model = _dataSource[section];
    
    if (model.selected) {
        return 1;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CHelpCenterCell *cell = [CHelpCenterCell cellWithTableView:tableView];
    
    HelpCenterModel *model = _dataSource[indexPath.section];
    cell.model = model;
    
    return cell;
}

#pragma mark UITableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HelpCenterModel *model = _dataSource[section];
    
    SelectView *headerView = [[SelectView alloc] init];
    
    // leftIV
    UIImageView *leftIV = [[UIImageView alloc] init];
    [headerView addSubview:leftIV];
    [leftIV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.centerY.equalTo(headerView.centerY);
        make.size.equalTo(CGSizeMake(15, 15));
    }];
    
    // label
    UILabel *label = [[UILabel alloc] init];
    label.text = model.title;
    label.font = [UIFont systemFontOfSize:CTXTextFont];
    label.numberOfLines = 0;
    
    // 计算title的宽度,不能超过最大宽度
    CGFloat maxWidth = CTXScreenWidth - 69;//69 = 12+15+12+8+12+10
    CGFloat width = [label getLabelHeightWithLineSpace:0 WithWidth:maxWidth WithNumline:1].width;
    if (width > maxWidth) {
        width = maxWidth;
    }
    
    [headerView addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftIV.right).offset(@12);
        make.centerY.equalTo(headerView.centerY);
        make.width.equalTo(width);
    }];
    
    // rightIV
    UIImageView *rightIV = [[UIImageView alloc] init];
    [headerView addSubview:rightIV];
    [rightIV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.right).offset(@8);
        make.centerY.equalTo(headerView.centerY);
        make.size.equalTo(CGSizeMake(12, 12));
    }];
    
    // 线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
    [headerView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    if (model.selected) {
        leftIV.image = [UIImage imageNamed:@"iconfont_wenti"];
        label.textColor = UIColorFromRGB(CTXThemeColor);
        rightIV.image = [UIImage imageNamed:@"help_xiala"];
        lineView.hidden = YES;
    } else {
        leftIV.image = [UIImage imageNamed:@"iconfont_went1"];
        label.textColor = UIColorFromRGB(0x333333);
        rightIV.image = [UIImage imageNamed:@"helpxialw"];
        lineView.hidden = NO;
    }
    
    // 点击: 选中／取消选中
    [headerView setClickListener:^(id sender) {
        model.selected = !model.selected;
        [tableView reloadSection:section withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    return headerView;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HelpCenterModel *model = _dataSource[indexPath.section];
    if (model.cellHeight == 0) {
        CGFloat cellHeight = [self.tempCell heightForModel:model];
        model.cellHeight = cellHeight;// 缓存给model
        return cellHeight;
    } else {
        return model.cellHeight;
    }
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
        [promptView setNilDataWithImagePath:@"weizhaodao" tint:@"暂无帮助信息" btnTitle:nil];
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
            if (self.refreshHelpInfoDataListener) {
                self.refreshHelpInfoDataListener(YES);
            }
        }];
    }
    
    [self addSubview:promptView];
    [promptView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
