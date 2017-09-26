//
//  CSearchNewsInfoCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CSearchNewsInfoCell.h"
#import "Masonry.h"

@implementation CSearchNewsInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CSearchNewsInfoCell";
    // 1.缓存中
    CSearchNewsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CSearchNewsInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        // 时间图标
        UIImage *more = [UIImage imageNamed:@"more"];
        UIImageView *moreIV = [[UIImageView alloc] initWithImage:more];
        moreIV.contentMode = UIViewContentModeCenter;
        [self addSubview:moreIV];
        [moreIV makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-12));
            make.centerY.equalTo(self);
            make.width.equalTo(@8);
        }];
        
        // 标题
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.right.equalTo(moreIV.left).offset(@(-5));
            make.centerY.equalTo(self);
        }];
        
        // 线
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [self addSubview:self.lineView];
        [self.lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (void) updateLastLineWidth {
    [self.lineView updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
    }];
}

- (void) lineWidth {
    [self.lineView updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
    }];
}

@end
