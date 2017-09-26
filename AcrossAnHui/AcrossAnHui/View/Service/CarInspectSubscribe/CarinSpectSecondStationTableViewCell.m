//
//  CarinSpectSecondStationTableViewCell.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarinSpectSecondStationTableViewCell.h"
#import "Masonry.h"
#import "UILabel+lineSpace.h"

@implementation CarinSpectSecondStationTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        _stationImageButton = [[UIButton alloc] init];
        [self.contentView addSubview:_stationImageButton];
        
        _staionButton = [[UILabel alloc] init];
        _staionButton.font = [UIFont  systemFontOfSize:14];
        _staionButton.textColor = UIColorFromRGB(CTXBaseFontColor);
        [self.contentView addSubview:_staionButton];
        _timelabel = [[UILabel alloc] init];
        [self.contentView addSubview:_timelabel];
        
        _carlabel = [[UILabel alloc] init];
        _carlabel.numberOfLines = 0;
        _carlabel.font = [UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:_carlabel];
        _accesslabel = [[UILabel alloc] init];
        
        [self.contentView addSubview:_accesslabel];
        _containerlabel = [[UILabel alloc] init];
        
        [self.contentView addSubview:_containerlabel];
        _gaslabel = [[UILabel alloc] init];
        
        [self.contentView addSubview:_gaslabel];
        _securelabel = [[UILabel alloc] init];
        [self.contentView addSubview:_securelabel];
    }
    return self;
}

-(void)stationModel:(CarInspectStationModel *)stationModel value:(int) value{
    NSMutableArray *array = [NSMutableArray array];
    if (value==1) {
        for (CarInspectCarType*checkCarlist in stationModel.carTypeList) {
            [array addObject:checkCarlist.carTypeName];
        }
    } else if (value == 2){
        for (CarInspectCarType*checkCarlist in stationModel.carTypeList) {
            [array addObject:checkCarlist.dictname];
        }
    }
    NSString *totalString = [array componentsJoinedByString:@","];
    _carlabel.text = [NSString stringWithFormat:@"检测车辆类型:%@",totalString];
    _carlabel.font = [UIFont systemFontOfSize:14];
    _carlabel.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
    [_stationImageButton setBackgroundImage:[UIImage imageNamed:@"iconfont-sevenbabicon.png"] forState:UIControlStateNormal];
    self.staionButton.text = stationModel.stationAddr;
    //[cell.staionButton setTitle:self.stationList.stationAddr forState:UIControlStateNormal];
    self.staionButton.text = stationModel.stationAddr;
    self.timelabel.text = [NSString stringWithFormat:@"工作时间:%@",stationModel.stationWorkTime];
    self.timelabel.font = [UIFont systemFontOfSize:14];
    self.timelabel.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
    self.accesslabel.text = [NSString stringWithFormat:@"外观检查通道:%@",stationModel.apperaCheck];
    self.accesslabel.font = [UIFont systemFontOfSize:14];
    self.accesslabel.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
    //安检检测线
    self.containerlabel.text = [NSString stringWithFormat:@"安检检测线:%@",stationModel.securityCheck];
    self.containerlabel.font = [UIFont systemFontOfSize:14];
    self.containerlabel.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
    
    self.gaslabel.text = [NSString stringWithFormat:@"尾气检测线:%@",stationModel.tailGasCheck];
    self.gaslabel.font = [UIFont systemFontOfSize:14];
    self.gaslabel.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
    self.securelabel.text =[NSString stringWithFormat:@"停车容量:%@",stationModel.parkCapacity];
    
    self.securelabel.font = [UIFont systemFontOfSize:14];
    self.securelabel.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
    
    [_stationImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12.5);
        make.top.equalTo(@12);
        make.width.equalTo(@12.5);
        make.height.equalTo(@14.5);
    }];
    _staionButton.numberOfLines = 0;
    CGFloat ff = [_staionButton getLabelHeightWithLineSpace:5 WithWidth:CTXScreenWidth -30 WithNumline:0].height;
    [_staionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(_stationImageButton.mas_right).offset(5);
        make.right.equalTo(@(-5));
        make.height.equalTo(@(ff));
    }];
    
    [_timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_staionButton.mas_bottom).offset(5);
        make.left.equalTo(@12.5);
        make.width.equalTo(@(CTXScreenWidth-25));
        make.height.equalTo(@20);
    }];
    
    CGFloat frame = [_carlabel getLabelHeightWithLineSpace:5 WithWidth:CTXScreenWidth-25 WithNumline:0].height;
    [_carlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timelabel.mas_bottom).offset(5);
        make.left.equalTo(@12.5);
        make.width.equalTo(@(CTXScreenWidth-25));
        make.height.equalTo(@(frame));
    }];
    [_accesslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_carlabel.mas_bottom).offset(5);
        make.left.equalTo(@12.5);
        make.width.equalTo(@(self.bounds.size.width*0.9));
        make.height.equalTo(@20);
    }];
    [_gaslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_accesslabel.mas_bottom).offset(5);
        make.left.equalTo(@12.5);
        make.width.equalTo(@(CTXScreenWidth-25));
        make.height.equalTo(@20);
    }];
    [_containerlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_gaslabel.mas_bottom).offset(5);
        make.left.equalTo(@12.5);
        make.width.equalTo(@(CTXScreenWidth-25));
        make.height.equalTo(@20);
    }];
    
    [_securelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_containerlabel.mas_bottom).offset(5);
        make.left.equalTo(@12.5);
        make.width.equalTo(@(self.bounds.size.width*0.9));
        make.height.equalTo(@20);
    }];
}

@end
