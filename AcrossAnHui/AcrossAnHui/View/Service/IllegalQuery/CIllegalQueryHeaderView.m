//
//  CIllegalQueryHeaderView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CIllegalQueryHeaderView.h"

@implementation CIllegalQueryHeaderView

#pragma mark - 布局

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        [_scrollView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.width.equalTo(CTXScreenWidth);
            make.height.equalTo(self.frame.size.height - 15);
        }];
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_contentView];
        [_contentView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_scrollView);
            make.height.equalTo(_scrollView);
        }];
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = 0;
        _pageControl.currentPage = _currentIndex;
        _pageControl.pageIndicatorTintColor = UIColorFromRGB(CTXBaseFontColor);
        _pageControl.currentPageIndicatorTintColor = UIColorFromRGB(CTXThemeColor);
        [self addSubview:_pageControl];
        [_pageControl makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(-10));
            make.centerX.equalTo(self);
        }];
        
        // 底部留白,高15
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor clearColor];
        [self addSubview:bottomView];
        [bottomView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.bottom.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@15);
        }];
    }
    
    return self;
}

- (UIView *) itemViewWithCarIllegalInfoModel:(CarIllegalInfoModel *)model index:(int) i {
    UIView *itemView = [[UIView alloc] init];
    itemView.backgroundColor = [UIColor whiteColor];
    
    // 车牌照
    UIImageView *plateIV = [[UIImageView alloc] init];
    [itemView addSubview:plateIV];
    [plateIV makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(itemView.centerX);
        make.top.equalTo(@15);
        make.width.equalTo(@200);
        make.height.equalTo(@64.5);
    }];
    
    UILabel *plateLabel = [[UILabel alloc] init];
    plateLabel.font = [UIFont systemFontOfSize:32.0];
    plateLabel.textAlignment = NSTextAlignmentCenter;
    [itemView addSubview:plateLabel];
    [plateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(plateIV);
    }];
    
    // 车牌照 的值
    if ([model.jdcjbxx.plateType isEqualToString:Compact_Car_PlateType]) {
        plateIV.image = [UIImage imageNamed:@"chepai_lan"];
        plateLabel.textColor = [UIColor whiteColor];
    } else if ([model.jdcjbxx.plateType isEqualToString:@"01"]) {
        plateIV.image = [UIImage imageNamed:@"chepai_huang"];
        plateLabel.textColor = [UIColor blackColor];
    } else {
        plateIV.image = [UIImage imageNamed:@""];
        plateLabel.textColor = [UIColor blackColor];
    }
    
    // 替换空格
    model.jdcjbxx.plateNumber = [model.jdcjbxx.plateNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (model.jdcjbxx.plateNumber.length > 2) {
        NSString *plateNumber1 = [model.jdcjbxx.plateNumber substringToIndex:2];
        NSString *plateNumber2 = [model.jdcjbxx.plateNumber substringFromIndex:2];
        
        plateLabel.text = [NSString stringWithFormat:@"%@ · %@", plateNumber1, plateNumber2];
    }
    
    // 车的备注信息 + 编辑此车
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    noteLabel.tag = i;
    // 添加手势
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    noteLabel.userInteractionEnabled = YES;
    [noteLabel addGestureRecognizer:gesture];
    [itemView addSubview:noteLabel];
    [noteLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(itemView.centerX);
        make.top.equalTo(plateIV.bottom).offset(@15);
    }];
    [self noteLabel:noteLabel carIllegalInfoModel:model];
    
    [self.noteLabels addObject:noteLabel];
    
    // 判断系统是否正常
    if ([model.jdcjbxx.success isEqualToString:@"1"]) {// 数据正常
        // 扣分
        UIView *scoreView = [self circleViewWithColor:[UIColor orangeColor] text:model.jdcwfxxtj.wfjfsSum name:@"扣分"];
        [itemView addSubview:scoreView];
        [scoreView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(itemView.centerX);
            make.top.equalTo(noteLabel.bottom).offset(@15);
            make.width.equalTo(@60);
            make.height.equalTo(@60);
        }];
        
        // 未处理
        UIView *sumView = [self circleViewWithColor:UIColorFromRGB(CTXThemeColor) text:model.jdcwfxxtj.jdcwfxxSum name:@"未处理"];
        [itemView addSubview:sumView];
        [sumView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(scoreView.centerY);
            make.left.equalTo(@12);
            make.width.equalTo(@60);
            make.height.equalTo(@60);
        }];
        
        // 罚款
        UIView *moneyView = [self circleViewWithColor:CTXColor(246, 67, 83) text:model.jdcwfxxtj.fkjeSum name:@"罚款"];
        [itemView addSubview:moneyView];
        [moneyView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(scoreView.centerY);
            make.right.equalTo(@(-12));
            make.width.equalTo(@60);
            make.height.equalTo(@60);
        }];
        
        // 提醒
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:CTXTextFont];
        [itemView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(itemView.centerX);
            make.top.equalTo(scoreView.bottom).offset(@15);
        }];
        NSString *content = [NSString stringWithFormat:@"您已经%@天没有违章,请保持良好的驾驶习惯", model.jdcwfxxtj.ljwwzts];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:(content ? content : @"")];
        text.color = UIColorFromRGB(CTXBaseFontColor);
        NSString *rangeOfString = model.jdcwfxxtj.ljwwzts ? model.jdcwfxxtj.ljwwzts : @"";
        [text setColor:UIColorFromRGB(CTXThemeColor) range:[content rangeOfString:rangeOfString]];
        text.font = [UIFont systemFontOfSize:CTXTextFont];
        label.attributedText = text;
    } else {// 系统维护中
        UIImageView *errorCarIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"errorCar"]];
        [itemView addSubview:errorCarIV];
        [errorCarIV makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(itemView.centerX);
            make.top.equalTo(noteLabel.bottom).offset(@15);
            make.height.equalTo(@60);
            make.width.equalTo(CTXScreenWidth);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(CTXBaseFontColor);
        label.font = [UIFont systemFontOfSize:CTXTextFont];
        label.text = @"系统维护中";
        [itemView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(itemView.centerX);
            make.top.equalTo(errorCarIV.bottom).offset(@15);
        }];
    }
    
    return itemView;
}

