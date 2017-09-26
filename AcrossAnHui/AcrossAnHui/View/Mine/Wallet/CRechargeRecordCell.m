
//
//  CRechargeRecordCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CRechargeRecordCell.h"
#import "Masonry.h"

@implementation CRechargeRecordCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CRechargeRecordCell";
    // 1.缓存中
    CRechargeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CRechargeRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        // weekLabel
        _weekLabel = [[UILabel alloc] init];
        _weekLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _weekLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [self.contentView addSubview:_weekLabel];
        [_weekLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@16);
            make.left.equalTo(@16);
        }];
        
        // dateLabel
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _dateLabel.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:_dateLabel];
        [_dateLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(-16));
            make.centerX.equalTo(_weekLabel.centerX);
        }];
        
        // iv
        _iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ZFB"]];
        [self.contentView addSubview:_iv];
        [_iv makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.centerY);
            make.left.equalTo(CTXScreenWidth * 56.0 / 250.0);
        }];
        
        // moneyLabel
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _moneyLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [self.contentView addSubview:_moneyLabel];
        [_moneyLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@16);
            make.left.equalTo(CTXScreenWidth * 100.0 / 250.0);
        }];
        
        // timeLabel
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _timeLabel.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(-16));
            make.left.equalTo(_moneyLabel.left);
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

- (void) setModel:(RechargeRecordModel *)model isLastCell:(BOOL) isLast {
    _model = model;
    
    _weekLabel.text = _model.weekOfDay;
    _dateLabel.text = [_model monthDay];
    
    // 0:支付宝1:微信支付2:银联支付3.用户余额支付
    if (_model.rechargeType == 0) {
        _iv.image = [UIImage imageNamed:@"ZFB"];
    } else {
        _iv.image = [UIImage imageNamed:@"weixin"];
    }
    
    _moneyLabel.text = [NSString stringWithFormat:@"充值%.2f元", [_model.money doubleValue]];
    _timeLabel.text = [_model time];
    
    if (isLast) {
        _lineView.hidden = YES;
    } else {
        _lineView.hidden = NO;
    }
}

@end
