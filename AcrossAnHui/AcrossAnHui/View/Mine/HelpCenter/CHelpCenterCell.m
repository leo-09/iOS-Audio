//
//  CHelpCenterCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CHelpCenterCell.h"
#import "Masonry.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "UILabel+lineSpace.h"

@implementation CHelpCenterCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CHelpCenterCell";
    // 1.缓存中
    CHelpCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CHelpCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _conentLabel = [[UILabel alloc] init];
        _conentLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _conentLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _conentLabel.numberOfLines = 0;
        [self.contentView addSubview:_conentLabel];
        [_conentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.right.equalTo(-12);
            make.top.equalTo(@15);
            make.bottom.equalTo(-15);
        }];
        
        // 线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [self.contentView addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (void) setModel:(HelpCenterModel *)model {
    _model = model;
    _conentLabel.text = _model.content ? _model.content : @"";
    
    [UILabel changeLineSpaceForLabel:_conentLabel WithSpace:6.0];
}

// 根绝数据计算cell的高度
- (CGFloat)heightForModel:(HelpCenterModel *)model {
    [self setModel:model];
    [self layoutIfNeeded];
    
    // 自适应高度
//    CGFloat cellHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    CGFloat cellHeight = [_conentLabel getLabelHeightWithLineSpace:6.0 WithWidth:CTXScreenWidth-24 WithNumline:0].height + 30;
    
    return cellHeight;
}

@end