- (void) noteLabel:(UILabel *)noteLabel carIllegalInfoModel:(CarIllegalInfoModel *)model {
    if (!model.jdcjbxx.note || [model.jdcjbxx.note isEqualToString:@""]) {
        noteLabel.text = @"编辑此车";
        noteLabel.textColor = UIColorFromRGB(CTXThemeColor);
    } else {
        NSString *content = [NSString stringWithFormat:@"%@  编辑此车", model.jdcjbxx.note];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:(content ? content : @"")];
        text.color = UIColorFromRGB(CTXBaseFontColor);
        [text setColor:UIColorFromRGB(CTXThemeColor) range:NSMakeRange((content.length - 4), 4)];
        text.font = [UIFont systemFontOfSize:CTXTextFont];
        noteLabel.attributedText = text;
    }
}

- (UIView *) circleViewWithColor:(UIColor *)color text:(NSString *)text name:(NSString *)name {
    UIView *circleView = [[UIView alloc] init];
    CTXViewBorderRadius(circleView, 30, 1.0, color);
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:14];
    [circleView addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(circleView.centerX);
        make.top.equalTo(@10);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = name;
    nameLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
    nameLabel.font = [UIFont systemFontOfSize:14];
    [circleView addSubview:nameLabel];
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(circleView.centerX);
        make.bottom.equalTo(@(-10));
    }];
    
    return circleView;
}

// 编辑此车
- (void) tapGesture:(UITapGestureRecognizer*) gesture {
    UILabel *label = (UILabel *) gesture.view;
    CarIllegalInfoModel *model = _dataSource[(int)label.tag];
    
    if (self.editCarListener) {
        self.editCarListener(model.jdcjbxx);
    }
}

#pragma mark - UIScrollViewDelegate

// 在一次拖动滑动中最后被调用，在scrollViewDidScroll之后
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    _currentIndex = point.x / scrollView.frame.size.width;;
    _pageControl.currentPage = _currentIndex;
    
    if (self.selectCurrentIndexListener) {
        self.selectCurrentIndexListener(_currentIndex);
    }
}

#pragma mark - 添加数据

- (void) setDataSource:(NSArray<CarIllegalInfoModel *> *)dataSource {
    _dataSource = dataSource;
    
    // 删除原来的布局
    [self.contentView removeAllSubviews];
    
    // 保存‘编辑此车的label’, 便于后期修改
    if (self.noteLabels) {
        [self.noteLabels removeAllObjects];
    } else {
        self.noteLabels = [[NSMutableArray alloc] init];
    }
    
    if (_dataSource.count < 2) {
        _pageControl.hidden = YES;
    } else {
        _pageControl.hidden = NO;
        _pageControl.numberOfPages = _dataSource.count;
        _pageControl.currentPage = _currentIndex;
    }
    
    // 添加itemView
    UIView *lastView;
    for (int i = 0; i < _dataSource.count; i++) {
        CarIllegalInfoModel *model = _dataSource[i];
        UIView *itemView = [self itemViewWithCarIllegalInfoModel:model index:i];
        [_contentView addSubview:itemView];
        [itemView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.width.equalTo(_scrollView.width);
            make.height.equalTo(_contentView.height);
            if (lastView) {
                make.left.equalTo(lastView.right);
            } else {
                make.left.equalTo(@0);
            }
        }];
        
        lastView = itemView;
    }
    
    // 确定ScrollView的ContentSize
    if (lastView) {
        [_contentView updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastView.right);
        }];
    } else {
        [_contentView updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@0);
        }];
    }
}

- (void) setEditCarNote:(NSString *)note name:(NSString *)name carType:(NSString *)carType {
    if (_dataSource.count > _currentIndex) {
        CarIllegalInfoModel *model = _dataSource[_currentIndex];
        [model.jdcjbxx setNote:note];
        [model.jdcjbxx setName:name];
        [model.jdcjbxx setCarType:carType];
        
        // 重新设置备注
        [self noteLabel:self.noteLabels[_currentIndex] carIllegalInfoModel:model];
    }
}

- (void) setSelectedIndex:(int)index {
    if (_currentIndex == index) {
        return;
    }
    
    _currentIndex = index;
    _pageControl.currentPage = _currentIndex;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_scrollView setContentOffset:CGPointMake(CTXScreenWidth * _currentIndex, 0) animated:NO];
    });
}

@end
