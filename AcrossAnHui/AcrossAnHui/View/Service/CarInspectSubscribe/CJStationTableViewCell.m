//
//  CJStationTableViewCell.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/3.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CJStationTableViewCell.h"
#import "Masonry.h"
#import "YYKit.h"
#import "KLCDTextHelper.h"

@implementation CJStationTableViewCell

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
        _evaluatelabel.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
        
        _distanceView = [[UIImageView alloc] init];
        [self.contentView addSubview:_distanceView];
        
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.font = [UIFont systemFontOfSize:15];
        _distanceLabel.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
        [self.contentView addSubview:_distanceLabel];
        
        self.StarView = [[CWStarRateView alloc]initWithFrame:CGRectMake(135.5, 35, CTXScreenWidth*0.35, 15) numberOfStars:5 photostr:@"黄"];
        self.StarView.allowIncompleteStar = YES;
        self.StarView.hasAnimation = NO;
        self.StarView.delegate = self;
        
        [self.contentView addSubview:self.StarView];
    
        _lineLab = [[UILabel alloc] init];
        _lineLab.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_lineLab];
        
        _zhifuView = [[UIImageView alloc] init];
        [self.contentView addSubview:_zhifuView];
        _GoodsView = [[UIImageView alloc] init];
        [self.contentView addSubview:_GoodsView];
        
        _zhifuLabel = [[UILabel alloc] init];
        _zhifuLabel.font = [UIFont systemFontOfSize:14];
        _zhifuLabel.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
        [self.contentView addSubview:_zhifuLabel];
        
        _GoodsLabel = [[UILabel alloc] init];
        _GoodsLabel.font = [UIFont systemFontOfSize:14];
        _GoodsLabel.numberOfLines=0;
        _GoodsLabel.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
        [self.contentView addSubview:_GoodsLabel];
    }
    return self;
}
-(void)setModel:(CarInspectStationModel *)model{
    Model = model;
    [self.stationBackView setImageWithURL:[NSURL URLWithString:model.stationPic] placeholder:[UIImage imageNamed:@"zet-1"]];
    self.stationNamelabel.text = model.stationName;
    self.stationplacelabel.text = model.stationAddr;
    self.evaluatelabel.text = [NSString stringWithFormat:@"%@条评论",model.totalCount];
    self.distanceView.image = [UIImage imageNamed:@"iconfont-sevenbabicon"];
    self.distanceLabel.text = [NSString stringWithFormat:@"%@km",model.distance1];
    CGFloat StarCount = [model.avgStar floatValue];
    self.StarView.scorePercent = StarCount/5;
    
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
        make.right.equalTo(@(-5));
        make.height.equalTo(@20);
        
    }];
    
    [_evaluatelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stationBackView.mas_right).offset(23);
        make.top.equalTo(self.stationplacelabel.mas_bottom).offset(5);
        make.width.equalTo(@(self.bounds.size.width*0.3));
        make.height.equalTo(@14.5);
    }];
  
    CGFloat distanceLabel_width = [KLCDTextHelper WidthForText:self.distanceLabel.text withFontSize:15 withTextHeight:20];
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-5));
        make.top.equalTo(self.stationplacelabel.mas_bottom).offset(4);
        make.height.equalTo(@(20));
        make.width.equalTo(@(distanceLabel_width+5));
    }];
    [_distanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.distanceLabel.left).offset(-2);
        make.top.equalTo(self.stationplacelabel.mas_bottom).offset(7);
        make.width.equalTo(@(12.5));
        make.height.equalTo(@14.5);
    }];
    
    

    if ([model.isCanOnlinePay isEqualToString:@"1"]) {
        
       
        if ([model.personyh integerValue]==0) {
            self.zhifuView.image = [UIImage imageNamed:@"zhifu_chejian"];
            self.zhifuLabel.text = @"支持线上支付";
            self.lineLab.backgroundColor = CTXColor(201, 201, 201);
            [_lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_stationBackView.mas_right).offset(23);
                make.top.equalTo(_evaluatelabel.mas_bottom).offset(10);
                make.height.equalTo(@(1));
                make.width.equalTo(@(self.bounds.size.width-10-135));
            }];
            
            
            [_zhifuView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_stationBackView.mas_right).offset(23);
                make.top.equalTo(_lineLab.mas_bottom).offset(7.5);
                make.height.equalTo(@(15));
                make.width.equalTo(@(15));
            }];
            [_zhifuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_zhifuView.mas_right).offset(5);
                make.top.equalTo(_lineLab.mas_bottom).offset(7.5);
                make.height.equalTo(@(15));
                make.width.equalTo(@(self.bounds.size.width*0.3));
            }];

           
        }else{
            
            self.zhifuView.image = [UIImage imageNamed:@"zhifu_chejian"];
            self.zhifuLabel.text = @"支持线上支付";
            self.lineLab.backgroundColor = CTXColor(201, 201, 201);
            self.GoodsView.image = [UIImage imageNamed:@"jianmian_chejian"];
            self.GoodsLabel.text = [NSString stringWithFormat:@"线上支付减少%@元",model.personyh];
            
            [_lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_stationBackView.mas_right).offset(23);
                make.top.equalTo(_evaluatelabel.mas_bottom).offset(10);
                make.height.equalTo(@(1));
                make.width.equalTo(@(self.bounds.size.width-10-135));
            }];

            [_zhifuView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_stationBackView.mas_right).offset(23);
                make.top.equalTo(_lineLab.mas_bottom).offset(7.5);
                make.height.equalTo(@(15));
                make.width.equalTo(@(15));
            }];
            [_zhifuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_zhifuView.mas_right).offset(5);
                make.top.equalTo(_lineLab.mas_bottom).offset(7.5);
                make.height.equalTo(@(15));
                make.width.equalTo(@(self.bounds.size.width*0.3));
            }];
            [_GoodsView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_stationBackView.mas_right).offset(23);
                make.top.equalTo(_zhifuLabel.mas_bottom).offset(10);
                make.height.equalTo(@(15));
                make.width.equalTo(@(15));
            }];
            [_GoodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_zhifuView.mas_right).offset(5);
                make.top.equalTo(_zhifuLabel.mas_bottom).offset(10);
                make.height.equalTo(@(15));
                make.right.equalTo(@(0));
            }];

        
        }
        
    }else{
   
        self.lineLab.backgroundColor = [UIColor whiteColor];
        self.GoodsLabel.text = @"";
        self.zhifuLabel.text = @"";
        self.zhifuView.image = [UIImage imageNamed:@""];
        self.GoodsView.image = [UIImage imageNamed:@""];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
