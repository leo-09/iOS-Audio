//
//  CCancelOrderReasonView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/21.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CCancelOrderReasonView.h"
#import "CCancelOrderReasonCell.h"

@implementation CCancelOrderReasonView

- (instancetype) init {
    if (self = [super init]) {
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"选择取消原因";
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = UIColorFromRGB(CTXTextBlackColor);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:CTXTextFont];
        [self addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.top.equalTo(@0);
            make.height.equalTo(@90);
        }];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.top.equalTo(label.bottom);
            make.height.equalTo(@10);
        }];
        
        // titleView
        UIView *titleView = [[UIView alloc] init];
        titleView.backgroundColor = [UIColor whiteColor];
        [self addSubview:titleView];
        [titleView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.top.equalTo(view.bottom);
            make.height.equalTo(@50);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"选择订单取消原因，帮助我们改进";
        titleLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        [titleView addSubview:titleLabel];
        [titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.centerY.equalTo(titleView.centerY);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [titleView addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@(-0));
            make.bottom.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
        
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        [_tableView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.top.equalTo(titleView.bottom);
            make.bottom.equalTo(@0);
        }];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCancelOrderReasonCell *cell = [CCancelOrderReasonCell cellWithTableView:tableView];
    
    if (indexPath.row == _dataSource.count) {
        [cell setModel:nil isLastCell:YES];
    } else {
        [cell setModel:_dataSource[indexPath.row] isLastCell:NO];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _dataSource.count) {
        return 100;
    } else {
        return 60;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _dataSource.count) {
        // 提交
        NSMutableString *cancelIDs = [[NSMutableString alloc] init];
        for (CancelOrderReasonModel *model in _dataSource) {
            if (model.isSelect) {
                [cancelIDs appendString:[NSString stringWithFormat:@"%@,", model.cancelID]];
            }
        }
        
        if (self.submitReasonListener) {
            if ([cancelIDs isEqualToString:@""]) {
                self.submitReasonListener(@"");
            } else {
                self.submitReasonListener([cancelIDs substringToIndex:(cancelIDs.length-1)]);
            }
        }
        
    } else {
        // 选择／不选中
        CancelOrderReasonModel *model = _dataSource[indexPath.row];
        model.isSelect = !model.isSelect;
        [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - public method

- (void) setDataSource:(NSArray<CancelOrderReasonModel *> *)dataSource {
    if (!dataSource) {
        [self addNilDataView];
        [promptView setRequestFailureImageView];
        
        return;
    }
    
    _dataSource = dataSource;
    if (_dataSource.count == 0) {
        [self addNilDataView];
        [promptView setNilDataWithImagePath:@"weizhaodao" tint:@"暂无订单取消原因" btnTitle:nil];
    } else {
        if (promptView) {
            [promptView removeFromSuperview];
            promptView = nil;
        }
        
        // 默认选中第一个
        CancelOrderReasonModel *model = _dataSource[0];
        model.isSelect = YES;
        
        [self.tableView reloadData];
    }
}

- (void) addNilDataView {
    if (!promptView) {
        CGRect frame = CGRectMake(0, 0, CTXScreenWidth, (CTXScreenHeight- CTXBarHeight - CTXNavigationBarHeight));
        promptView = [[PromptView alloc] initWithFrame:frame];
        
//        @weakify(self)
//        [promptView setPromptRefreshListener:^{
//            @strongify(self)
//            if (self.refreshNewsInfoDataListener) {
//                self.refreshNewsInfoDataListener(YES);
//            }
//        }];
        
        [self addSubview:promptView];
        [promptView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
}

@end
