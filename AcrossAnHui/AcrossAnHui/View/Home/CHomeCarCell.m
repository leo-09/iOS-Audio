//
//  CHomeCarCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CHomeCarCell.h"
#import "Masonry.h"
#import "SelectView.h"
#import "YYKit.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"

@implementation CHomeCarCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CHomeCarCell";
    // 1.缓存中
    CHomeCarCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CHomeCarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        [_scrollView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@15);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
        
        _scrollContentView = [[UIView alloc] init];
        [_scrollView addSubview:_scrollContentView];
        [_scrollContentView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_scrollView);
            make.height.equalTo(_scrollView);
        }];
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = UIColorFromRGB(CTXBaseFontColor);// 设置非选中页的圆点颜色
        _pageControl.currentPageIndicatorTintColor = UIColorFromRGB(CTXThemeColor); // 设置选中页的圆点颜色
        [self addSubview:_pageControl];
        [_pageControl makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.bottom.equalTo(@8);
        }];
    }
    
    return self;
}

- (void) setCarIllegals:(NSArray<CarIllegalInfoModel *> *)carIllegals {
    [_scrollContentView removeAllSubviews];
    
    _carIllegals = carIllegals;
    
    // 只有一个 添加车辆 按钮，则不需要pageControl
    if (_carIllegals && _carIllegals.count > 1) {
        _pageControl.hidden = NO;
        _pageControl.numberOfPages = carIllegals.count;//指定页面个数
    } else {
        _pageControl.hidden = YES;
    }
    
    SelectView *lastView;
    for (int i = 0; i < carIllegals.count; i++) {
        CarIllegalInfoModel *model = carIllegals[i];
        
        SelectView *view = [[SelectView alloc] init];
        [view setClickListener:^(id sender) {
            if (self.selectCarListener) {
                self.selectCarListener(model);
            }
        }];
        [_scrollContentView addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
            make.width.equalTo(CTXScreenWidth);
            if (lastView) {
                make.left.equalTo(lastView.right);
            } else {
                make.left.equalTo(@0);
            }
        }];
        
        // 添加内容
        if (!model.jdcjbxx.carID) {
            UILabel *label = [[UILabel alloc] init];
            label.text = @"+添加绑定车辆";
            label.textColor = UIColorFromRGB(CTXThemeColor);
            label.font = [UIFont systemFontOfSize:CTXTextFont];
            label.textAlignment = NSTextAlignmentCenter;
            CTXViewBorderRadius(label, 23, 0.8, UIColorFromRGB(CTXThemeColor));
            [view addSubview:label];
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(view.center);
                make.size.equalTo(CGSizeMake(180, 46));
            }];
        } else  {
            // 车的图标
            UIImageView *imageView = [[UIImageView alloc] init];
            NSURL *url = [NSURL URLWithString:model.jdcjbxx.carImgPath];
            [imageView setImageWithURL:url placeholder:[UIImage imageNamed:@"MY_Car"]];
            imageView.contentMode = UIViewContentModeCenter;
            [view addSubview:imageView];
            // 图标的尺寸 4:3。跟屏幕比640:196
            CGFloat width = CTXScreenWidth * 196.0 / 640.0;
            CGFloat height = width * 3.0 / 4.0;
            [imageView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@12);
                make.centerY.equalTo(view.centerY);
                make.size.equalTo(CGSizeMake(width, height));
            }];
            // 车牌
            UILabel *plateNumberLabel = [[UILabel alloc] init];
            plateNumberLabel.text = [model.jdcjbxx formatPlateNumber];
            plateNumberLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
            plateNumberLabel.font = [UIFont systemFontOfSize:CTXTextFont];
            [view addSubview:plateNumberLabel];
            [plateNumberLabel makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imageView.right).offset(@12);
                make.top.equalTo(@15);
            }];
            
            if ([model.jdcjbxx.success isEqualToString:@"0"]) {// 异常数据 model.jdcjbxx.success=0
                UILabel *abnormalLabel = [[UILabel alloc] init];
                abnormalLabel.text = @"系统维护中，暂时无法查询该车辆的违章信息";
                abnormalLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
                abnormalLabel.font = [UIFont systemFontOfSize:CTXTextFont];
                abnormalLabel.numberOfLines = 0;
                [UILabel changeLineSpaceForLabel:abnormalLabel WithSpace:3];
                [view addSubview:abnormalLabel];
                [abnormalLabel makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(imageView.right).offset(@12);
                    make.top.equalTo(plateNumberLabel.bottom).offset(@8);
                    make.right.equalTo(@(-12));
                }];
            } else {
                UIView *summaryView = [[UIView alloc] init];
                [view addSubview:summaryView];
                [summaryView makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(imageView.right).offset(@12);
                    make.top.equalTo(plateNumberLabel.bottom).offset(@8);
                    make.right.equalTo(@(-12));
                    make.bottom.equalTo(@0);
                }];
                
                // 未处理
                UILabel *untreatedLabel = [[UILabel alloc] init];
                untreatedLabel.text = @"未处理";
                untreatedLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
                untreatedLabel.font = [UIFont systemFontOfSize:CTXTextFont];
                [summaryView addSubview:untreatedLabel];
                [untreatedLabel makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(@0);
                    make.top.equalTo(@0);
                }];
                UILabel *untreatedValueLabel = [[UILabel alloc] init];
                untreatedValueLabel.text = model.jdcwfxxtj.jdcwfxxSum;
                untreatedValueLabel.textColor = UIColorFromRGB(CTXThemeColor);
                untreatedValueLabel.font = [UIFont systemFontOfSize:CTXTextFont];
                [summaryView addSubview:untreatedValueLabel];
                [untreatedValueLabel makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(untreatedLabel.centerX);
                    make.top.equalTo(untreatedLabel.bottom).offset(@4);
                }];
                // 扣分
                UILabel *deductionLabel = [[UILabel alloc] init];
                deductionLabel.text = @"扣分";
                deductionLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
                deductionLabel.font = [UIFont systemFontOfSize:CTXTextFont];
                [summaryView addSubview:deductionLabel];
                [deductionLabel makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(@0);
                    make.centerX.equalTo(summaryView.centerX).offset(@6);
                }];
                UILabel *deductionValueLabel = [[UILabel alloc] init];
                deductionValueLabel.text = model.jdcwfxxtj.wfjfsSum;
                deductionValueLabel.textColor = [UIColor orangeColor];
                deductionValueLabel.font = [UIFont systemFontOfSize:CTXTextFont];
                [summaryView addSubview:deductionValueLabel];
                [deductionValueLabel makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(deductionLabel.centerX);
                    make.top.equalTo(deductionLabel.bottom).offset(@4);
                }];
                // 罚款
                UILabel *fineLabel = [[UILabel alloc] init];
                fineLabel.text = @"罚款";
                fineLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
                fineLabel.font = [UIFont systemFontOfSize:CTXTextFont];
                [summaryView addSubview:fineLabel];
                [fineLabel makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(@0);
                    make.right.equalTo(@0);
                }];
                UILabel *fineValueLabel = [[UILabel alloc] init];
                fineValueLabel.text = model.jdcwfxxtj.fkjeSum;
                fineValueLabel.textColor = [UIColor orangeColor];
                fineValueLabel.font = [UIFont systemFontOfSize:CTXTextFont];
                [summaryView addSubview:fineValueLabel];
                [fineValueLabel makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(fineLabel.centerX);
                    make.top.equalTo(fineLabel.bottom).offset(@4);
                }];
            }
        }
        
        lastView = view;
    }
    
    [_scrollContentView makeConstraints:^(MASConstraintMaker *make) {
        if (lastView) {
            make.right.equalTo(lastView.right);
        } else {
            make.right.equalTo(@0);
        }
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

@end
