//
//  SubmitOrderTableViewCell.m
//  AcrossAnHui
//
//  Created by ztd on 17/6/9.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "SubmitOrderTableViewCell.h"
#import "Masonry.h"
#import "UILabel+lineSpace.h"

@implementation SubmitOrderTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _nameLab = [[UILabel alloc]init];
    [self.contentView addSubview:_nameLab];
    _nameLab.font  = [UIFont systemFontOfSize:15];
    
    _carAddressLab = [[UILabel alloc]init];
    [self.contentView addSubview:_carAddressLab];
    _carAddressLab.text = @"安徽";
    _carAddressLab.numberOfLines = 0;
    _carAddressLab.font  = [UIFont systemFontOfSize:15];
    
    _textFiled = [[UITextField alloc]init];
    [self.contentView addSubview:_textFiled];
    self.textFiled.font = [UIFont systemFontOfSize:15];
    
    _img = [[UIImageView alloc]init];
    [self.contentView addSubview:_img];
    
    _lineLab = [[UILabel alloc]init];
    [self.contentView addSubview:_lineLab];
    _lineLab.font  = [UIFont systemFontOfSize:15];
    _lineLab.backgroundColor =  [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0];
    [self layoutSubviews];
}

-(void)layoutSubviews{
   
    [super layoutSubviews];
    _nameLab.frame = CGRectMake(12.5, 20, 100, 15);
    
    if (_carAddressLab.text.length==0) {
       _carAddressLab.frame  = CGRectMake(12.5+100+15, 20, CTXScreenWidth-140, 15);
    }else{
     CGSize sixe = [_carAddressLab getLabelHeightWithLineSpace:2 WithWidth:CTXScreenWidth-140 WithNumline:2];
        _carAddressLab.frame  = CGRectMake(12.5+100+15, 20, CTXScreenWidth-140, sixe.height);
    }
   
    _textFiled.frame = CGRectMake(12.5+100+15, 20, 150, 15);
    _img.frame = CGRectMake(CTXScreenWidth-12.5, 20, 15, 15);
    _lineLab.frame = CGRectMake(12.5, self.contentView.bounds.size.height-1, CTXScreenWidth-25, 1);
  
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
