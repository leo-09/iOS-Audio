//
//  CarInpactStationImageFoodView.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInpactStationImageFoodView.h"
#import "Masonry.h"

@implementation CarInpactStationImageFoodView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.bgImageView];
        self.bgImageView.image = [UIImage imageNamed:@"zw_.png"];
        self.bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@200);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
    }];
}


@end
