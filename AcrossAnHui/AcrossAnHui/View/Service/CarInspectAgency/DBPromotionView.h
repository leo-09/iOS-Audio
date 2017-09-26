//
//  DBPromotionView.h
//  AcrossAnHui
//
//  Created by ztd on 17/6/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBPromotionView : UIView

@property(nonatomic,copy)UILabel * titleLab;
@property(nonatomic,copy)UILabel * noteLab;
@property(nonatomic,strong)UIView *contentView;

- (instancetype)initWithFrame:(CGRect)frame note:(NSString * )noteStr title:(NSString * )TitleStr;
@end
