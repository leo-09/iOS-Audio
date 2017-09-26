//
//  DBStationInfoBottomView.m
//  AcrossAnHui
//
//  Created by ztd on 17/6/9.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "DBStationInfoBottomView.h"
#import "KLCDTextHelper.h"
#import "CTX-Prefix.pch"
#import "Masonry.h"

@interface DBStationInfoBottomView ()
@end

@implementation DBStationInfoBottomView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
        [self layoutSubviews];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
         [self createUI];
         [self layoutSubviews];
    }
    return self;
}

-(void)createUI{
    _lab = [[UILabel alloc]init];
    [self addSubview:_lab];
    _lab.font = [UIFont systemFontOfSize:15];
    _lab.text = @"代办价格:";
    
    _DBPriceLab = [[UILabel alloc]init];
    [self addSubview:_DBPriceLab];
    _DBPriceLab.font = [UIFont systemFontOfSize:15];
   
    _DBPriceLab.textColor = UIColorFromRGB(0xfe6e00);
    _cheakLab = [[UILabel alloc]init];
    [self addSubview:_cheakLab];
    _cheakLab.font = [UIFont systemFontOfSize:14];
   
    _DBFreeLab = [[UILabel alloc]init];
    [self addSubview:_DBFreeLab];
    _DBFreeLab.font = [UIFont systemFontOfSize:14];
    
    _Goodlab = [[UILabel alloc]init];
    [self addSubview:_Goodlab];
    _Goodlab.font = [UIFont systemFontOfSize:14];
    
    _callBtn = [[UIButton alloc]init];
    [self addSubview:_callBtn];
    [_callBtn setTitle:@"呼叫代办司机" forState:UIControlStateNormal];
    [_callBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _callBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_callBtn setBackgroundColor:UIColorFromRGB(CTXThemeColor)];
    [_callBtn addTarget:self action:@selector(callDriver) forControlEvents:UIControlEventTouchUpInside];
    _callBtn.layer.cornerRadius = 5;
    _callBtn.layer.masksToBounds = true;

}

-(void)sendSumPrice:(NSString *)sumPrice CheckPircr:(NSString *)cheakPrice profitPricr:(NSString *)profitPricr{


}
-(void)setStationModel:(CarInspectStationModel *)StationModel{
     _StationModel = StationModel;
     _DBPriceLab.text = [NSString stringWithFormat:@"￥%@",self.StationModel.totalFee];
     _cheakLab.text = [NSString stringWithFormat:@"检测费:￥%@",self.StationModel.yearfee];
     _DBFreeLab.text = [NSString stringWithFormat:@"代办费:￥%@",self.StationModel.agencyFee];
    CGFloat cheak_width = [KLCDTextHelper WidthForText:_cheakLab.text withFontSize:14 withTextHeight:14];
    CGFloat DBFree_width = [KLCDTextHelper WidthForText:_DBFreeLab.text withFontSize:14 withTextHeight:14];
    
    
    [_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(12.5);
        make.top.equalTo(20);
        make.width.equalTo(80);
        make.height.equalTo(15);
    }];
    [_DBPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(12.5+80);
        make.top.equalTo(20);
        make.width.equalTo(200);
        make.height.equalTo(15);
    }];
    [_cheakLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(12.5);
        make.top.equalTo(self.DBPriceLab.mas_bottom).offset(10);
        make.width.equalTo(cheak_width+5);
        make.height.equalTo(15);
        
    }];
    [_DBFreeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cheakLab.mas_right).offset(5);
        make.top.equalTo(_DBPriceLab.mas_bottom).offset(10);
        make.width.equalTo(DBFree_width+5);
        make.height.equalTo(15);
        
    }];
    
    if ([_StationModel.personyh floatValue] > 0) {
        
        _Goodlab.text = [NSString stringWithFormat:@"优惠金额:￥%@",self.StationModel.personyh];
           CGFloat good_width = [KLCDTextHelper WidthForText:_Goodlab.text withFontSize:14 withTextHeight:14];
        [_Goodlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.DBFreeLab.mas_right).offset(5);
            make.top.equalTo(_DBPriceLab.mas_bottom).offset(10);
            make.width.equalTo(good_width+5);
            make.height.equalTo(15);
            
        }];
    }
    
    [_callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(12.5);
        make.top.equalTo(_DBFreeLab.mas_bottom).offset(10);
        make.right.equalTo(-12.5);
        make.height.equalTo(40);
        
    }];

}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    

}
-(void)callDriver{
    if (callWay) {
        callWay();
    }
}
-(void)setCallWay:(void (^)())listener{
    callWay = listener;
}
@end
