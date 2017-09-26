//
//  DBPromotionView.m
//  AcrossAnHui
//
//  Created by ztd on 17/6/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "DBPromotionView.h"
#import "UILabel+lineSpace.h"
#import "Masonry.h"

@implementation DBPromotionView

- (instancetype)initWithFrame:(CGRect)frame note:(NSString * )noteStr title:(NSString * )TitleStr{
    if (self = [super initWithFrame:frame]) {
        
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CTXScreenWidth, CTXScreenHeight)];
        contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self addSubview:contentView];
        self.contentView = contentView;
        
        UIView * alertView = [[UIView alloc]init];
        [self addSubview:alertView];
        alertView.backgroundColor = [UIColor whiteColor];
        alertView.layer.cornerRadius = 6;
        alertView.layer.masksToBounds = YES;
        
        _titleLab = [[UILabel alloc]init];
        _titleLab.text = noteStr;
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.numberOfLines = 0;
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = TitleStr;
        [alertView addSubview:_titleLab];
       
        _noteLab = [[UILabel alloc]init];
        _noteLab.text = noteStr;
        _noteLab.textColor = [UIColor blackColor];
        _noteLab.numberOfLines = 0;
        _noteLab.font = [UIFont systemFontOfSize:15];
        [alertView addSubview:_noteLab];
        CGSize sixe = [_noteLab getLabelHeightWithLineSpace:10 WithWidth:CTXScreenWidth-160 WithNumline:0];
        alertView.center = self.center;
        alertView.bounds = CGRectMake(0, 0,CTXScreenWidth-120, 38+38+sixe.height+25);
        _titleLab.frame = CGRectMake(20, 38, CTXScreenWidth-160, 15);

        _noteLab.frame = CGRectMake(20, 38+15+10, CTXScreenWidth-160, sixe.height);
        
        [self performSelector:@selector(fadeOut) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    }
    return self;
}

- (void)fadeOut{
    [UIView animateWithDuration:2 animations:^{
        self.alpha = 0.0;
    }completion:^(BOOL finished) {
        if (finished){
            [self removeFromSuperview];
        }
    }];
}

@end
