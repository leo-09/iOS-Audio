//
//  GZStationTableViewCell.h
//  AcrossAnHui2
//
//  Created by admin on 16/7/14.
//  Copyright © 2016年 js. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZStationTableViewCell : UITableViewCell

@property (nonatomic,copy) UIImageView *stationBackView;//车站背景图
@property (nonatomic,copy) UILabel *stationNamelabel;//车站名称
@property (nonatomic,copy) UILabel *stationplacelabel;//车站位置
@property (nonatomic,copy) UILabel *evaluatelabel;//车站评价
@property (nonatomic,copy) UILabel *positionlabel;//车站定位按钮
@property (nonatomic,copy) UILabel *distanceLabel;//车站距离
@property (nonatomic,copy) UIImageView *distanceView;//距离标志图片
@property (nonatomic,copy) UILabel *lineLab;//车站距离
@property (nonatomic,copy) UIImageView *zhifuView;//支付标志图片
@property (nonatomic,copy) UIImageView *GoodsView;//优惠标志图片
@property (nonatomic,copy) UILabel *zhifuLabel;//支付
@property (nonatomic,copy) UILabel *GoodsLabel;//优惠

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
