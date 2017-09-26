//
//  CApplyRefundView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CApplyRefundView.h"
#import "CCancelOrderReasonCell.h"

@implementation CApplyRefundView

#pragma mark - view

- (instancetype) init {
    if (self = [super init]) {
        
        // 添加头部内容
        [self addTypeView];
        
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        [_tableView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.top.equalTo(_reasonTintLabel.bottom).offset(1);
            make.bottom.equalTo(@0);
        }];
    }
    
    return self;
}

- (void) addTypeView {
    // 退款类型
    _typeView = [[UIView alloc] init];
    _typeView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_typeView];
    [_typeView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@55);
    }];
    
    UILabel *typeNameLabel = [[UILabel alloc] init];
    typeNameLabel.text = @"退款类型";
    typeNameLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    typeNameLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [_typeView addSubview:typeNameLabel];
    [typeNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@20);
    }];
    
    // _typeLabel
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.textColor = UIColorFromRGB(CTXThemeColor);
    _typeLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    _typeLabel.text = @"部分退款";
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    CTXViewBorderRadius(_typeLabel, 2.0, 0.8, UIColorFromRGB(CTXThemeColor));
    [_typeView addSubview:_typeLabel];
    [_typeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeNameLabel.right).offset(20);
        make.top.equalTo(@10);
        make.width.equalTo(@90);
        make.height.equalTo(@35);
    }];
    
    _typeTintLabel = [[UILabel alloc] init];
    _typeTintLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
    _typeTintLabel.font = [UIFont systemFontOfSize:12.0];
    [_typeView addSubview:_typeTintLabel];
    [_typeTintLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_typeLabel.left);
        make.top.equalTo(_typeLabel.bottom).offset(@10);
    }];
    
    // 分割段
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    [self addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(_typeView.bottom);
        make.height.equalTo(@14);
    }];
    
    // 退款金额
    UIView *moneyView = [[UIView alloc] init];
    moneyView.backgroundColor = [UIColor whiteColor];
    [self addSubview:moneyView];
    [moneyView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(lineView.bottom);
        make.height.equalTo(@55);
    }];
    
    UILabel *moneyNameLabel = [[UILabel alloc] init];
    moneyNameLabel.text = @"退款金额";
    moneyNameLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    moneyNameLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [moneyView addSubview:moneyNameLabel];
    [moneyNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(moneyView.centerY);
    }];
    
    // _moneyLabel
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    _moneyLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [moneyView addSubview:_moneyLabel];
    [_moneyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyNameLabel.right).offset(20);
        make.centerY.equalTo(moneyView.centerY);
    }];
    
    // tintLabel
    UILabel *tintLabel = [[UILabel alloc] init];
    tintLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    tintLabel.text = @"退款将于3个工作日内原路退回";
    tintLabel.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:tintLabel];
    [tintLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.top.equalTo(moneyView.bottom);
        make.height.equalTo(@40);
    }];
    
    _reasonTintLabel = [[UILabel alloc] init];
    _reasonTintLabel.backgroundColor = [UIColor whiteColor];
    _reasonTintLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    _reasonTintLabel.text = @"   选择订单取消原因，帮助我们改进";
    _reasonTintLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [self addSubview:_reasonTintLabel];
    [_reasonTintLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(tintLabel.bottom);
        make.height.equalTo(@60);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.reson_list.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCancelOrderReasonCell *cell = [CCancelOrderReasonCell cellWithTableView:tableView];
    
    if (indexPath.row == self.model.reson_list.count) {
        [cell setModel:nil isLastCell:YES];
    } else {
        [cell setModel:self.model.reson_list[indexPath.row] isLastCell:NO];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.model.reson_list.count) {
        return 100;
    } else {
        return 60;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.model.reson_list.count) {
        // 提交
        NSMutableString *cancelIDs = [[NSMutableString alloc] init];
        for (CancelOrderReasonModel *model in self.model.reson_list) {
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
        CancelOrderReasonModel *model = self.model.reson_list[indexPath.row];
        model.isSelect = !model.isSelect;
        [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - public method

- (void) setModel:(RefundOrderReasonModel *)model {
    if (!model) {
        [self addNilDataView];
        [promptView setRequestFailureImageView];
        
        return;
    }
    
    _model = model;
    
    _typeLabel.text = _model.return_type ? _model.return_type : @"全额退款";
    double money = [(_model.money ? _model.money : @"0") doubleValue];
    _moneyLabel.text = [NSString stringWithFormat:@"¥%.2f", money];
    _typeTintLabel.text = _model.return_desc ? _model.return_desc : @"";
    
    if ([_model.return_type isEqualToString:@"部分退款"]) {
        [_typeView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@75);
        }];
        
        [self setNeedsLayout];
    }
    
    if (_model.reson_list.count == 0) {
        [self addNilDataView];
        [promptView setNilDataWithImagePath:@"weizhaodao" tint:@"暂无原因" btnTitle:nil];
    } else {
        if (promptView) {
            [promptView removeFromSuperview];
            promptView = nil;
        }
        
        CancelOrderReasonModel *model = _model.reson_list[0];
        model.isSelect = YES;
        [self.tableView reloadData];
    }
}

- (void) addNilDataView {
    if (!promptView) {
        CGRect frame = CGRectMake(0, 0, CTXScreenWidth, (CTXScreenHeight- CTXBarHeight - CTXNavigationBarHeight));
        promptView = [[PromptView alloc] initWithFrame:frame];
        
        @weakify(self)
        [promptView setPromptRefreshListener:^{
            @strongify(self)
            if (self.refreshReasonListener) {
                self.refreshReasonListener(YES);
            }
        }];

        [self addSubview:promptView];
        [promptView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
}

@end
