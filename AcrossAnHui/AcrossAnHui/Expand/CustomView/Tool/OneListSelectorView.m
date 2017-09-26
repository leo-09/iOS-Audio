//
//  OneListSelectorView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "OneListSelectorView.h"
#import "AppDelegate.h"

@implementation OneListSelectorView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
        
        [self addItemView];
    }
    
    return self;
}

- (void) addItemView {
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 6.0;
    [self addSubview:_bgView];
    [_bgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.right.equalTo(-30);
        make.height.equalTo(@370);
        make.centerY.equalTo(self.centerY);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"重复";
    _titleLabel.textColor = UIColorFromRGB(0x333333);
    _titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_titleLabel];
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@50);
    }];
    
    // 线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
    [_bgView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.bottom.equalTo(_titleLabel.bottom);
        make.height.equalTo(@1);
    }];
    
    _btn = [[UIButton alloc] init];
    [_btn setTitle:@"确定" forState:UIControlStateNormal];
    _btn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [_btn setTitleColor:UIColorFromRGB(CTXThemeColor) forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchDown];
    [_bgView addSubview:_btn];
    [_btn makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@50);
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:self.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 55;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[OneListSelectorViewCell class] forCellReuseIdentifier:@"OneListSelectorViewCell"];
    [_bgView addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(-10);
        make.top.equalTo(_titleLabel.bottom);
        make.bottom.equalTo(_btn.top);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OneListSelectorViewCell *cell = [OneListSelectorViewCell cellWithTableView:tableView];
    OneListSelectorModel *model = _dataSource[indexPath.row];
    model.isMultiSelect = self.isMultiSelect;
    cell.model = model;
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isMultiSelect) {
        OneListSelectorModel *model = _dataSource[indexPath.row];
        model.isSelected = !model.isSelected;
        [tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
    } else {// 单选直接返回数据
        if (self.selectorResultListener) {
            self.selectorResultListener(_dataSource[indexPath.row]);
            
            // 单选直接隐藏
            [self hideAnimation];
        }
    }
}

#pragma mark - event response

- (void) submit {
    if (self.isMultiSelect) {
        // 选出结果
        NSMutableString *result = [[NSMutableString alloc] init];
        for (OneListSelectorModel *model in self.dataSource) {
            if (model.isSelected) {
                [result appendString:[NSString stringWithFormat:@"%@,", model.name]];
            }
        }
        
        
        if (self.selectorResultListener) {
            if ([result isEqualToString:@""]) {
                self.selectorResultListener(@"");
            } else {
                self.selectorResultListener([result substringToIndex:(result.length-1)]);
            }
        }
    }
    
    // 单选直接隐藏
    [self hideAnimation];
}

#pragma mark - getter/setter

- (void) setBtnTitle:(NSString *)btnTitle {
    [_btn setTitle:btnTitle forState:UIControlStateNormal];
}

- (void) setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void) setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    [self.tableView reloadData];
}

#pragma mark - public method

- (void) showView {
    UIWindow *window = [AppDelegate sharedDelegate].window;
    [window addSubview:self];
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    [self showAnimation];
}

#pragma mark - 动画

- (void) hideAnimation {
    if (self.bgView.isHidden) {
        return;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    animation.duration = 0.2; // 持续时间
    animation.delegate = self;
    // 起始帧和终了帧的设定
    animation.fromValue = [NSValue valueWithCGPoint:self.bgView.center];
    
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bgView.center.x, self.bgView.center.y + CTXScreenHeight)];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.bgView.layer removeAllAnimations];
    [self.bgView.layer addAnimation:animation forKey:@"hide-layer"];
}

- (void) showAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    animation.duration = 0.3;
    animation.delegate = self;
    // 起始帧和终了帧的设定
    CGPoint center = [AppDelegate sharedDelegate].window.center;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(center.x, center.y + CTXScreenHeight / 2)];
    animation.toValue = [NSValue valueWithCGPoint:center];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.bgView.layer removeAllAnimations];
    [self.bgView.layer addAnimation:animation forKey:@"show-layer"];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim.duration == 0.2) {
        [self removeFromSuperview];
    }
}

@end
