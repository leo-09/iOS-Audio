//
//  SelectCarListTableViewCell.m
//  AcrossAnHui
//
//  Created by ztd on 17/6/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "SelectCarListTableViewCell.h"
#import "Masonry.h"
#import "CTX-Prefix.pch"
#import "UILabel+lineSpace.h"

@interface SelectCarListTableViewCell ()

@end

@implementation SelectCarListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _CarImg = [[UIImageView alloc]init];
    [self.contentView addSubview:_CarImg];
    
    _CarName = [[UILabel alloc] init];
    [self.contentView addSubview:_CarName];
    _CarName.font = [UIFont systemFontOfSize:15];
    
    _weizhangLab = [[UILabel alloc]init];
    [self.contentView addSubview:_weizhangLab];
    _weizhangLab.font = [UIFont systemFontOfSize:15];
    _weizhangLab.textAlignment = NSTextAlignmentCenter;
    
    _weizhangValue = [[UILabel alloc]init];
    [self.contentView addSubview:_weizhangValue];
    _weizhangValue.font = [UIFont systemFontOfSize:13];
    _weizhangValue.layer.borderColor = UIColorFromRGB(0xfa5f5a).CGColor;
    _weizhangValue.textColor = UIColorFromRGB(0xfa5f5a);
    _weizhangValue.backgroundColor = UIColorFromRGB(0xfdd4d2);
    _weizhangValue.textAlignment = NSTextAlignmentCenter;
    
    _carPaiLab = [[UILabel alloc]init];
    [self.contentView addSubview:_carPaiLab];
    _carPaiLab.font = [UIFont systemFontOfSize:13];
    _carPaiLab.layer.borderWidth = 1;
    _carPaiLab.layer.cornerRadius = 10;
    _carPaiLab.layer.masksToBounds = YES;
    _carPaiLab.layer.borderColor = UIColorFromRGB(CTXThemeColor).CGColor;
    _carPaiLab.textColor = UIColorFromRGB(CTXThemeColor);
    _carPaiLab.backgroundColor = UIColorFromRGB(0xcdeffa);
    _carPaiLab.textAlignment =NSTextAlignmentCenter;

}

-(void)layoutSubviews{
    [super layoutSubviews];
    [_CarImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12.5);
        make.top.equalTo(@10);
        make.width.equalTo(@80);
        make.height.equalTo(@60);
    }];
    CGSize width_car = [_CarName getLabelHeightWithLineSpace:1 WithWidth:(self.bounds.size.width-17-80-12.5-50-10) WithNumline:2];
    [_CarName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.CarImg.mas_right).offset(17);
        make.top.equalTo(@15);
        make.width.equalTo(@(self.bounds.size.width-17-80-12.5-50-10));
        make.height.equalTo(@(width_car.height));
    }];
    [_carPaiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.CarImg.mas_right).offset(17);
        make.top.equalTo(self.CarName.mas_bottom).offset(7.5);
        make.width.equalTo(@80);
        make.height.equalTo(@25);
    }];
    [_weizhangLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-12.5));
        make.top.equalTo(@20);
        make.width.equalTo(@50);
        make.height.equalTo(@15);
    }];
    [_weizhangValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-12.5));
        make.top.equalTo(self.weizhangLab.mas_bottom).offset(7.5);
        make.width.equalTo(@50);
        make.height.equalTo(@25);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
