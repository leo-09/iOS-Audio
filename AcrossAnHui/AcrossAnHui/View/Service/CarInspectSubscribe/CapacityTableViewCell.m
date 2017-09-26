//
//  CapacityTableViewCell.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/3.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CapacityTableViewCell.h"
#import "Masonry.h"
@implementation CapacityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.nameImg = [[UIImageView alloc]init];
        [self.contentView addSubview:self.nameImg];
        
        self.nameLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.nameLab];
        self.nameLab.font = [UIFont systemFontOfSize:15];
        [self.nameImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(@15);
            make.height.equalTo(@15);
            make.width.equalTo(@15);
        }];
        [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@35);
            make.top.equalTo(@15);
            make.height.equalTo(@15);
            make.width.equalTo(@100);
        }];
    }
    return self;
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
