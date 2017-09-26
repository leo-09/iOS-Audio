//
//  CSearchNewsInfoCollectionReusableView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CSearchNewsInfoCollectionReusableView.h"

@implementation CSearchNewsInfoCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hot"]];
        iv.contentMode = UIViewContentModeCenter;
        iv.frame = CGRectMake(12, 15, 15, 15);
        [self addSubview:iv];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 8, 150, 30)];
        label.text = @"热门搜索";
        label.textColor = UIColorFromRGB(CTXTextBlackColor);
        label.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:label];
    }
    
    return self;
}

@end
