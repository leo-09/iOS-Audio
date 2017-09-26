//
//  PayView.h
//  AcrossAnHui
//
//  Created by ztd on 17/5/24.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayView : UIView{
void (^PayWay)(NSInteger selectValue);
}

@property (nonatomic,copy) UIImageView *leftImageView;
@property (nonatomic,copy) UILabel *paylabel;
@property (nonatomic,copy) UILabel *introlabel;
@property (nonatomic,copy) UIButton *selectButton;
@property (nonatomic,copy) UILabel *linelabel;

-(void)setPayWay:(void(^)(NSInteger selectValue))listener;

@end
