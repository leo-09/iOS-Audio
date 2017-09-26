//
//  CEventDetailReusableView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CEventDetailReusableView.h"
#import "Masonry.h"

@implementation CEventDetailReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 名称
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _nameLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        [self addSubview:_nameLabel];
        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(12);
            make.top.equalTo(12);
        }];
        
        // 线
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(CTXThemeColor);
        [self addSubview:_lineView];
        [_lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(12);
            make.top.equalTo(_nameLabel.bottom).equalTo(10);
            make.width.equalTo(_nameLabel.width);
            make.height.equalTo(2);
        }];
    }
    
    return self;
}

- (void) hideLineView {
    [_lineView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
}

@end
