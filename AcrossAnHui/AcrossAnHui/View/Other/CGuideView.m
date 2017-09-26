//
//  CGuideView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CGuideView.h"

@implementation CGuideView

- (instancetype) init {
    if (self = [super init]) {
        [self addScrollView];
        [self addPageControl];
    }
    
    return self;
}

// 添加UIScrollView
- (void) addScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    [scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    [scrollView addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.top.equalTo(-20);
        make.height.equalTo(scrollView);
    }];
    
    NSArray *imgArray = @[ @"ydy_1", @"ydy_2", @"ydy_3" ];
    UIImageView *lastIV;
    for (int i = 0; i < imgArray.count; i++) {
        UIImage *image = [UIImage imageNamed:imgArray[i]];
        UIImageView *iv = [[UIImageView alloc] initWithImage:image];
        [contentView addSubview:iv];
        [iv makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
            make.width.equalTo(scrollView);
            if (lastIV) {
                make.left.equalTo(lastIV.right);
            } else {
                make.left.equalTo(@0);
            }
        }];
        
        lastIV = iv;
    }
    
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastIV.right);
    }];
    
    // 添加按钮
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"现在体验" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(nowExperience) forControlEvents:UIControlEventTouchDown];
    CTXViewBorderRadius(btn, 5, 1.0, [UIColor whiteColor]);
    [contentView addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.height.equalTo(@40);
        make.centerX.equalTo(lastIV);
        make.bottom.equalTo(@(-85));
    }];
}

- (void) addPageControl {
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = 3;
    [self addSubview:_pageControl];
    [_pageControl makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-5));
        make.centerX.equalTo(self);
    }];
}

#pragma mark - event response

- (void) nowExperience {
    if (self.showMainPageListener) {
        self.showMainPageListener();
    }
}

#pragma mark - UIScrollViewDelegate

// scrollView滚动时，就调用该方法。任何offset值改变都调用该方法。即滚动过程中，调用多次
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    _pageControl.currentPage = point.x / scrollView.frame.size.width;
}

@end
