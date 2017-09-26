//
//  ParkRecordTableViewCell.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ParkRecordTableViewCell.h"
#import "Masonry.h"
#import "UILabel+lineSpace.h"

@implementation ParkRecordTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    
    return  self;
}

-(void)initUI {
    
    self.carName = [[UILabel alloc]init];
    self.carName.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.carName];
    
    self.lineLab = [[UILabel alloc]init];
    self.lineLab.backgroundColor = CTXColor(201, 201, 201);
    [self.contentView addSubview:self.lineLab];
    
    self.parkTimeImage = [[UIImageView alloc]init];
    [self.contentView addSubview:self.parkTimeImage];
    self.parkTimeLab = [[UILabel alloc]init];
    self.parkTimeLab.font = [UIFont systemFontOfSize:15];
    self.parkTimeLab.textColor = CTXColor(108, 108, 108);
    [self.contentView addSubview:self.parkTimeLab];
    
    self.parkAddressImage = [[UIImageView alloc]init];
    [self.contentView addSubview:self.parkAddressImage];
    self.parkAddressLab = [[UILabel alloc]init];
    self.parkAddressLab.numberOfLines = 0;
    self.parkAddressLab.font = [UIFont systemFontOfSize:15];
    self.parkAddressLab.textColor = CTXColor(108, 108, 108);
    [self.contentView addSubview:self.parkAddressLab];

    self.parkBrllingImage = [[UIImageView alloc]init];
    [self.contentView addSubview:self.parkBrllingImage];
    self.parkBrllingLab = [[UILabel alloc]init];
    self.parkBrllingLab.font = [UIFont systemFontOfSize:15];
    self.parkBrllingLab.textColor = CTXColor(108, 108, 108);
    [self.contentView addSubview:self.parkBrllingLab];
    
    self.payStatusImage = [[UIImageView alloc]init];
    [self.contentView addSubview:self.payStatusImage];
    self.payStatusLab = [[UILabel alloc]init];
    self.payStatusLab.font = [UIFont systemFontOfSize:15];
    self.payStatusLab.textColor = CTXColor(108, 108, 108);
    [self.contentView addSubview:self.payStatusLab];
 
    
    self.parkTimeImage.image = [UIImage imageNamed:@"park_sj"];
    self.parkAddressImage.image = [UIImage imageNamed:@"park_dc"];
    self.parkBrllingImage.image = [UIImage imageNamed:@"park_q"];
    self.payStatusImage.image = [UIImage imageNamed:@"park_yfk"];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)setModel:(ParkRecordModel *)model{
    if (_model != model) {
        _model = model;
    }
    self.parkAddressLab.font = [UIFont systemFontOfSize:15];
    
    if (model.carname) {
        self.carName.text = [NSString stringWithFormat:@"%@   %@",_model.magCard,_model.carname];
    } else {
        self.carName.text = [NSString stringWithFormat:@"%@   ",_model.magCard];
    }
    
    self.parkTimeLab.text = [NSString stringWithFormat:@"停车时间:%@",_model.parkTime];

    self.parkAddressLab.text = [NSString stringWithFormat:@"停车地址:%@",_model.sitename];
    
    self.parkBrllingLab.text = [NSString stringWithFormat:@"停车计费:%0.2f元",_model.money];
    if ([_model.isPay intValue] == 0) {
        //已付款
        self.payStatusLab.text = @"状态:已付款";
        self.payStatusImage.image = [UIImage imageNamed:@"park_yfk"];
    }else if([_model.isPay intValue]==1){
        self.payStatusLab.text = @"状态:未付款";
        self.payStatusImage.image = [UIImage imageNamed:@"park_wfk"];
    }
    
    self.parkTimeImage.image = [UIImage imageNamed:@"park_sj"];
    self.parkAddressImage.image = [UIImage imageNamed:@"park_dc"];
    self.parkBrllingImage.image = [UIImage imageNamed:@"park_q"];
    [self.carName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@12);
        make.right.equalTo(@(-12));
        make.height.equalTo(@17);
    }];//37
    [self.lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.carName.mas_bottom).offset(19);
        make.left.equalTo(@0);
        make.right.equalTo(@(0));
        make.height.equalTo(@1);
    }];//57
    [self.parkTimeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineLab.mas_bottom).offset(17);
        make.left.equalTo(@12);
        //        make.width.equalTo(@(15));
        //        make.height.equalTo(@15);
    }];
    [self.parkTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineLab.mas_bottom).offset(20);
        make.left.equalTo(@42);
        make.right.equalTo(@(-12));
        make.height.equalTo(@15);
    }];
    [self.parkAddressImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.parkTimeLab.mas_bottom).offset(19);
        make.left.equalTo(@12);
        //        make.width.equalTo(@(15));
        //        make.height.equalTo(@15);
    }];
    
    CGFloat addressHight = [self.parkAddressLab getLabelHeightWithLineSpace:10 WithWidth:CTXScreenWidth-12-20-10-12 WithNumline:0].height;
    [self.parkAddressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.parkTimeLab.mas_bottom).offset(20);
        make.left.equalTo(@42);
        make.width.equalTo(@(CTXScreenWidth-12-20-10-12));
        make.height.equalTo(@(addressHight));
    }];
    [self.parkBrllingImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.parkAddressLab.mas_bottom).offset(17);
        make.left.equalTo(@12);
        //        make.width.equalTo(@(15));
        //        make.height.equalTo(@15);
    }];
    [self.parkBrllingLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.parkAddressLab.mas_bottom).offset(20);
        make.left.equalTo(42);
        make.right.equalTo(@(-12));
        make.height.equalTo(@15);
    }];
    
    [self.payStatusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.parkBrllingLab.mas_bottom).offset(17);
        make.left.equalTo(@12);
        //        make.width.equalTo(@(15));
        //        make.height.equalTo(@15);
    }];
    [self.payStatusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.parkBrllingLab.mas_bottom).offset(20);
        make.left.equalTo(@42);
        make.right.equalTo(@(-12));
        make.height.equalTo(@15);
    }];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
