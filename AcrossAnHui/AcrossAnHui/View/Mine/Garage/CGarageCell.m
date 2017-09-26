//
//  CGarageCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/15.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CGarageCell.h"
#import "Masonry.h"
#import "YYKit.h"
#import "UILabel+lineSpace.h"

@implementation CGarageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CGarageCell";
    // 1.缓存中
    CGarageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CGarageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        [bgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.top.equalTo(@15);
        }];
        
        _selectBtn = [[UIButton alloc] init];
        _selectBtn.backgroundColor = [UIColor clearColor];
        [_selectBtn setImage:[UIImage imageNamed:@"weigoux_car"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"goux_car"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(selectCar) forControlEvents:UIControlEventTouchDown];
        [bgView addSubview:_selectBtn];
        [_selectBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
            make.width.equalTo(@0);
        }];
        
        _iconIV = [[UIImageView alloc] init];
        [bgView addSubview:_iconIV];
        // 图标的尺寸 4:3。跟屏幕比640:232
        CGFloat width = CTXScreenWidth * 232.0 / 640.0;
        CGFloat height = width * 3.0 / 4.0;
        [_iconIV makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_selectBtn.right).offset(6);
            make.centerY.equalTo(bgView.centerY);
            make.size.equalTo(CGSizeMake(width, height));
        }];
        
        _parkingIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"park_tc"]];
        [bgView addSubview:_parkingIV];
        [_parkingIV makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconIV.left).offset(-6);
            make.top.equalTo(@0);
        }];
        
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.backgroundColor = CTXColor(254, 110, 0);
        _noteLabel.textColor = [UIColor whiteColor];
        _noteLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [bgView addSubview:_noteLabel];
        [_noteLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-8);
            make.top.equalTo(@12);
            make.size.equalTo(CGSizeMake(0, 0));
        }];
        
        _defaultCarLabel = [[UILabel alloc] init];
        _defaultCarLabel.text = @"默认车辆";
        _defaultCarLabel.backgroundColor = [UIColor redColor];
        _defaultCarLabel.textColor = [UIColor whiteColor];
        _defaultCarLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        CGSize size = [_defaultCarLabel getLabelHeightWithLineSpace:0 WithWidth:CTXScreenWidth WithNumline:1];
        [bgView addSubview:_defaultCarLabel];
        [_defaultCarLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_noteLabel.left).offset(-5);
            make.top.equalTo(@12);
            make.size.equalTo(CGSizeMake(size.width + 6, size.height + 4));
        }];
        
        _plateNumberLabel = [[UILabel alloc] init];
        _plateNumberLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _plateNumberLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _plateNumberLabel.numberOfLines = 0;
        [bgView addSubview:_plateNumberLabel];
        [_plateNumberLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@44);
            make.left.equalTo(_iconIV.right).offset(@10);
            make.right.equalTo(-12);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _nameLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [bgView addSubview:_nameLabel];
        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconIV.right).offset(@10);
            make.top.equalTo(_plateNumberLabel.bottom).offset(@10);
            make.right.equalTo(-12);
        }];
    }
    
    return self;
}

- (void) setModel:(BoundCarModel *)model {
    _model = model;
    
    // 选择器
    if (model.isShowSelect) {
        [_selectBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@40);
        }];
        
        _selectBtn.selected = _model.isSelected;
    } else {
        [_selectBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
    }
    
    // 车辆图标
    NSURL *url = [NSURL URLWithString:self.model.carImgPath];
    [_iconIV setImageWithURL:url placeholder:[UIImage imageNamed:@"MY_Car"]];
    _iconIV.contentMode = UIViewContentModeCenter;
    
    if (_model.isParkingCar) {
        _parkingIV.hidden = NO;
    } else {
        _parkingIV.hidden = YES;
    }
    
    //  备注
    if ([model.note isEqualToString:@""]) {
        [_noteLabel updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(0);
        }];
    } else {
        _noteLabel.text = model.note;
        CTXViewBorderRadius(_noteLabel, 3, 0, [UIColor clearColor]);
        CGSize size = [_noteLabel getLabelHeightWithLineSpace:0 WithWidth:CTXScreenWidth WithNumline:1];
        [_noteLabel updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(size.width + 6);
            make.height.equalTo(size.height + 4);
            
            _noteLabel.textAlignment = NSTextAlignmentCenter;
        }];
    }
    
    // 默认车辆
    if ([model.defaultCar isEqualToString:@"1"]) {
        _defaultCarLabel.hidden = NO;
        CTXViewBorderRadius(_defaultCarLabel, 3, 0, [UIColor clearColor]);
        _defaultCarLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        _defaultCarLabel.hidden = YES;
    }
    
    // 牌照
    _plateNumberLabel.text = [model formatPlateNumber];
    // 名字
    _nameLabel.text = model.name;
}

#pragma mark - private method

- (void) selectCar {
    _selectBtn.selected = !_selectBtn.selected;
    
    if (_selectBtn.selected) {
        self.model.isSelected = YES;
    } else {
        self.model.isSelected = NO;
    }
}

@end
