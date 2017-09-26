//
//  CSearchNewsInfoCollectionViewCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CSearchNewsInfoCollectionViewCell.h"

@implementation CSearchNewsInfoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _nameLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _nameLabel.backgroundColor = [UIColor whiteColor];
        CTXViewBorderRadius(_nameLabel, 4, 0.5, UIColorFromRGB(CTXBLineViewColor));
        [self.contentView addSubview:_nameLabel];
    }
    
    return self;
}

@end
