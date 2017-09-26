//
//  CEventMessageCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CEventMessageCell.h"
#import "Masonry.h"

@implementation CEventMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CEventMessageCell";
    // 1.缓存中
    CEventMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CEventMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        // 已读／未读
        _readLabel = [[UILabel alloc] init];
        _readLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _readLabel.textColor = [UIColor whiteColor];
        _readLabel.backgroundColor = CTXColor(34, 172, 56);
        CTXViewBorderRadius(_readLabel, 3.0, 0, [UIColor clearColor]);
        _readLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_readLabel];
        [_readLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@15);
            make.left.equalTo(@12);
            make.width.equalTo(@80);
            make.height.equalTo(@20);
        }];
        
        // 提示
        _tintLabel = [[UILabel alloc] init];
        _tintLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _tintLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        [self.contentView addSubview:_tintLabel];
        [_tintLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.right.equalTo(@(-30));
            make.top.equalTo(_readLabel.bottom).offset(10);
        }];
        
        // 时间值
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        [self.contentView addSubview:_timeLabel];
        [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tintLabel.bottom).offset(10);
            make.left.equalTo(@12);
            make.right.equalTo(@(-30));
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
    
    // 未读消息，颜色加黑
    if ([_model.read isEqualToString:@"1"]) {
        _readLabel.text = @"未读消息";
    } else {
        _readLabel.text = @"已读消息";
    }
    
    _timeLabel.text = [_model dataTime];
    _tintLabel.text = (_model.tip ? _model.tip : @"您有一条订阅信息，请点击查看");
    
    // 画线
    if (isLast) {
        _lineView.hidden = YES;
    } else {
        _lineView.hidden = NO;
    }
}

@end
