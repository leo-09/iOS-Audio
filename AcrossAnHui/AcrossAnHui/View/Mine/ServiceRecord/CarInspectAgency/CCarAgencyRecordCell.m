//
//  CCarAgencyRecordCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/16.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CCarAgencyRecordCell.h"
#import "Masonry.h"
#import "OYCountDownManager.h"
#import "KLCDTextHelper.h"

@implementation CCarAgencyRecordCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CCarAgencyRecordCell";
    // 1.缓存中
    CCarAgencyRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CCarAgencyRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        // 监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:kCountDownNotification object:nil];
        
        // 车牌号
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        [bgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@45);
        }];
        
        _licenseLab = [[UILabel alloc]init];
        _licenseLab.font = [UIFont systemFontOfSize:15];
        [bgView addSubview:_licenseLab];
        [_licenseLab makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12.5);
            make.centerY.equalTo(bgView.centerY);
        }];
        
        // 订单信息
        _stationNameLab = [[UILabel alloc]init];
        _stationNameLab.font = [UIFont systemFontOfSize:14];
        _stationNameLab.textColor = UIColorFromRGB(CTXBaseFontColor);
        [self.contentView addSubview:_stationNameLab];
        [_stationNameLab makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12.5);
            make.right.equalTo(@(-12.5));
            make.top.equalTo(bgView.bottom).offset(15);
            make.height.equalTo(@15);
            
        }];
        
        _orderTimeLab = [[UILabel alloc]init];
        _orderTimeLab.font = [UIFont systemFontOfSize:14];
        _orderTimeLab.textColor = UIColorFromRGB(CTXBaseFontColor);
        [self.contentView addSubview:_orderTimeLab];
        [_orderTimeLab makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12.5);
            make.right.equalTo(@(-12.5));
            make.top.equalTo(_stationNameLab.bottom).offset(15);
            make.height.equalTo(@15);
        }];
        
        _receivingOrderStateLab = [[UILabel alloc]init];
        _receivingOrderStateLab.font = [UIFont systemFontOfSize:14];
        _receivingOrderStateLab.textColor = UIColorFromRGB(CTXBaseFontColor);
        [self.contentView addSubview:_receivingOrderStateLab];
        [_receivingOrderStateLab makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12.5);
            make.right.equalTo(@(-12.5));
            make.top.equalTo(self.orderTimeLab.mas_bottom).offset(15);
            make.height.equalTo(@15);
        }];
        
        //  分割线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self.contentView addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(@10);
        }];
        
        // 操作按钮
        UIView *bjView = [[UIView alloc] init];
        bjView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bjView];
        [bjView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@(0));
            make.top.equalTo(_receivingOrderStateLab.bottom).offset(@15);
            make.bottom.equalTo(lineView.top);
        }];
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.hidden = YES;
        _rightBtn.layer.masksToBounds = YES;
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [_rightBtn setTitleColor:UIColorFromRGB(CTXThemeColor) forState:UIControlStateNormal];
        CTXViewBorderRadius(_rightBtn, 3.0, 1.0, UIColorFromRGB(CTXThemeColor));
        [_rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [bjView addSubview:_rightBtn];
        [_rightBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-12.5));
            make.centerY.equalTo(bjView.centerY);
            make.height.equalTo(@30);
        }];
        
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _payBtn.hidden = YES;
        _payBtn.layer.masksToBounds = YES;
        _payBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [_payBtn setTitleColor:UIColorFromRGB(CTXThemeColor) forState:UIControlStateNormal];
        
        CTXViewBorderRadius(_payBtn, 3.0, 1.0, UIColorFromRGB(CTXThemeColor));
        [_payBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [bjView addSubview:_payBtn];
        [_payBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-12.5));
            make.centerY.equalTo(bjView.centerY);
            make.height.equalTo(@30);
        }];
    }
    
    return self;
}

