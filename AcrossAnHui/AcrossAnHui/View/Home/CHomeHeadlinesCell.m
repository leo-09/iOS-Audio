//
//  CHomeHeadlinesCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CHomeHeadlinesCell.h"
#import "Masonry.h"

@implementation CHomeHeadlinesCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CHomeHeadlinesCell";
    // 1.缓存中
    CHomeHeadlinesCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CHomeHeadlinesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        [bgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(@45);
        }];
        
        // 名称
        UILabel *label = [[UILabel alloc]init];
        label.text = @"- 今日头条 -";
        label.font = [UIFont systemFontOfSize:CTXTextFont];
        label.textColor = UIColorFromRGB(CTXBaseFontColor);
        [bgView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(bgView.center);
        }];
        
        static CGFloat bthWith = 75;
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"查看更多" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"shouyemore"] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(CTXBaseFontColor) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        // UIButton的titleEdgeInsets和imageEdgeInsets属性 设置
        btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        // imageView在右 titleLabel在左
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, (bthWith-15), 0, 0)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        
        [btn addTarget:self action:@selector(shoeMoreAdv) forControlEvents:UIControlEventTouchDown];
        [bgView addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
            make.right.equalTo(@(-12));
            make.width.equalTo(@(bthWith));
        }];
        
        // 线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [bgView addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@(-0));
            make.bottom.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
    }
    
    return self;
}

/**
 显示更多头条
 */
- (void) shoeMoreAdv {
    if (self.moreNewsInfoClickListener) {
        self.moreNewsInfoClickListener();
    }
}

@end
