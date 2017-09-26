//
//  CarInSpectStationDetailFootview.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInSpectStationDetailFootview.h"
#import "Masonry.h"

@implementation CarInSpectStationDetailFootview

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.moreButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.moreButton];
        [self.moreButton setTitle:@"查看更多评论" forState:UIControlStateNormal];
        self.moreButton.layer.cornerRadius = 5;
        self.moreButton.layer.borderWidth = 1.0;
        [self.moreButton.layer setBorderColor:[UIColor colorWithRed:3/255.0 green:163/255.0 blue:214/255.0 alpha:1.0].CGColor];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.moreButton setTintColor:[UIColor blueColor]];
    [self.moreButton setTitleColor:[UIColor colorWithRed:3/255.0 green:163/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@300);
        make.left.equalTo(@((CTXScreenWidth-300)/2));
        make.top.equalTo(@(15));
    }];
    //60高度
}


@end
