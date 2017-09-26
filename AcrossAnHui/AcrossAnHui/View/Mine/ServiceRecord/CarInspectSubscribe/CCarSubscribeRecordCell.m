//
//  CCarSubscribeRecordCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CCarSubscribeRecordCell.h"
#import "Masonry.h"
#import "YYKit.h"

@implementation CCarSubscribeRecordCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CCarSubscribeRecordCell";
    // 1.缓存中
    CCarSubscribeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CCarSubscribeRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:topView];
        [topView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.top.equalTo(@0);
            make.height.equalTo(@50);
        }];
        
        _carLabel = [[UILabel alloc] init];
        _carLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _carLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        [topView addSubview:_carLabel];
        [_carLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.centerY.equalTo(topView.centerY);
        }];
        
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _statusLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        [topView addSubview:_statusLabel];
        [_statusLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-12));
            make.centerY.equalTo(topView.centerY);
        }];
        
        _orderDescLabel = [[UILabel alloc] init];
        _orderDescLabel.backgroundColor = [UIColor clearColor];
        _orderDescLabel.font = [UIFont systemFontOfSize:14.0];
        _orderDescLabel.numberOfLines = 0;
        [self.contentView addSubview:_orderDescLabel];
        [_orderDescLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.right.equalTo(@(-12));
            make.top.equalTo(topView.bottom);
            make.height.equalTo(@90);
        }];
        
        _btnView = [[UIView alloc] init];
        _btnView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_btnView];
        [_btnView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.top.equalTo(_orderDescLabel.bottom);
            make.height.equalTo(@50);
        }];
        
        _rightBtn = [[UIButton alloc] init];
        _rightBtn.backgroundColor = [UIColor whiteColor];
        CTXViewBorderRadius(_rightBtn, 3.0, 1.0, UIColorFromRGB(CTXThemeColor));
        [_rightBtn setTitleColor:UIColorFromRGB(CTXThemeColor) forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_rightBtn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchDown];
        [_btnView addSubview:_rightBtn];
        [_rightBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-12));
            make.centerY.equalTo(_btnView.centerY);
            make.width.equalTo(@85);
            make.height.equalTo(@35);
        }];
        
        _leftBtn = [[UIButton alloc] init];
        _leftBtn.backgroundColor = [UIColor whiteColor];
        CTXViewBorderRadius(_leftBtn, 3.0, 1.0, UIColorFromRGB(0x666666));
        [_leftBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_leftBtn addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchDown];
        [_btnView addSubview:_leftBtn];
        [_leftBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_rightBtn.left).offset(-12);
            make.centerY.equalTo(_btnView.centerY);
            make.width.equalTo(@85);
            make.height.equalTo(@35);
        }];
    }
    
    return self;
}

- (void) setModel:(SubscribeModel *)model {
    _model = model;
    
    _carLabel.text = [_model formatPlateNumber];
    _statusLabel.text = [_model subscribeStatusDesc];
    
    CGFloat height = [self setOrderDescLabelTitle];
    [_orderDescLabel updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    
    if (self.model.orderStatus == 0) {              // 0:已预约
        if (self.model.payStatus == 0) {                // 0:未支付
            if (self.model.paymethod == 0) {                // 0：线上支付
                //  取消预约、支付
                [_leftBtn setTitle:@"取消预约" forState:UIControlStateNormal];
                [_rightBtn setTitle:@"支付" forState:UIControlStateNormal];
                
                [_leftBtn updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@85);
                }];
                [_rightBtn updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@85);
                }];
                [_btnView updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@50);
                }];
            } else {                                        // 1：线下支付
                // 取消预约
                [_leftBtn setTitle:@"取消预约" forState:UIControlStateNormal];
                
                [_leftBtn updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@85);
                }];
                [_rightBtn updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@0);
                }];
                [_btnView updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@50);
                }];
            }
        } else if (self.model.payStatus == 1) {         // 1：已支付
            // 取消预约
            [_leftBtn setTitle:@"取消预约" forState:UIControlStateNormal];
            
            [_leftBtn updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@85);
            }];
            [_rightBtn updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@0);
            }];
            [_btnView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@50);
            }];
        } else {                                        // 2:申请退款中;3退款中;4:已退款
            [_leftBtn updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@0);
            }];
            [_rightBtn updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@0);
            }];
            [_btnView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@20);
            }];
        }
    } else if (self.model.orderStatus == 1) {       // 1：已取消
        if (self.model.payStatus == 1) {                // 1：已支付
            if (self.model.paymethod == 0) {                // 0：线上支付
                if (self.model.payfee > 0) {
                    // 申请退款
                    [_rightBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                    
                    [_leftBtn updateConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(@0);
                    }];
                    [_rightBtn updateConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(@85);
                    }];
                    [_btnView updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@50);
                    }];
                } else {
                    [_leftBtn updateConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(@0);
                    }];
                    [_rightBtn updateConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(@0);
                    }];
                    [_btnView updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@20);
                    }];
                }
            } else {                                        // 1：线下支付
                [_leftBtn updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@0);
                }];
                [_rightBtn updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@0);
                }];
                [_btnView updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@20);
                }];
            }
        } else {                                        // 0:未支付;2:申请退款中;3退款中;4:已退款
            [_leftBtn updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@0);
            }];
            [_rightBtn updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@0);
            }];
            [_btnView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@20);
            }];
        }
    } else {                                        // 2:已完成
        if (self.model.payStatus == 1) {                // 1：已支付
            if (self.model.isEvaluate == 0) {               // 0：未评价
                // 评价
                [_rightBtn setTitle:@"评价" forState:UIControlStateNormal];
                
                [_leftBtn updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@0);
                }];
                [_rightBtn updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@85);
                }];
                [_btnView updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@50);
                }];
            } else {                                        // 1：已评价;
                // 查看评价
                [_rightBtn setTitle:@"查看评价" forState:UIControlStateNormal];
                
                [_leftBtn updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@0);
                }];
                [_rightBtn updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@85);
                }];
                [_btnView updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@50);
                }];
            }
        } else {
            [_leftBtn updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@0);
            }];
            [_rightBtn updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@0);
            }];
            [_btnView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@20);
            }];
        }
    }
    
}

