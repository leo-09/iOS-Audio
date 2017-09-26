//
//  DBStationInfoBottomView.h
//  AcrossAnHui
//
//  Created by ztd on 17/6/9.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarInspectStationModel.h"

@interface DBStationInfoBottomView : UIView{
void (^callWay)();
}

@property (nonatomic,copy) UIImageView *leftImageView;
@property (nonatomic,copy) UILabel *DBPriceLab;
@property (nonatomic,copy) UILabel *cheakLab;
@property (nonatomic,copy) UILabel *DBFreeLab;
@property (nonatomic,copy) UIButton *callBtn;
@property (nonatomic,copy) UILabel *lab;
@property (nonatomic,copy) UILabel *Goodlab;
@property (nonatomic,strong)CarInspectStationModel * StationModel;

-(void)sendSumPrice:(NSString *)sumPrice CheckPircr:(NSString *)cheakPrice profitPricr:(NSString *)profitPricr;
-(void)setCallWay:(void(^)())listener;

@end
