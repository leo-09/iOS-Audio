//
//  CarInspectThirdStationTableViewCell.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationCommentModel.h"
#import "CWStarRateView.h"
#import "carInspectStationCollectionView.h"

@interface CarInspectThirdStationTableViewCell : UITableViewCell

@property (nonatomic,strong)StationCommentModel *model;//传入数据的model
@property (nonatomic,strong) UIImageView *headerView;//用户头像
@property (nonatomic,retain)CWStarRateView *scoreStart;//用户星级数
@property (nonatomic,strong) UILabel *infolabel;//用户评价内容
@property (nonatomic,strong)UILabel *dateLabel;//用户评价日期
@property (nonatomic,assign)CGFloat infoHeight;
@property (nonatomic,assign)CGFloat name_width;

@property (nonatomic,assign)CGFloat imageHeight;
@property (nonatomic,strong)carInspectStationCollectionView *collectionView;
@property (nonatomic,strong)UILabel * lineLab;
@property (nonatomic,strong)UILabel * nameLab;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
