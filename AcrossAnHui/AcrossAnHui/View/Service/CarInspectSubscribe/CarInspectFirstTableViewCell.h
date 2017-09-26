//
//  CarInspectFirstTableViewCell.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarInspectStationModel.h"
#import "CWStarRateView.h"

@interface CarInspectFirstTableViewCell : UITableViewCell

@property (nonatomic,copy) UILabel *stationLabel;
@property (nonatomic,copy) UILabel *xinglabel;
@property (nonatomic,copy) UIButton *locationButton;
@property (nonatomic,copy) UIButton *phoneButton;
@property (nonatomic,copy) UIImageView *phoneImg;
@property (nonatomic,copy) UIButton *sendButton;
@property (nonatomic,copy) UILabel  *linelabel;
@property (nonatomic,copy) UILabel *verticalabel;
@property (nonatomic,copy) UIImageView *zhifuView;//支付标志图片
@property (nonatomic,copy) UIImageView *GoodsView;//优惠标志图片
@property (nonatomic,copy) UILabel *zhifuLabel;//支付
@property (nonatomic,copy) UILabel *GoodsLabel;//优惠
@property (nonatomic,retain)CWStarRateView * starView;
@property (nonatomic,retain) CarInspectStationModel * stationModel;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
