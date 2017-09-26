//
//  ParkRecordAlertView.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParkRecordAlertView : UIView{
void (^selectCellListener)(BOOL selectPay);
}
@property(nonatomic,retain)UILabel * titleLab;
@property(nonatomic ,retain)UILabel * messageLab;
@property(nonatomic,strong)UIView *contentView;
- (instancetype)initWithFrame:(CGRect)frame note:(NSString * )noteStr title:(NSString * )TitleStr;
- (void) setSelectCellListener:(void (^)(BOOL selectPay))listener;
@end
