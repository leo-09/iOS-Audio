//
//  CarInspectStationHeadView.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectStationHeadView.h"
#import "CWStarRateView.h"
#import "YYKit.h"
@interface CarInspectStationHeadView()

@property (nonatomic,strong)UIView *contenView;
@property (nonatomic,strong)UIImageView *stationImageView;
@property (nonatomic,strong)CWStarRateView *scoreView;
@property (nonatomic,strong)UILabel *stationNameLabel;
@property (nonatomic,strong)UILabel *addressLabel;
@property (nonatomic,strong)UILabel *commentCountLabel;
@property (nonatomic,strong)UIImageView *distanceIcon;
@property (nonatomic,strong)UILabel *distanceLabel;
@property (nonatomic,copy) UIImageView *zhifuView;//支付标志图片
@property (nonatomic,copy) UIImageView *GoodsView;//优惠标志图片
@property (nonatomic,copy) UILabel *zhifuLabel;//支付
@property (nonatomic,copy) UILabel *GoodsLabel;//优惠
@property (nonatomic,copy) UILabel *lineLab;

@end

@implementation CarInspectStationHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.contenView = [[UIView alloc]init];
        self.contenView.frame = self.frame;
        self.stationImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.scoreView = [[CWStarRateView alloc]initWithFrame:CGRectMake(140, 35, 100, 15)];
        self.scoreView.userInteractionEnabled = NO;
        self.stationNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.addressLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.commentCountLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.distanceIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.distanceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [self addSubview:self.contenView];
        [self.contenView addSubview:self.stationImageView];
        [self.contenView addSubview:self.scoreView];
        [self.contenView addSubview:self.stationNameLabel];
        [self.contenView addSubview:self.addressLabel];
        [self.contenView addSubview:self.commentCountLabel];
        [self.contenView addSubview:self.distanceIcon];
        [self.contenView addSubview:self.distanceLabel];
        self.contenView.backgroundColor = [UIColor whiteColor];
        
        self.stationNameLabel.font = [UIFont systemFontOfSize:14];
        self.addressLabel.font = [UIFont systemFontOfSize:14];
        self.commentCountLabel.font = [UIFont systemFontOfSize:12];
        self.distanceLabel.font = [UIFont systemFontOfSize:12];
 //iconfont-sevenbabicon distance.png
        self.distanceIcon.image = [UIImage imageNamed:@"iconfont-sevenbabicon"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stationImageAction)];
        self.contenView.userInteractionEnabled = YES;
        [self.contenView addGestureRecognizer:tap];
        
        _zhifuView = [[UIImageView alloc] init];
        [self.contenView addSubview:_zhifuView];
        _GoodsView = [[UIImageView alloc] init];
        [self.contenView addSubview:_GoodsView];
        
        _zhifuLabel = [[UILabel alloc] init];
        _zhifuLabel.font = [UIFont systemFontOfSize:14];
        _zhifuLabel.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
        [self.contenView addSubview:_zhifuLabel];
        
        _GoodsLabel = [[UILabel alloc] init];
        _GoodsLabel.font = [UIFont systemFontOfSize:14];
        _GoodsLabel.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
        [self.contenView addSubview:_GoodsLabel];
        
        _lineLab = [[UILabel alloc] init];
        _lineLab.font = [UIFont systemFontOfSize:15];
        
        [self.contenView addSubview:_lineLab];
    }
    return self;
}

- (void)stationImageAction{
    if (self.block!=nil) {
        self.block(self.stationList);
    }
}

- (void)setBlock:(DBHeaderViewBlock)block{
    if (_block!=block) {
        _block = block;
    }
}

- (void)setStationList:(CarInspectStationModel *)stationList{
    if (_stationList!=stationList) {
        _stationList = stationList;
    }
    self.stationNameLabel.text = _stationList.stationName;
    self.addressLabel.text = [_stationList stationAddr];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%@条评论",[stationList totalCount]];
    self.distanceLabel.text = [NSString stringWithFormat:@"%@km",[stationList distance1]];
    [self.stationImageView setImageWithURL:[NSURL URLWithString:[stationList stationPic]] placeholder:[UIImage imageNamed:@"xiangq.png"]];
    self.scoreView.scorePercent = [self.stationList.avgStar floatValue]/5;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.stationImageView.frame = CGRectMake(10, 10, 120, 90);
    self.stationNameLabel.frame = CGRectMake(140, 10, self.frame.size.width-150, 15);
    self.addressLabel.frame = CGRectMake(140, 60, self.frame.size.width-20-140, 15);
    self.commentCountLabel.frame = CGRectMake(140, 70+15, 100, 15);
    self.distanceIcon.frame = CGRectMake(self.frame.size.width-95, 85, 15, 15);
    self.distanceLabel.frame = CGRectMake(self.frame.size.width-75, 85, 65, 15);
    self.lineLab.frame = CGRectMake(10, 119, self.frame.size.width-20, 1);
    self.zhifuView.frame = CGRectMake(10, 134.5, 15, 15);
    self.zhifuLabel.frame = CGRectMake(30, 132.5, 90, 20);
    self.GoodsView.frame = CGRectMake(self.frame.size.width-175, 134.5, 15, 15);
    self.GoodsLabel.frame = CGRectMake(self.frame.size.width-155, 132.5, 140, 20);
    if ([self.stationList.isCanOnlinePay isEqualToString:@"1"]) {
        
        if ([self.stationList.personyh floatValue]>0) {
            _lineLab.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0];
            _zhifuView.image=[UIImage imageNamed:@"zhifu_chejian"];
            _zhifuLabel.text=@"支持线上支付";
            
            _GoodsView.image=[UIImage imageNamed:@"jianmian_chejian"];
            NSString * str = [NSString stringWithFormat:@"线上支付减%@元",self.stationList.personyh];
            self.GoodsLabel.text=str;
            
        } else {
            _lineLab.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0];
            _zhifuView.image=[UIImage imageNamed:@"zhifu_chejian"];
            _zhifuLabel.text=@"支持线上支付";
        }
    } else {
        _lineLab.backgroundColor = [UIColor clearColor];
        _zhifuView.image=[UIImage imageNamed:@""];
        _zhifuLabel.text=@"";
        
        _GoodsView.image=[UIImage imageNamed:@""];
        self.GoodsLabel.text=@"";
    }
}

@end
