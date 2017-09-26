//
//  CInvoiceRecordCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CInvoiceRecordCell.h"
#import "Masonry.h"
#import "KLCDTextHelper.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "UILabel+lineSpace.h"

@implementation CInvoiceRecordCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CInvoiceRecordCell";
    // 1.缓存中
    CInvoiceRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CInvoiceRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        // 多选按钮
        _selectBtn = [[UIButton alloc] init];
        [_selectBtn setImage:[UIImage imageNamed:@"weigoux_car"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"goux_car"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(selectRecord:) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:_selectBtn];
        [_selectBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
            make.width.equalTo(@50);
        }];
        
        // 申请人
        UIImageView *petitionerIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_sqr"]];
        [self.contentView addSubview:petitionerIV];
        [petitionerIV makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_selectBtn.right).offset(12);
            make.top.equalTo(@20);
            make.width.equalTo(@24);
        }];
        _petitionerLabel = [[UILabel alloc] init];
        _petitionerLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _petitionerLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [self.contentView addSubview:_petitionerLabel];
        [_petitionerLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(petitionerIV.centerY);
            make.left.equalTo(petitionerIV.right).offset(10);
            make.right.equalTo(@(-12));
        }];
        
        // 申请金额
        UIImageView *petitionermoneyIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"park_q"]];
        [self.contentView addSubview:petitionermoneyIV];
        [petitionermoneyIV makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(petitionerIV.left);
            make.top.equalTo(petitionerIV.bottom).offset(15);
            make.width.equalTo(@20);
        }];
        _petitionermoneyLabel = [[UILabel alloc] init];
        _petitionermoneyLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _petitionermoneyLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [self.contentView addSubview:_petitionermoneyLabel];
        [_petitionermoneyLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(petitionermoneyIV.centerY);
            make.left.equalTo(petitionermoneyIV.right).offset(10);
            make.right.equalTo(@(-12));
        }];
        
        // 申请时间
        UIImageView *addeddateIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"park_sj"]];
        [self.contentView addSubview:addeddateIV];
        [addeddateIV makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(petitionerIV.left);
            make.top.equalTo(petitionermoneyIV.bottom).offset(15);
            make.width.equalTo(@20);
        }];
        _addeddateLabel = [[UILabel alloc] init];
        _addeddateLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _addeddateLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [self.contentView addSubview:_addeddateLabel];
        [_addeddateLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(addeddateIV.centerY);
            make.left.equalTo(addeddateIV.right).offset(10);
            make.right.equalTo(@(-12));
        }];
        
        // 邮寄地址
        UIImageView *addressIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"park_dc"]];
        [self.contentView addSubview:addressIV];
        [addressIV makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(petitionerIV.left);
            make.top.equalTo(addeddateIV.bottom).offset(15);
            make.width.equalTo(@20);
        }];
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _addressLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _addressLabel.numberOfLines = 0;
        [self.contentView addSubview:_addressLabel];
        [_addressLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(addressIV.top);
            make.left.equalTo(addressIV.right).offset(10);
            make.right.equalTo(@(-12));
        }];
        
        // 分隔
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self.contentView addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(@10);
        }];
    }
    
    return self;
}

- (void) setModel:(InvoiceRecordModel *)model {
    _model = model;
    
    if (_model.isShowSelected) {
        [_selectBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@50);
        }];
        
        if (_model.isSelected) {
            _selectBtn.selected = YES;
            self.contentView.backgroundColor = UIColorFromRGB(0xECFAFF);
        } else {
            _selectBtn.selected = NO;
            self.contentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        }
    } else {
        [_selectBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
        
        self.contentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    }
    
    _petitionerLabel.text = [NSString stringWithFormat:@"申请人：%@", _model.petitioner];
    _petitionermoneyLabel.text = [NSString stringWithFormat:@"申请金额：%.2f元", [_model.petitionermoney doubleValue]];
    _addeddateLabel.text = [NSString stringWithFormat:@"申请时间：%@", _model.addeddate];
    _addressLabel.text = [NSString stringWithFormat:@"邮寄地址：%@", _model.address];
    [UILabel changeLineSpaceForLabel:_addressLabel WithSpace:10];
    
    [self setNeedsLayout];
}

- (CGFloat)heightForModel:(InvoiceRecordModel *)model {
    CGFloat height = (15 + 20) * 3 + 15;
    
    CGFloat width;
    if (model.isShowSelected) {
        width = (CTXScreenWidth - 50 - 12 - 12 - 10 - 20);
    } else {
        width = (CTXScreenWidth - 12 - 12 - 10 - 20);
    }
    _addressLabel.text = [NSString stringWithFormat:@"邮寄地址：%@", model.address];
    height += [_addressLabel getLabelHeightWithLineSpace:10 WithWidth:width WithNumline:0].height;
    
    height += 20;
    height += 10;
    
    return height;
}

#pragma mark - event response

- (void) selectRecord:(UIButton *) btn {
    btn.selected = !btn.selected;
    
    if (btn.isSelected) {
        _model.isSelected = YES;
        self.contentView.backgroundColor = UIColorFromRGB(0xECFAFF);
    } else {
        _model.isSelected = NO;
        self.contentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    }
}

@end
