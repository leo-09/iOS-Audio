//
//  PrideGainerInfoCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/10.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "PrideGainerInfoCell.h"
#import "Masonry.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"

@implementation PrideGainerInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"PrideGainerInfoCell";
    // 1.缓存中
    PrideGainerInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[PrideGainerInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        CTXViewBorderRadius(bgView, 5.0, 0, [UIColor clearColor]);
        [self.contentView addSubview:bgView];
        [bgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@40);
            make.right.equalTo(@(-40));
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"填写领取信息";
        titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        titleLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        [bgView addSubview:titleLabel];
        [titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgView.centerX);
            make.top.equalTo(@25);
        }];
        
        UIButton *closeBtn = [[UIButton alloc] init];
        [closeBtn setImage:[UIImage imageNamed:@"shut-down"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchDown];
        [bgView addSubview:closeBtn];
        [closeBtn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.right.equalTo(@0);
            make.width.equalTo(@60);
            make.height.equalTo(@50);
        }];
        
        // _nameTextField
        UIView *nameView = [[UIView alloc] init];
        nameView.backgroundColor = [UIColor clearColor];
        CTXViewBorderRadius(nameView, 3.0, 0.8, UIColorFromRGB(0x666666));
        [bgView addSubview:nameView];
        [nameView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@70);
            make.right.equalTo(@(-20));
            make.top.equalTo(titleLabel.bottom).offset(25);
            make.height.equalTo(@35);
        }];
        
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.textColor = UIColorFromRGB(0x999999);
        _nameTextField.font = [UIFont systemFontOfSize:14.0];
        _nameTextField.placeholder = @"请输入您的姓名";
        [nameView addSubview:_nameTextField];
        [_nameTextField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(@(-10));
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = @"姓名";
        nameLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        nameLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        [bgView addSubview:nameLabel];
        [nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(nameView.centerY);
            make.left.equalTo(@20);
        }];
        
        // _phoneTextField
        UIView *phoneView = [[UIView alloc] init];
        phoneView.backgroundColor = [UIColor clearColor];
        CTXViewBorderRadius(phoneView, 3.0, 0.8, UIColorFromRGB(0x666666));
        [bgView addSubview:phoneView];
        [phoneView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@70);
            make.right.equalTo(@(-20));
            make.top.equalTo(nameView.bottom).offset(15);
            make.height.equalTo(@35);
        }];
        
        _phoneTextField = [[UITextField alloc] init];
        _phoneTextField.textColor = UIColorFromRGB(0x999999);
        _phoneTextField.font = [UIFont systemFontOfSize:14.0];
        _phoneTextField.placeholder = @"请输入您的手机号码";
        _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
        [phoneView addSubview:_phoneTextField];
        [_phoneTextField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(@(-10));
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
        
        UILabel *phoneLabel = [[UILabel alloc] init];
        phoneLabel.text = @"手机号";
        phoneLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        phoneLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        [bgView addSubview:phoneLabel];
        [phoneLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(phoneView.centerY);
            make.left.equalTo(@20);
        }];
        
        UILabel *tintLabel = [[UILabel alloc] init];
        tintLabel.text = @"请仔细填写，错误的信息会影响奖品的发放哦";
        tintLabel.numberOfLines = 0;
        tintLabel.font = [UIFont systemFontOfSize:12.0];
        tintLabel.textColor = UIColorFromRGB(0x666666);
        [UILabel changeLineSpaceForLabel:tintLabel WithSpace:8.0];
        [bgView addSubview:tintLabel];
        [tintLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(phoneView.bottom).offset(15);
            make.left.equalTo(phoneView.left);
            make.right.equalTo(phoneView.right);
        }];
        
        UIButton *gainBtn = [[UIButton alloc] init];
        gainBtn.backgroundColor = UIColorFromRGB(CTXThemeColor);
        CTXViewBorderRadius(gainBtn, 4.0, 0, [UIColor clearColor]);
        [gainBtn setTitle:@"领取" forState:UIControlStateNormal];
        [gainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        gainBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [gainBtn addTarget:self action:@selector(gain) forControlEvents:UIControlEventTouchDown];
        [bgView addSubview:gainBtn];
        [gainBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-20));
            make.left.equalTo(@20);
            make.top.equalTo(tintLabel.bottom).offset(20);
            make.height.equalTo(@35);
        }];
    }
    
    return self;
}

- (void) close {
    if (self.closeListener) {
        self.closeListener();
    }
}

- (void) gain {
    if (self.gainPrideListener) {
        self.gainPrideListener(_nameTextField.text, _phoneTextField.text);
    }
}

@end
