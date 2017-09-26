//
//  YZSortCell.m
//  PullDownMenu
//
//  Created by yz on 16/8/13.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "YZSortCell.h"

@interface YZSortCell ()

@property (nonatomic, strong) UIImageView *cheakView;

@end

@implementation YZSortCell

- (UIImageView *)cheakView {
    if (_cheakView == nil) {
        _cheakView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_menu_gx"]];
        self.accessoryView = _cheakView;
    }
    return _cheakView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGRect frame = CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5);
        UIView *line = [[UIView alloc] initWithFrame:frame];
        
        line.backgroundColor = UIColorFromRGB(0xDCDCDC);
        
        [self addSubview:line];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.cheakView.hidden = !selected;
}

@end
