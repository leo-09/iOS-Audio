//
//  CCarFriendCommentView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/3.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CCarFriendCommentView.h"
#import "AppDelegate.h"
#import "TextViewContentTool.h"

@implementation CCarFriendCommentView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
        
        [self addItemView];
    }
    
    return self;
}

- (void) addItemView {
    _scrollView = [[TPKeyboardAvoidingScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(0);
        make.width.equalTo(CTXScreenWidth);
        make.height.equalTo(CTXScreenHeight);
    }];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:_bgView];
    [_bgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(0);
        make.height.equalTo(@260);
    }];
    
    // 回复楼主
    UILabel *label = [[UILabel alloc] init];
    label.text = @"回复楼主";
    label.font = [UIFont systemFontOfSize:18.0];
    label.textColor = UIColorFromRGB(CTXTextBlackColor);
    [_bgView addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgView.centerX);
        make.top.equalTo(@0);
        make.height.equalTo(@40);
    }];
    
    // 取消
    UIButton *cancleBtn = [[UIButton alloc] init];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:UIColorFromRGB(CTXBaseFontColor) forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [cancleBtn addTarget:self action:@selector(hideAnimation) forControlEvents:UIControlEventTouchDown];
    [_bgView addSubview:cancleBtn];
    [cancleBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(@56);
        make.height.equalTo(@40);
    }];
    
    // 发表
    UIButton *submitBtn = [[UIButton alloc] init];
    [submitBtn setTitle:@"发表" forState:UIControlStateNormal];
    [submitBtn setTitleColor:UIColorFromRGB(CTXThemeColor) forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchDown];
    [_bgView addSubview:submitBtn];
    [submitBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(@56);
        make.height.equalTo(@40);
    }];
    
    // 线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
    [_bgView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.right.equalTo(@(-12));
        make.top.equalTo(label.bottom);
        make.height.equalTo(@0.8);
    }];
    
    // textView
    _textView = [[UITextView alloc] init];
    _textView.delegate = self;
    _textView.textColor = UIColorFromRGB(CTXTextBlackColor);
    _textView.font = [UIFont systemFontOfSize:CTXTextFont];
    [_bgView addSubview:_textView];
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.right.equalTo(@(-12));
        make.top.equalTo(lineView.bottom).offset(8);
        make.bottom.equalTo(@(-10));
    }];
    
    // hintLabel
    _hintLabel = [[UILabel alloc] init];
    _hintLabel.text = @"请输入回复内容";
    _hintLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    _hintLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
    [_bgView addSubview:_hintLabel];
    [_hintLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_textView.left).offset(@6);
        make.top.equalTo(_textView.top).offset(@7);
    }];
}

#pragma mark - public method

// 发表
- (void) submit {
    NSString *content = [TextViewContentTool isContaintContent:self.textView.text];
    if (!content) {
        [self showTextHubWithContent:@"您还没有输入回复内容"];
        return;
    }
    
    if (self.submitCommentListener) {
        [self hideAnimation];
        
        self.submitCommentListener(content);
    }
}

- (void) showView {
    UIWindow *window = [AppDelegate sharedDelegate].window;
    [window addSubview:self];
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    [self showAnimation];
}

- (void) clearCommentContent {
    self.textView.text = @"";
    self.hintLabel.hidden = NO;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    int length = (int) textView.text.length;
    
    if (length > 0) {
        _hintLabel.hidden = YES;
    } else {
        _hintLabel.hidden = NO;
    }
}

#pragma mark - 动画

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
    [self.scrollView.layer removeAllAnimations];
    [self.scrollView.layer addAnimation:animation forKey:@"show-layer"];
}

- (void) hideAnimation {
    if (self.scrollView.isHidden) {
        return;
    }
    
    // 隐藏键盘
    [self.textView resignFirstResponder];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    animation.duration = 0.2; // 持续时间
    animation.delegate = self;
    // 起始帧和终了帧的设定
    animation.fromValue = [NSValue valueWithCGPoint:self.scrollView.center];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.scrollView.center.x, self.scrollView.center.y + CTXScreenHeight)];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.scrollView.layer removeAllAnimations];
    [self.scrollView.layer addAnimation:animation forKey:@"hide-layer"];
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
