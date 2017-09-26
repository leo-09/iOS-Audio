//
//  CarInspectImageCollectionViewCell.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/10.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectImageCollectionViewCell.h"
#import "YYKit.h"

@implementation CarInspectImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userPlImag = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.userPlImag];
        self.userPlImag.image = [UIImage imageNamed:@"zet-1.png"];
    }
    return self;
}

- (void)setImagUrl:(NSString *)imagUrl{
    if (_imagUrl!=imagUrl) {
        _imagUrl = imagUrl;
    }
    if ([self.imagUrl isEqual:[NSNull null]]) {
        self.imagUrl = @"";
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.userPlImag setImageWithURL:[NSURL URLWithString:self.imagUrl] placeholder:[UIImage imageNamed:@"zet-1.png"]];
    });
    [self layoutSubviews];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.userPlImag.frame = self.contentView.frame;
}

@end
