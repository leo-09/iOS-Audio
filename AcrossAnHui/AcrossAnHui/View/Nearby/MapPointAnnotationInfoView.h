//
//  MapPointAnnotationInfoView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/2.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "FastDealInfoModel.h"

typedef void (^StartNaviListener)(double latitude, double longitude);

/**
 地图上标的点的详情
 */
@interface MapPointAnnotationInfoView : CTXBaseView<CAAnimationDelegate> {
    BOOL isClickHide;
    
    BOOL isShow;
}

@property (nonatomic, retain) FastDealInfoModel *model;

@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *addrLabel;
@property (nonatomic, retain) UILabel *phoneLabel;
@property (nonatomic, retain) UIImageView *phoneIcon;
@property (nonatomic, retain) UIButton *phoneBtn;

@property (nonatomic, copy) ClickListener hideListener;
@property (nonatomic, copy) SelectCellModelListener callPhoneListener;
@property (nonatomic, copy) StartNaviListener startNaviListener;

- (void) show;
- (void) hide;

@end
