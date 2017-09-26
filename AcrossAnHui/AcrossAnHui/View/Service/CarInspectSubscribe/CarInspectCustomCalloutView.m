//
//  CarInspectCustomCalloutView.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectCustomCalloutView.h"

@implementation CarInspectCustomCalloutView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.addressLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.addressLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.addressLabel];
        self.addressLabel.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    }
    return self;
}


- (void)setAddressName:(NSString *)addressName{
    
    self.addressLabel.text = addressName;
    _width = [KLCDTextHelper WidthForText:addressName withFontSize:14 withTextHeight:15];
    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.addressLabel.frame = CGRectMake(0, 0, _width, 15);
}

@end
