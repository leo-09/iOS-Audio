//
//  CServiceCollectionReusableView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CServiceCollectionReusableView.h"

@implementation CServiceCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        // 图标
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 16, 20, 17)];
        [self addSubview:_imageView];
        
        // 名称
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 320, 50)];
        _nameLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _nameLabel.textColor = [UIColor blackColor];
        [self addSubview:_nameLabel];
        
        // 线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, self.bounds.size.width, 0.5)];
        lineView.backgroundColor = CTXColor(201, 201, 201);
        [self addSubview:lineView];
    }
    
    return self;
}

@end
