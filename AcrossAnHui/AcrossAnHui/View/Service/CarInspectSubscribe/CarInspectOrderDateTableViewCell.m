//
//  CarInspectOrderDateTableViewCell.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectOrderDateTableViewCell.h"

@implementation CarInspectOrderDateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _orderDatelabel = [[UILabel alloc] init];
        _orderDatelabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_orderDatelabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _orderDatelabel.frame = CGRectMake(0, 12, CTXScreenWidth-46, 20);
    
}

@end
