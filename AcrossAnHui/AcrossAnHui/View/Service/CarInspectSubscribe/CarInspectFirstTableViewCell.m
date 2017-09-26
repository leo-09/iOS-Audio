//
//  CarInspectFirstTableViewCell.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectFirstTableViewCell.h"
#import "Masonry.h"

@implementation CarInspectFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _stationLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_stationLabel];
        
        _xinglabel = [[UILabel alloc] init];
        [self.contentView addSubview:_xinglabel];
        
        _locationButton = [[UIButton alloc] init];
        [self.contentView addSubview:_locationButton];
        
        _phoneImg = [[UIImageView alloc]init];
        _phoneImg.image = [UIImage imageNamed:@"iconfont-dianhua"];
        [self.contentView addSubview:_phoneImg];
        
        _phoneButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [self.contentView addSubview:_phoneButton];
        
        _sendButton = [[UIButton alloc] init];
        [_sendButton setBackgroundImage:[UIImage imageNamed:@"Send.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_sendButton];
        
        _linelabel = [[UILabel alloc] init];
        _linelabel.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0];
        [self.contentView addSubview:_linelabel];
        
        _verticalabel = [[UILabel alloc] init];
        _verticalabel.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0];
        [self.contentView addSubview:_verticalabel];
        
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
        _GoodsLabel.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
        [self.contentView addSubview:_GoodsLabel];
        
        _starView = [[CWStarRateView alloc]initWithFrame:CGRectMake(15, 52.5, 100, 15)];
        _starView.allowIncompleteStar = YES;
        _starView.hasAnimation = NO;
        [_starView addGesture];
        [self.contentView addSubview:_starView];
    }
    return self;
}

-(void)setStationModel:(CarInspectStationModel *)stationModel{
    _stationLabel.text = stationModel.stationName;
    CGFloat StarCount = [_stationModel.avgStar floatValue];
    self.starView.scorePercent = StarCount/5;
       
}
-(void)layoutSubviews
{
    [_stationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12.5);
        make.top.equalTo(@15);
        make.width.equalTo(@(CTXScreenWidth-65));
        make.height.equalTo(@30);
    }];
    [_xinglabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12.5);
        make.top.equalTo(_stationLabel.mas_bottom).offset(15);
        make.width.equalTo(@(CTXScreenWidth*0.3));
        make.height.equalTo(@20);
    }];
    
    [_locationButton setTitle:@"地图位置" forState:UIControlStateNormal];
    _locationButton.titleLabel.font = [UIFont systemFontOfSize:14];
    // [_locationButton setTitleColor:[UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_locationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _locationButton.titleEdgeInsets = UIEdgeInsetsMake(2, 0, 2, 20);
    [_locationButton setImage:[UIImage imageNamed:@"gengduo.png"] forState:UIControlStateNormal];
    _locationButton.imageEdgeInsets = UIEdgeInsetsMake(2, 70, 2, 0);
    
    [_phoneImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-15));
        make.top.equalTo(@30);
        make.width.equalTo(@(25));
        make.height.equalTo(@(25));
    }];
    
    [_phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(0));
        make.top.equalTo(@20);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
    [_verticalabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_phoneImg.mas_left).offset(-15);
        make.top.equalTo(@20);
        make.width.equalTo(@(1));
        make.height.equalTo(@(45));
    }];
    [_locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_verticalabel.mas_left).offset(-20);
        make.top.equalTo(_stationLabel.mas_bottom).offset(5);
        make.width.equalTo(@(90));
        make.height.equalTo(@(30));
    }];
    [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_locationButton.mas_left).offset(-1);
        make.top.equalTo(_stationLabel.mas_bottom).offset(15);
        make.width.equalTo(@(11));
        make.height.equalTo(@11);
    }];
     [_linelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.bottom.equalTo(@(-1));
        make.right.equalTo(@(0));
        make.height.equalTo(@(1));
     }];
    [_zhifuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(12.5));
            make.top.equalTo(@85);
            make.width.equalTo(@(21.5));
            make.height.equalTo(@(20));
        }];
    [_zhifuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_zhifuView.mas_right).offset(5);
            make.top.equalTo(@85);
            make.width.equalTo(@(90));
            make.height.equalTo(@(20));
        }];
    
        [_GoodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-10));
            make.top.equalTo(@85);
            make.width.equalTo(@(120));
            make.height.equalTo(@(20));
        }];
    
        [_GoodsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_GoodsLabel.mas_left).offset(-5);
            make.top.equalTo(@85);
            make.width.equalTo(@(20));
            make.height.equalTo(@(20));
        }];
}
@end
