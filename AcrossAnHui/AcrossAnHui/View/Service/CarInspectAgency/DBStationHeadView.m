//
//  DBStationHeadView.m
//  AcrossAnHui
//
//  Created by zjq on 2017/6/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "DBStationHeadView.h"
#import "CWStarRateView.h"
#import "YYKit.h"

@interface DBStationHeadView ()

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

@implementation DBStationHeadView
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
        
        //        self.stationImageView.image = [UIImage imageNamed:@"xiangq.png"];
        self.stationNameLabel.font = [UIFont systemFontOfSize:14];
        self.addressLabel.font = [UIFont systemFontOfSize:14];
        self.commentCountLabel.font = [UIFont systemFontOfSize:12];
        self.distanceLabel.font = [UIFont systemFontOfSize:12];
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
    self.stationNameLabel.text = [_stationList stationName];
    self.addressLabel.text = [_stationList stationAddr];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%@条评论",[stationList totalCount]];
    self.distanceLabel.text = [NSString stringWithFormat:@"%@km",[stationList distance1]];
    [self.stationImageView  setImageWithURL:[NSURL URLWithString:[stationList stationPic]] placeholder:[UIImage imageNamed:@"xiangq.png"]];
    self.scoreView.scorePercent = [self.stationList.avgStar floatValue]/5;
    
    
    self.stationImageView.frame = CGRectMake(10, 10, 120, 90);
    self.stationNameLabel.frame = CGRectMake(140, 10, self.frame.size.width-150, 15);
    self.addressLabel.frame = CGRectMake(140, 60, self.frame.size.width-20, 15);
    self.commentCountLabel.frame = CGRectMake(140, 70+15, 100, 15);
    self.distanceIcon.frame = CGRectMake(self.frame.size.width-95, 85, 15, 15);
    
    self.distanceLabel.frame = CGRectMake(self.frame.size.width-75, 85, 65, 15);
}

//height = 110;
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.stationImageView.frame = CGRectMake(10, 10, 120, 90);
    self.stationNameLabel.frame = CGRectMake(140, 10, self.frame.size.width-150, 15);
    self.addressLabel.frame = CGRectMake(140, 60, self.frame.size.width-20-140, 15);
    self.commentCountLabel.frame = CGRectMake(140, 70+15, 100, 15);
    self.distanceIcon.frame = CGRectMake(self.frame.size.width-95, 85, 15, 15);
    self.distanceLabel.frame = CGRectMake(self.frame.size.width-75, 85, 65, 15);
}


@end
