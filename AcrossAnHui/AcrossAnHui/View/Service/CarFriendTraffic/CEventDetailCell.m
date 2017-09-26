//
//  CEventDetailCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CEventDetailCell.h"
#import "Masonry.h"

@implementation CEventDetailCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:CTXTextFont];
        _label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_label];
        [_label makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    return self;
}

- (void) setModel:(EventDetailModel *)model {
    _model = model;
    _label.text = _model.name;
    
    CGFloat height = 30;
    
    if (_model.isSelected) {
        _label.backgroundColor = UIColorFromRGB(CTXThemeColor);
        _label.textColor = [UIColor whiteColor];
     
        if (_model.isCity) {
            CTXViewBorderRadius(_label, 5.0, 0, [UIColor clearColor]);
        } else {
            CTXViewBorderRadius(_label, height / 2, 0, [UIColor clearColor]);
        }
    } else {
        _label.backgroundColor = [UIColor whiteColor];
        _label.textColor = UIColorFromRGB(CTXBaseFontColor);
        
        if (_model.isCity) {
            CTXViewBorderRadius(_label, 5.0, 0.5, UIColorFromRGB(CTXBaseFontColor));
        } else {
            CTXViewBorderRadius(_label, height / 2, 0.5, UIColorFromRGB(CTXBaseFontColor));
        }
    }
}

@end
