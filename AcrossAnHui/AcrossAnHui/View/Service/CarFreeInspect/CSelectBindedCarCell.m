//
//  CSelectBindedCarCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CSelectBindedCarCell.h"
#import "Masonry.h"
#import "YYKit.h"

@implementation CSelectBindedCarCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CSelectBindedCarCell";
    // 1.缓存中
    CSelectBindedCarCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CSelectBindedCarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        // 最后一个cell：addBgView
        _addBgView = [[UIView alloc] init];
        _addBgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_addBgView];
        [_addBgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@85);
        }];
        
        UILabel *addCarLabel = [[UILabel alloc] init];
        addCarLabel.text = @"+添加车辆";
        addCarLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        addCarLabel.textColor = UIColorFromRGB(CTXThemeColor);
        addCarLabel.textAlignment = NSTextAlignmentCenter;
        CTXViewBorderRadius(addCarLabel, 18.0, 1.0, UIColorFromRGB(CTXThemeColor));
        [_addBgView addSubview:addCarLabel];
        [addCarLabel makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_addBgView.center);
            make.height.equalTo(@36);
            make.width.equalTo(CTXScreenWidth * (260.0 / 750.0));
        }];
        
        // carBgView
        _carBgView = [[UIView alloc] init];
        _carBgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_carBgView];
        [_carBgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@85);
        }];
        
        _iconIV = [[UIImageView alloc] init];
        [_carBgView addSubview:_iconIV];
        // 图标的尺寸 4:3。跟屏幕比640:232
        CGFloat width = CTXScreenWidth * 128.0 / 750.0;
        CGFloat height = width * 3.0 / 4.0;
        [_iconIV makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.centerY.equalTo(_carBgView.centerY);
            make.size.equalTo(CGSizeMake(width, height));
        }];
        
        // _illegalLabel
        _illegalLabel = [[UILabel alloc] init];
        _illegalLabel.textColor = UIColorFromRGB(0xfa5f5a);
        _illegalLabel.font = [UIFont systemFontOfSize:13.0];
        _illegalLabel.backgroundColor = UIColorFromRGB(0xfdd4d2);
        _illegalLabel.textAlignment = NSTextAlignmentCenter;
        CTXViewBorderRadius(_illegalLabel, 3.0, 1.0, UIColorFromRGB(0xfa5f5a));
        [_carBgView addSubview:_illegalLabel];
        [_illegalLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-15));
            make.bottom.equalTo(@(-20));
            make.width.equalTo(@50);
            make.height.equalTo(@20);
        }];
        
        // _illegalNameLabel
        _illegalNameLabel = [[UILabel alloc] init];
        _illegalNameLabel.text = @"违章";
        _illegalNameLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _illegalNameLabel.font = [UIFont systemFontOfSize:14.0];
        _illegalNameLabel.textAlignment = NSTextAlignmentCenter;
        [_carBgView addSubview:_illegalNameLabel];
        [_illegalNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_illegalLabel.left);
            make.right.equalTo(_illegalLabel.right);
            make.bottom.equalTo(_illegalLabel.top).offset(-7);
        }];
        
        _plateNumberLabel = [[UILabel alloc] init];
        _plateNumberLabel.textAlignment = NSTextAlignmentCenter;
        _plateNumberLabel.textColor = UIColorFromRGB(0xFFFFFF);
        _plateNumberLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _plateNumberLabel.backgroundColor = UIColorFromRGB(0x007ecd);
        CTXViewBorderRadius(_plateNumberLabel, 2.0, 0, [UIColor clearColor]);
        [_carBgView addSubview:_plateNumberLabel];
        [_plateNumberLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@20);
            make.left.equalTo(_iconIV.right).offset(@20);
            make.width.equalTo(@88);
            make.height.equalTo(@22);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = UIColorFromRGB(0x666666);
        _nameLabel.font = [UIFont systemFontOfSize:13.0];
        [_carBgView addSubview:_nameLabel];
        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_plateNumberLabel.left);
            make.top.equalTo(_plateNumberLabel.bottom).offset(@7);
        }];
    }
    
    return self;
}

- (void) setModel:(CarIllegalInfoModel *)model isLastCell:(BOOL) isLastCell {
    _isLastCell = isLastCell;
    if (_isLastCell) {// 对后一个cell，显示 “+添加车辆”
        self.carBgView.hidden = YES;
        self.addBgView.hidden = NO;
    } else {
        _model = model;
        self.carBgView.hidden = NO;
        self.addBgView.hidden = YES;
        
        // 车辆图标
        NSURL *url = [NSURL URLWithString:self.model.jdcjbxx.carImgPath];
        [_iconIV setImageWithURL:url placeholder:[UIImage imageNamed:@"MY_Car"]];
        
        _plateNumberLabel.text = [self.model.jdcjbxx formatPlateNumber];
        _nameLabel.text = self.model.jdcjbxx.name;
        
        if (self.model.jdcjbxx.name) {
            // 有车的品牌
            [_plateNumberLabel updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@20);
            }];
        } else {
            // 没有车的品牌，则剧中
            [_plateNumberLabel updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@31.5);
            }];
        }
        
        if ([self.model.jdcjbxx.success isEqualToString:@"1"]) {// 1 数据获取成功  否则失败
            if ([self.model.jdcwfxxtj.jdcwfxxSum isEqualToString:@"0"]) {// 没有违章
                _illegalNameLabel.hidden = YES;
                _illegalLabel.hidden = YES;
            } else {
                _illegalNameLabel.hidden = NO;
                _illegalLabel.hidden = NO;
                
                _illegalLabel.text = self.model.jdcwfxxtj.jdcwfxxSum;
            }
        } else {//数据查询失败则不显示违章信息
            _illegalNameLabel.hidden = YES;
            _illegalLabel.hidden = YES;
        }
    }
}

@end
