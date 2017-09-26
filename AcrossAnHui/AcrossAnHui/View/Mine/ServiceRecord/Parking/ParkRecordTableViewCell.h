//
//  ParkRecordTableViewCell.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkRecordModel.h"

@interface ParkRecordTableViewCell : UITableViewCell

@property(nonatomic , retain)UILabel * carName;//车牌号 及名字
@property(nonatomic , retain)UILabel * lineLab;
@property(nonatomic , retain)UIImageView * parkTimeImage;
@property(nonatomic , retain)UILabel * parkTimeLab; //停车时间
@property(nonatomic , retain)UIImageView * parkAddressImage;
@property(nonatomic , retain)UILabel * parkAddressLab;// 停车地址
@property(nonatomic , retain)UIImageView * parkBrllingImage;
@property(nonatomic , retain)UILabel * parkBrllingLab; // 停车计费
@property(nonatomic , retain)UIImageView * payStatusImage;
@property(nonatomic , retain)UILabel * payStatusLab; // 支付状态

@property(nonatomic ,retain)ParkRecordModel * model;

@end
