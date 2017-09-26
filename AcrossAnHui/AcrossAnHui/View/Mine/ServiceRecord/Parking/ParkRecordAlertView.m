//
//  ParkRecordAlertView.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ParkRecordAlertView.h"
#import "UILabel+lineSpace.h"
#import "Masonry.h"

@implementation ParkRecordAlertView
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
       
        //标题
        _titleLab = [[UILabel alloc]init];
        _titleLab.text = noteStr;
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.numberOfLines = 0;
        _titleLab.font = [UIFont systemFontOfSize:18];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = TitleStr;
        [alertView addSubview:_titleLab];
       
        //内容
        _messageLab = [[UILabel alloc]init];
        _messageLab.text = noteStr;
        _messageLab.textColor = [UIColor blackColor];
        _messageLab.numberOfLines = 0;
        _messageLab.font = [UIFont systemFontOfSize:15];
        [alertView addSubview:_messageLab];
        
        //分割线
        UILabel * lineLab = [[UILabel alloc]init];
        lineLab.backgroundColor = CTXColor(201, 201, 201);
        [alertView addSubview:lineLab];
        
        //确认按钮
        UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureBtn setTitle:@"是" forState:UIControlStateNormal];
        [sureBtn setTitleColor:CTXColor(3, 163, 214) forState:UIControlStateNormal];
        sureBtn.tag = 10;
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [sureBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [alertView addSubview:sureBtn];
        
        //其他支付
        
        UIButton *  otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [otherBtn setTitle:@"其他支付" forState:UIControlStateNormal];
        [otherBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        otherBtn.tag = 11;
        otherBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [otherBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [alertView addSubview:otherBtn];
        
        //分隔线
        UILabel * labLine = [[UILabel alloc]init];
        labLine.backgroundColor = CTXColor(201, 201, 201);
        [alertView addSubview:labLine];
        
        //删除按钮
        UIButton * delectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delectBtn setImage:[UIImage imageNamed:@"park_tkgb"] forState:UIControlStateNormal];
        [delectBtn addTarget:self action:@selector(delectBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:delectBtn];
        
        //手势
        UITapGestureRecognizer * reocgnizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(delectBtn)];
        reocgnizer.cancelsTouchesInView = NO;
        [contentView addGestureRecognizer:reocgnizer];
        
        CGSize sixe = [_messageLab getLabelHeightWithLineSpace:10 WithWidth:CTXScreenWidth-50-40 WithNumline:0];
        alertView.center = self.center;
        alertView.bounds = CGRectMake(0, 0, CTXScreenWidth-50, 40+20+sixe.height+20+50);
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@22);
            make.right.equalTo(@0);
            make.height.equalTo(@(18));
        }];
        [_messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.width.equalTo(@(CTXScreenWidth-50-40));
            make.top.equalTo(self.titleLab.mas_bottom).offset(20);
            make.height.equalTo(@(sixe.height));
        }];
        
       [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(@0);
           make.right.equalTo(@0);
           make.top.equalTo(self.messageLab.mas_bottom).offset(20);
           make.height.equalTo(@1);
       }];
        
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineLab.mas_bottom).offset(0);
            make.left.equalTo(@0);
            make.width.equalTo(@(alertView.frame.size.width/2));
            make.bottom.equalTo(@0);
        }];
        
        [otherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineLab.mas_bottom).offset(0);
            make.left.equalTo(sureBtn.mas_right).offset(0);
            make.width.equalTo(@(alertView.frame.size.width/2));
            make.bottom.equalTo(@0);
        }];
        [labLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sureBtn.mas_right).offset(0);
            make.top.equalTo(lineLab.mas_bottom).offset(0);
            make.bottom.equalTo(@0);
            make.width.equalTo(@1);
        }];
        
        [delectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(alertView.mas_right).offset(0);
            make.bottom.equalTo(alertView.top).offset(-10);
            make.width.equalTo(@23);
            make.height.equalTo(@23);
        }];

     
    }
    return self;
}
- (void)fadeOut{
    [UIView animateWithDuration:1 animations:^{
        self.alpha = 0.0;
    }completion:^(BOOL finished) {
        if (finished){
           
        }
    }];
}

-(void)onClick:(UIButton *)btn{
   
   [self removeFromSuperview];
   
    if (selectCellListener) {
        
        if (btn.tag==10) {
            selectCellListener(YES);
        }else{
            selectCellListener(NO);
        }
       
    }
}

-(void)delectBtn{
      [self removeFromSuperview];
}

-(void)setSelectCellListener:(void (^)(BOOL))listener{
    selectCellListener = listener;

}

@end
