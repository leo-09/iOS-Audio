//
//  CIllegalQueryCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CIllegalQueryCell.h"
#import "Masonry.h"

@implementation CIllegalQueryCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CIllegalQueryCell";
    // 1.缓存中
    CIllegalQueryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CIllegalQueryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        self.backgroundColor = [UIColor whiteColor];
        
        // leftTopLineView
        _leftTopLineView = [[UIView alloc] init];
        _leftTopLineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [self.contentView addSubview:_leftTopLineView];
        [_leftTopLineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@24);
            make.top.equalTo(@0);
            make.height.equalTo(@32);
            make.width.equalTo(@0.5);
        }];
        
        // leftBottomLineView
        _leftBottomLineView = [[UIView alloc] init];
        _leftBottomLineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [self.contentView addSubview:_leftBottomLineView];
        [_leftBottomLineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@24);
            make.top.equalTo(@32);
            make.bottom.equalTo(@0);
            make.width.equalTo(@0.5);
        }];
        
        // _countLabel
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont systemFontOfSize:12.0];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.backgroundColor = [UIColor orangeColor];
        CTXViewBorderRadius(_countLabel, 12, 0, [UIColor clearColor]);
        [self.contentView addSubview:_countLabel];
        [_countLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(@20);
            make.width.equalTo(@24);
            make.height.equalTo(@24);
        }];
        
        // timeLabel
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _timeLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_countLabel.centerY);
            make.left.equalTo(_countLabel.right).offset(12);
        }];
        
        // iv
        _iv = [[UIImageView alloc] init];
        [self.contentView addSubview:_iv];
        [_iv makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@20);
            make.right.equalTo(@(-12));
            make.width.equalTo(61);
            make.height.equalTo(40.5);
        }];
        
        // 扣分
        UILabel *scoreNameLabel = [[UILabel alloc] init];
        scoreNameLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        scoreNameLabel.font = [UIFont systemFontOfSize:14.0];
        scoreNameLabel.text = @"扣分：";
        [self.contentView addSubview:scoreNameLabel];
        [scoreNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_timeLabel.left);
            make.top.equalTo(_iv.bottom).offset(4);
        }];
        // scoreLabel
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textColor = [UIColor orangeColor];
        _scoreLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_scoreLabel];
        [_scoreLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(scoreNameLabel.centerY);
            make.left.equalTo(scoreNameLabel.right);
        }];
        
        // 罚款
        UILabel *moneyNameLabel = [[UILabel alloc] init];
        moneyNameLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        moneyNameLabel.font = [UIFont systemFontOfSize:14.0];
        moneyNameLabel.text = @"罚款：";
        [self.contentView addSubview:moneyNameLabel];
        [moneyNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(scoreNameLabel.centerY);
            make.left.equalTo(scoreNameLabel.right).offset(100);
        }];
        // moneyLabel
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = CTXColor(246, 67, 83);
        _moneyLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_moneyLabel];
        [_moneyLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(scoreNameLabel.centerY);
            make.left.equalTo(moneyNameLabel.right);
        }];
        
        // addressLabel
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _addressLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_addressLabel];
        [_addressLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_timeLabel.left);
            make.right.equalTo(@(-12));
            make.top.equalTo(scoreNameLabel.bottom).offset(@20);
        }];
        
        // bottomLineView
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [self.contentView addSubview:_bottomLineView];
        [_bottomLineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_timeLabel.left);
            make.right.equalTo(@(-12));
            make.bottom.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
    }
    
    return self;
}

#pragma mark - public method

- (void) setModel:(ViolationInfoModel *)model {
    _model = model;
    
    if ([model.jkbj isEqualToString:@"已交款"]) {
        _iv.image = [UIImage imageNamed:@"yijiaofei"];
    } else {
        if ([model.clbj isEqualToString:@"未处理"]) {
            _iv.image = [UIImage imageNamed:@"weichuli"];
        } else {
            _iv.image = [UIImage imageNamed:@"yichuli"];
        }
    }
    
    _timeLabel.text = _model.wfsj;
    _scoreLabel.text = [NSString stringWithFormat:@"%@分", _model.wfjfs];
    _moneyLabel.text = [NSString stringWithFormat:@"%@元", _model.fkje_dut];
    _addressLabel.text = _model.wfdz;
}

- (void) showLeftTopLineView:(BOOL) hide {
    if (hide) {
        self.leftTopLineView.hidden = YES;
    } else {
        self.leftTopLineView.hidden = NO;
    }
}

- (void) showBottomLineView:(BOOL) hide {
    if (hide) {
        self.bottomLineView.hidden = YES;
    } else {
        self.bottomLineView.hidden = NO;
    }
}

- (void) setCountLabelText:(NSString *)text {
    _countLabel.text = text;
}

@end