- (void) btnClick:(UIButton *)btn {
    if ([btn.titleLabel.text isEqualToString:@"评价"]) {
        if (self.commentModelListener) {
            self.commentModelListener(self.model.orderDetail);
        }
    } else if ([btn.titleLabel.text isEqualToString:@"确认订单"]) {
        if (self.completeModelListener) {
            self.completeModelListener(self.model);
        }
    } else {// 去支付
        if (self.payForModelListener) {
            self.payForModelListener(self.model.orderDetail);
        }
    }
}

- (void) setModel:(CarInspectAgencyRecordModel *)model {
    _model = model;
    isShowCountDown = NO;
    
    self.licenseLab.text = [_model.orderDetail formatPlateNumber];
    self.stationNameLab.text = [NSString stringWithFormat:@"车检站：%@", _model.orderDetail.stationName];
    self.orderTimeLab.text = [NSString stringWithFormat:@"下单时间：%@", _model.orderDetail.submitDate];
    self.receivingOrderStateLab.text = [NSString stringWithFormat:@"订单状态：%@", _model.orderDetail.statusName];
    
    _rightBtn.hidden = YES;
    _payBtn.hidden = YES;
    
    CGFloat rightWidth = 0;
    
    // 未支付 未取消 等待支付时间大于0
    if ([_model.orderDetail isWaitPay]) {
        _rightBtn.hidden = YES;
        _payBtn.hidden = NO;
        
        isShowCountDown = YES;
        
        NSString *title = [NSString stringWithFormat:@"去支付（还剩%@）", [_model.orderDetail waitPayTimeStr]];
        [_payBtn setTitle:title forState:UIControlStateNormal];
        rightWidth = [KLCDTextHelper WidthForText:title withFontSize:15 withTextHeight:15];
        // 更新按钮宽度
        [_payBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(rightWidth + 20));
        }];
    }
    
    if (_model.orderDetail.status == EOrderStatus_Driver_TakeCar) {// 状态 已收车
        _rightBtn.hidden = NO;
        _payBtn.hidden = YES;
        
        [_rightBtn setTitle:@"确认订单"  forState:UIControlStateNormal];
        rightWidth = [KLCDTextHelper WidthForText:@"确认订单" withFontSize:15 withTextHeight:15];
        // 更新按钮宽度
        [_rightBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(rightWidth + 20));
        }];
    }
    
    if ((_model.orderDetail.status == EOrderStatus_Completed_Order) &&
        !_model.orderDetail.comment) {// 订单已完成且没有评价
        _rightBtn.hidden = NO;
        _payBtn.hidden = YES;
        
        [_rightBtn setTitle:@"评价"  forState:UIControlStateNormal];
        rightWidth = [KLCDTextHelper WidthForText:@"评价" withFontSize:15 withTextHeight:15];
        // 更新按钮宽度
        [_rightBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(rightWidth + 20));
        }];
    }
}

- (CGFloat)heightForModel:(CarInspectAgencyRecordModel *)model {
    CGFloat height = 220;
    CGFloat btnHeight = 30;
    
    _model = model;
    
    CGFloat heightForModel = height - btnHeight;
    
    // 未支付 未取消 等待支付时间大于0
    if ([_model.orderDetail isWaitPay]) {
        
        heightForModel = height;
    }
    
    if (_model.orderDetail.status == EOrderStatus_Driver_TakeCar) {// 状态 >= 司机已接单
        heightForModel = height;
    }
    
    if ((_model.orderDetail.status == EOrderStatus_Completed_Order) &&
        !_model.orderDetail.comment) {// 订单已完成且没有评价
        heightForModel = height;
    }
    
    return heightForModel;
}

#pragma mark - 倒计时通知回调
- (void)countDownNotification {
    if (isShowCountDown) {
        NSString *time = [_model.orderDetail waitPayTimeStr];
        NSString *title = [NSString stringWithFormat:@"去支付（还剩%@）", time];
        [_payBtn setTitle:title forState:UIControlStateNormal];
        
        if ([time isEqualToString:@"00秒"]) {
            if (self.waitPayTimeListener) {
                self.waitPayTimeListener(_model);
            }
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
