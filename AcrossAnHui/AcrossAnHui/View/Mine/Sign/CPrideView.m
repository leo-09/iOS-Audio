//
//  CPrideView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CPrideView.h"
#import "CPrideCell.h"
#import "PrideModel.h"

@implementation CPrideView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        
        self.tableView = [[UITableView alloc] init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor clearColor];
        [self.tableView registerClass:[CPrideCell class] forCellReuseIdentifier:@"CPrideCell"];
        
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CPrideCell *cell = [CPrideCell cellWithTableView:tableView];
    
    PrideModel *model = _dataSource[indexPath.row];
    cell.prideLabel.text = model.goodsName;
    
    if ([self.viewTitle isEqualToString:@"未领取"]) {
        cell.prideLabel.textColor = UIColorFromRGB(CTXThemeColor);
        cell.gainLabel.hidden = NO;
        cell.receivedTimeLabel.hidden = YES;
        cell.receivedLabel.hidden = YES;
        cell.expiredLabel.hidden = YES;
    } else if ([self.viewTitle isEqualToString:@"已领取"]) {
        cell.prideLabel.textColor = UIColorFromRGB(CTXThemeColor);
        cell.gainLabel.hidden = YES;
        
        cell.receivedTimeLabel.text = model.rewardTime;
        cell.receivedTimeLabel.hidden = NO;
        cell.receivedLabel.hidden = NO;
        cell.expiredLabel.hidden = YES;
    } else {
        cell.prideLabel.textColor = UIColorFromRGB(0x999999);
        cell.gainLabel.hidden = YES;
        cell.receivedTimeLabel.hidden = YES;
        cell.receivedLabel.hidden = YES;
        cell.expiredLabel.hidden = NO;
    }
    
    if (indexPath.row == (self.dataSource.count - 1)) {
        [cell updateLastIamgeViewBottom];
    } else {
        [cell updateIamgeViewBottom];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 117;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectCellModelListener) {
        self.selectCellModelListener(_dataSource[indexPath.row]);
    }
}

- (void) setDataSource:(NSArray *)dataSource viewTitle:(NSString *)viewTitle {
    self.viewTitle = viewTitle;
    
    if (!dataSource) {
        if (_dataSource && _dataSource.count > 0) {
            return;
        }
        
        [self addNilDataView];
        [promptView setRequestFailureWithImagePath:@"prize" tint:@"网络开小差, 请点击重试"];
        
        return;
    }
    
    _dataSource = dataSource;
    if (_dataSource.count == 0) {
        NSString *tint;
        if ([self.viewTitle isEqualToString:@"未领取"]) {
            tint = @"暂时没有可领取的奖品";
        } else if ([self.viewTitle isEqualToString:@"已领取"]) {
            tint = @"暂时没有已领取的奖品";
        } else {
            tint = @"暂时没有已过期的奖品";
        }
        
        [self addNilDataView];
        [promptView setNilDataWithImagePath:@"prize" tint:tint btnTitle:nil];
    } else {
        if (promptView) {
            [promptView removeFromSuperview];
            promptView = nil;
        }
        
        [self.tableView reloadData];
    }
}

- (void) addNilDataView {
    if (!promptView) {
        promptView = [[PromptView alloc] init];
        promptView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        
        @weakify(self)
        [promptView setPromptRefreshListener:^{
            @strongify(self)
            if (self.refreshPrideListener) {
                self.refreshPrideListener(YES);
            }
        }];
    }
    
    [self addSubview:promptView];
    [promptView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
