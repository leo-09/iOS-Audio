//
//  CTXRefreshGifHeader.m
//  AcrossAnHui
//
//  Created by 张继强 on 16/11/17.
//  modified by liyy on 2017/5/24.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXRefreshGifHeader.h"

@interface CTXRefreshGifHeader()

@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) UIImageView *refreshView;

@end

@implementation CTXRefreshGifHeader

#pragma mark - 重写方法（在这里做一些初始化配置（比如添加子控件））

- (void)prepare {
    [super prepare];
    
    self.mj_h = 82;
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
    self.statusLabel.font = [UIFont systemFontOfSize:12];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.statusLabel];
    
    NSArray *imagearray = @[ [UIImage imageNamed:@"refresh_hong"],
                             [UIImage imageNamed:@"refresh_huang"],
                             [UIImage imageNamed:@"refresh_lv"] ];
    
    self.refreshView = [[UIImageView alloc] init];
    self.refreshView.contentMode = UIViewContentModeScaleAspectFit;
    self.refreshView.image = [UIImage imageNamed:@"refresh_hong"];
    self.refreshView.animationImages = imagearray;
    self.refreshView.animationDuration = 1;
    self.refreshView.animationRepeatCount = MAXFLOAT;
    [self addSubview:self.refreshView];
}

#pragma mark 在这里设置子控件的位置和尺寸

- (void)placeSubviews {
    [super placeSubviews];
    
    self.refreshView.frame = CGRectMake((self.bounds.size.width - 15) / 2, 10, 15, 40);
    self.statusLabel.frame = CGRectMake(0, 60, self.bounds.size.width, 12);
}

#pragma mark 监听scrollView的contentOffset改变

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变

- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听控件的刷新状态

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            [self.refreshView stopAnimating];
            self.statusLabel.text = @"下拉刷新";
            break;
        case MJRefreshStatePulling:
            self.statusLabel.text = @"释放立即刷新";
            break;
        case MJRefreshStateRefreshing:
            [self.refreshView startAnimating];
            self.statusLabel.text = @"正在刷新...";
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）

- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    
//    CGFloat red = 1.0 - 0.5 * pullingPercent;
//    CGFloat green = 0.5 - 0.5 * pullingPercent;
//    CGFloat blue = 0.5 * pullingPercent;
//    self.statusLabel.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}
@end