- (CGFloat)heightForModel:(SubscribeModel *)model {
    [self setModel:model];
    
    CGFloat btnViewHeight = 20;
    
    if (self.model.orderStatus == 0) {              // 0:已预约
        if (self.model.payStatus == 0) {                // 0:未支付
            if (self.model.paymethod == 0) {                // 0：线上支付
                btnViewHeight = 50;
            } else {                                        // 1：线下支付
                btnViewHeight = 50;
            }
        } else if (self.model.payStatus == 1) {         // 1：已支付
            btnViewHeight = 50;
        } else {                                        // 2:申请退款中;3退款中;4:已退款
            btnViewHeight = 20;
        }
    } else if (self.model.orderStatus == 1) {       // 1：已取消
        if (self.model.payStatus == 1) {                // 1：已支付
            if (self.model.paymethod == 0) {                // 0：线上支付
                if (self.model.payfee > 0) {
                    btnViewHeight = 50;
                } else {
                    btnViewHeight = 20;
                }
            } else {                                        // 1：线下支付
                btnViewHeight = 20;
            }
        } else {                                        // 0:未支付;2:申请退款中;3退款中;4:已退款
            btnViewHeight = 20;
        }
    } else {                                        // 2:已完成
        if (self.model.payStatus == 1) {                // 1：已支付
            if (self.model.isEvaluate == 0) {               // 0：未评价
                btnViewHeight = 50;
            } else {                                        // 1：已评价;
                btnViewHeight = 50;
            }
        } else {
            btnViewHeight = 20;
        }
    }
    
    CGFloat cellHeight = 50 + [self setOrderDescLabelTitle] + btnViewHeight + 10;
    
    return cellHeight;
}

#pragma mark - private method

- (CGFloat) setOrderDescLabelTitle {
    // 订单详情
    NSString *orderDescription = [self.model subscribeOrderDescription];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10.0f;
    
    NSMutableAttributedString *orderDescText = [[NSMutableAttributedString alloc] initWithString:(orderDescription ? orderDescription : @"")];
    orderDescText.attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:CTXTextFont],
                         NSParagraphStyleAttributeName : paragraphStyle };
    orderDescText.color = UIColorFromRGB(CTXBaseFontColor);
    orderDescText.font = [UIFont systemFontOfSize:CTXTextFont];
    NSString *rangeOfString = [self.model orderMoney] ? [self.model orderMoney] : @"";
    NSRange range = [orderDescription rangeOfString:rangeOfString options:NSBackwardsSearch];
    [orderDescText setColor:[UIColor orangeColor] range:range];
    
    _orderDescLabel.attributedText = orderDescText;
    
    // 计算 text 的高度
    CGSize attSize = [orderDescText boundingRectWithSize:CGSizeMake((CTXScreenWidth-24), MAXFLOAT)
                                                 options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 context:nil].size;
    return attSize.height;
}

#pragma mark - event response

- (void) rightClick:(UIButton *)btn {
    if ([btn.titleLabel.text isEqualToString:@"支付"]) {
        if (self.paySubscribeRecordListener) {
            self.paySubscribeRecordListener(self.model);
        }
    } else if ([btn.titleLabel.text isEqualToString:@"申请退款"]) {
        if (self.refundSubscribeRecordListener) {
            self.refundSubscribeRecordListener(self.model);
        }
    } else if ([btn.titleLabel.text isEqualToString:@"评价"]) {
        if (self.evaluateSubscribeRecordListener) {
            self.evaluateSubscribeRecordListener(self.model);
        }
    } else {    // 查看评价
        if (self.showEvaluateSubscribeRecordListener) {
            self.showEvaluateSubscribeRecordListener(self.model);
        }
    }
}

- (void) leftClick:(UIButton *)btn {
    // 取消预约
    if (self.cancelSubscribeRecordListener) {
        self.cancelSubscribeRecordListener(self.model);
    }
}

@end
