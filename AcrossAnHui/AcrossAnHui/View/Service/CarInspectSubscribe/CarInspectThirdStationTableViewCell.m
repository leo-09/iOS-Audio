//
//  CarInspectThirdStationTableViewCell.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectThirdStationTableViewCell.h"
#import "YYKit.h"
#import "KLCDTextHelper.h"
#import "Masonry.h"
#import "carInspectStationCollectionView.h"
#import "KLCDTextHelper.h"

@implementation CarInspectThirdStationTableViewCell

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
        _headerView = [[UIImageView alloc] init];
        _headerView.layer.cornerRadius = 15.0;
        [self.contentView addSubview:_headerView];
        
        _infolabel = [[UILabel alloc] init];
        _infolabel.numberOfLines = 0;
        _infolabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _infolabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_infolabel];
        self.dateLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.dateLabel];
        self.scoreStart = [[CWStarRateView alloc]initWithFrame:CGRectMake(42.5, 20, 100, 15)];
        self.scoreStart.allowIncompleteStar = YES;
        self.scoreStart.hasAnimation = NO;
        [self.scoreStart addGesture];
        
        [self.contentView addSubview:_scoreStart];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(5,5,5,5);
        self.collectionView = [[carInspectStationCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self.contentView addSubview:self.collectionView];
                self.headerView.backgroundColor = [UIColor redColor];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.font = [UIFont systemFontOfSize:14];
        
        self.lineLab = [[UILabel alloc]init];
        self.lineLab.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [self.contentView addSubview:self.lineLab];
        self.nameLab = [[UILabel alloc]init];
        self.nameLab.font = [UIFont systemFontOfSize:15];
        self.nameLab.textColor = UIColorFromRGB(CTXTextBlackColor);
        [self.contentView addSubview:self.nameLab];
    }
    
    return self;
}

- (void)setModel:(StationCommentModel *)model{
    if (_model !=model) {
        _model = model;
    }
    self.name_width = [KLCDTextHelper WidthForText:_model.realname withFontSize:15 withTextHeight:20];
    self.infoHeight = [KLCDTextHelper HeightForText:_model.assessContent withFontSize:15 withTextWidth:CGRectGetWidth(self.frame)-25-5-20];
    self.dateLabel.text = self.model.submitDate;
    if (_model.realname == nil) {
        _model.realname = @"";
        self.name_width = 0;
    }
    self.nameLab.text = self.model.realname;
    self.scoreStart.scorePercent = [self.model.assessStar floatValue]/5;
    
    [self.headerView setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholder:[UIImage imageNamed:@"green-touxiang.png"]];
    
    self.collectionView.imagArray = self.model.evalImgList;
    if (self.model.evalImgList.count>=1) {
        self.imageHeight = 80;
    }else{
        self.imageHeight = 0;
    }
    self.infolabel.text = self.model.assessContent;
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12.5);
        make.top.equalTo(@13);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_right).offset(5);
        make.top.equalTo(@20);
        make.width.equalTo(@(self.name_width+10));
        make.height.equalTo(@20);
    }];
    [self.scoreStart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab.mas_right).offset(5);
        make.top.equalTo(@20);
        make.width.equalTo(@(100));
        make.height.equalTo(@15);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scoreStart.mas_right).offset(0);
        make.top.equalTo(@20);
        make.right.equalTo(@(-13));
        make.height.equalTo(@15);
    }];
    [self.infolabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_right).offset(5);
        make.top.equalTo(_headerView.mas_bottom).offset(5);
        make.width.equalTo(@(CTXScreenWidth-25-5-20));
        make.height.equalTo(@(self.infoHeight));
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12.5);
        make.top.equalTo(_infolabel.mas_bottom).offset(0);
        make.width.equalTo(@(CTXScreenWidth-25));
        make.height.equalTo(@(self.imageHeight));
    }];
    [self.lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_right).offset(5);
        make.bottom.equalTo(@0);
        make.right.equalTo(@(0));
        make.height.equalTo(@(1));
    }];
}

-(void)layoutSubviews{

    [_headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12.5);
        make.top.equalTo(@13);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    [self.nameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_right).offset(5);
        make.top.equalTo(@20);
        make.width.equalTo(@(self.name_width+10));
        make.height.equalTo(@20);
    }];
    [self.scoreStart mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab.mas_right).offset(5);
        make.top.equalTo(@20);
        make.width.equalTo(@(100));
        make.height.equalTo(@15);
    }];
    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scoreStart.mas_right).offset(0);
        make.top.equalTo(@20);
        make.right.equalTo(@(-13));
        make.height.equalTo(@15);
    }];
    [self.infolabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_right).offset(5);
        make.top.equalTo(_headerView.mas_bottom).offset(5);
        make.width.equalTo(@(CTXScreenWidth-25-5-20));
        make.height.equalTo(@(self.infoHeight));
    }];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12.5);
        make.top.equalTo(_infolabel.mas_bottom).offset(10);
        make.width.equalTo(@(CTXScreenWidth-25));
        make.height.equalTo(@(self.imageHeight));
    }];
    [self.lineLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_right).offset(5);
        make.bottom.equalTo(@0);
        make.right.equalTo(@(0));
        make.height.equalTo(@(1));
    }];
}

- (CGSize)sizeWithText:(NSString *)text withFont:(UIFont *)font{
    
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    
    return size;
    
}

@end
