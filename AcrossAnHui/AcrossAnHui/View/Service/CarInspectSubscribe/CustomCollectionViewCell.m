//
//  CustomCollectionViewCell.m
//  AcrossAnHui2
//
//  Created by admin on 16/7/22.
//  Copyright © 2016年 js. All rights reserved.
//

#import "CustomCollectionViewCell.h"
#import "Masonry.h"

@implementation CustomCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _albumView = [[UIImageView alloc] init];
        [self addSubview:_albumView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _albumView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
