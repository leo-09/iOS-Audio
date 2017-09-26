//
//  CarinSpectSecondStationTableViewCell.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarInspectStationModel.h"

@interface CarinSpectSecondStationTableViewCell : UITableViewCell

@property (nonatomic,copy) UILabel *staionButton;//位置按钮
@property (nonatomic,copy) UILabel *timelabel;//工作时间
@property (nonatomic,copy) UILabel *carlabel;//车辆类型
@property (nonatomic,copy) UILabel *accesslabel;//外观检测通道
@property (nonatomic,copy) UILabel *containerlabel;//停车容量
@property (nonatomic,copy) UILabel *gaslabel;//尾气检测
@property (nonatomic,copy) UILabel *securelabel;//安检检测
@property (nonatomic,copy) UILabel *linelabel;//下划线
@property (nonatomic,copy) UIButton *stationImageButton;//位置图标按钮

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)stationModel:(CarInspectStationModel *)stationModel value:(int)value;

@end
