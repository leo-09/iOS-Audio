//
//  CSystemMessageCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CSystemMessageCell.h"
#import "Masonry.h"

@implementation CSystemMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CSystemMessageCell";
    // 1.缓存中
    CSystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CSystemMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        // 标题
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@18);
            make.left.equalTo(@12);
            make.right.equalTo(@(-24));
        }];
        
        // 时间值
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_timeLabel];
        [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(-16));
            make.left.equalTo(@12);
            make.right.equalTo(@(-24));
        }];
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more"]];
        [self.contentView addSubview:iv];
        [iv makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.centerY);
            make.right.equalTo(@(-12));
        }];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [self.contentView addSubview:_lineView];
        [_lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
    }
    
    return self;
}

- (void) setModel:(MessageCenterModel *)model isLast:(BOOL)isLast {
    _model = model;
    
    _titleLabel.text = _model.tip;
    _timeLabel.text = [_model dataTime];
    
    // 未读消息，颜色加黑
    if ([_model.read isEqualToString:@"1"]) {
        _titleLabel.textColor = UIColorFromRGB(0x000000);
        _timeLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    } else {
        _titleLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _timeLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
    }
    
    // 画线
    if (isLast) {
        _lineView.hidden = YES;
    } else {
        _lineView.hidden = NO;
    }
}

@end
