//
//  GZStationTableViewCell.m
//  AcrossAnHui2
//
//  Created by admin on 16/7/14.
//  Copyright © 2016年 js. All rights reserved.
//

#import "GZStationTableViewCell.h"
#import "Masonry.h"

@implementation GZStationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _stationBackView = [[UIImageView alloc] init];
        [self.contentView addSubview:_stationBackView];
        
        _stationNamelabel = [[UILabel alloc] init];
        _stationNamelabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_stationNamelabel];
        
        _stationplacelabel = [[UILabel alloc] init];
        _stationplacelabel.font = [UIFont systemFontOfSize:15];
        _stationplacelabel.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
        [self.contentView addSubview:_stationplacelabel];
        
        _evaluatelabel = [[UILabel alloc] init];
        [self.contentView addSubview:_evaluatelabel];
        _evaluatelabel.font = [UIFont systemFontOfSize:15];
        
        
        _distanceView = [[UIImageView alloc] init];
        [self.contentView addSubview:_distanceView];
        
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.font = [UIFont systemFontOfSize:15];
        _distanceLabel.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
        [self.contentView addSubview:_distanceLabel];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [_stationBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12.5);
        make.top.equalTo(@15);
        make.width.equalTo(@100);
        make.height.equalTo(@75);
    }];
    [_stationNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_stationBackView.mas_right).offset(23);
        make.top.equalTo(@(10));
        make.width.equalTo(@(CTXScreenWidth-23-15-100));
        make.height.equalTo(@(25));
    }];
    
    [_stationplacelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stationBackView.mas_right).offset(23);
        make.top.equalTo(self.stationNamelabel.mas_bottom).offset(20);
        make.right.equalTo(@0);
        make.height.equalTo(@20);
        
    }];
    [_evaluatelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stationBackView.mas_right).offset(23);
        make.top.equalTo(self.stationplacelabel.mas_bottom).offset(5);
        make.width.equalTo(@(self.bounds.size.width*0.3));
        make.height.equalTo(@14.5);
    }];
    [_distanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.evaluatelabel.mas_right).offset(self.bounds.size.width*0.06);
        make.top.equalTo(self.stationplacelabel.mas_bottom).offset(7);
        make.width.equalTo(@(12.5));
        make.height.equalTo(@14.5);
    }];
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.distanceView.mas_right).offset(5);
        make.top.equalTo(self.stationplacelabel.mas_bottom).offset(4);
        make.height.equalTo(@(20));
        make.width.equalTo(@(self.bounds.size.width*0.2));
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
