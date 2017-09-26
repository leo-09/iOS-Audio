//
//  GZPayThirdTableViewCell.m
//  AcrossAnHui2
//
//  Created by admin on 16/7/18.
//  Copyright © 2016年 js. All rights reserved.
//

#import "GZPayThirdTableViewCell.h"

#define VIEWWIDTH  [[UIScreen mainScreen] bounds].size.width
#define VIEWHEIGHT  [[UIScreen mainScreen] bounds].size.height
@implementation GZPayThirdTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
        _leftImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_leftImageView];
        
        _paylabel = [[UILabel alloc] init];
        _paylabel.font = [UIFont systemFontOfSize:15];
        [_paylabel sizeToFit];
        [self.contentView addSubview:_paylabel];
        
        _introlabel = [[UILabel alloc] init];
        _introlabel.font = [UIFont systemFontOfSize:14];
        [_introlabel sizeToFit];
        [self.contentView addSubview:_introlabel];
        
        _selectButton = [[UIButton alloc] init];
       // _selectButton.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_selectButton];
        
        _linelabel = [[UILabel alloc] init];
        _linelabel.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0];
        [self.contentView addSubview:_linelabel];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _leftImageView.frame = CGRectMake(12.5, 20, 35, 35);
    _paylabel.frame = CGRectMake(12.5+35+18, 20, self.contentView.bounds.size.width*0.3, 15);
    _introlabel.frame = CGRectMake(12.5+35+18, 45, self.contentView.bounds.size.width*0.8, 12);
    _linelabel.frame = CGRectMake(0, 74, self.contentView.bounds.size.width, 1);
    _selectButton.frame = CGRectMake(self.contentView.bounds.size.width-20-20, 10, 40, 40);
}

@end
