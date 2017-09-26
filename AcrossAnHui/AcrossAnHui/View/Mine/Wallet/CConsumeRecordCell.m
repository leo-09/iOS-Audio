//
//  CConsumeRecordCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CConsumeRecordCell.h"
#import "Masonry.h"

@implementation CConsumeRecordCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CConsumeRecordCell";
    // 1.缓存中
    CConsumeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CConsumeRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        // 周几
        _weekLabel = [[UILabel alloc] init];
        _weekLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _weekLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [self.contentView addSubview:_weekLabel];
        [_weekLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@16);
            make.left.equalTo(@16);
        }];
        
        // 月日
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _dateLabel.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:_dateLabel];
        [_dateLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(-16));
            make.centerX.equalTo(_weekLabel.centerX);
        }];
        
        // 车牌
        _carNumberLabel = [[UILabel alloc] init];
        _carNumberLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _carNumberLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [self.contentView addSubview:_carNumberLabel];
        [_carNumberLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@16);
            make.centerX.equalTo(self.contentView.centerX);
        }];
        
        // 车架号
        _carNameLabel = [[UILabel alloc] init];
        _carNameLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _carNameLabel.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:_carNameLabel];
        [_carNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_carNumberLabel.left);
            make.bottom.equalTo(@(-16));
        }];
        
        // moneyLabel
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _moneyLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [self.contentView addSubview:_moneyLabel];
        [_moneyLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@16);
            make.right.equalTo(@(-12));
        }];
        
        // 充值描述
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _descLabel.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:_descLabel];
        [_descLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(-16));
            make.right.equalTo(@(-12));
        }];
        
        // lineView
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [self.contentView addSubview:_lineView];
        [_lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
    }
    
    return self;
}

- (void) setModel:(ConsumeRecordModel *)model isLastCell:(BOOL) isLast {
    _model = model;
    
    _weekLabel.text = (_model.weekOfDay ? _model.weekOfDay : @"--");
    _dateLabel.text = [_model monthDay];
    
    _carNumberLabel.text = (_model.carNumber ? _model.carNumber : @"--");
    _carNameLabel.text = (_model.carname ? _model.carname : @"--");
    
    if (_model.tradeType == 0) {// 交易类型 0-充值；1-扣减
        _moneyLabel.text = [NSString stringWithFormat:@"%.2f", _model.money];
    } else {
        if (_model.money == 0) {    // 消费0元，则不显示 -
            _moneyLabel.text = [NSString stringWithFormat:@"%.2f", _model.money];
        } else {
            _moneyLabel.text = [NSString stringWithFormat:@"-%.2f", _model.money];
        }
    }
    _descLabel.text = (_model.desc ? _model.desc : @"");
    
    if (isLast) {
        _lineView.hidden = YES;
    } else {
        _lineView.hidden = NO;
    }
}

@end
