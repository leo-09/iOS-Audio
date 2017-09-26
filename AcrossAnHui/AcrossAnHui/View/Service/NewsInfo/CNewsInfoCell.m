//
//  CNewsInfoCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CNewsInfoCell.h"
#import "Masonry.h"

@implementation CNewsInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CNewsInfoCell";
    // 1.缓存中
    CNewsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CNewsInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        // 缩略图
        _iconIV = [[UIImageView alloc] init];
        [self addSubview:_iconIV];
        [_iconIV makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.centerY.equalTo(self.centerY);
            make.width.equalTo(@90);
            make.height.equalTo(@68);
        }];
        
        // 时间图标
        UIImage *image = [UIImage imageNamed:@"date"];
        UIImageView *timeIV = [[UIImageView alloc] initWithImage:image];
        [self addSubview:timeIV];
        [timeIV makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconIV.right).offset(@10);
            make.bottom.equalTo(_iconIV.bottom);
            make.width.equalTo(image.size.width);
        }];
        
        // 资讯
        UILabel *label = [[UILabel alloc] init];
        label.text = @"资讯";
        CTXViewBorderRadius(label, 3.0, 0, [UIColor clearColor]);
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = UIColorFromRGB(0x999999);
        [self addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-12));
            make.centerY.equalTo(timeIV.centerY);
            make.width.equalTo(@40);
            make.height.equalTo(@17);
        }];
        
        // 时间值
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = UIColorFromRGB(0x666666);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_timeLabel];
        [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(timeIV.centerY);
            make.left.equalTo(timeIV.right).offset(@10);
            make.right.equalTo(label.left).offset(@(-10));
        }];
        
        // 标题
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 2;
        [self addSubview:_titleLabel];
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_iconIV.top);
            make.left.equalTo(_iconIV.right).offset(@10);
            make.right.equalTo(@(-12));
            make.bottom.equalTo(_timeLabel.top).offset(@(-10));
        }];
        
        // 线
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [self addSubview:_lineView];
        [_lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.right.equalTo(@(-12));
            make.bottom.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (void) isLastCell:(BOOL) isLast {
    if (isLast) {
        _lineView.hidden = YES;
    } else {
        _lineView.hidden = NO;
    }
}

@end
