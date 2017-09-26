//
//  ParkDetailView.h
//  IntelligentParkingManagement
//
//  Created by liyy on 2017/5/8.
//  Copyright © 2017年 ahctx. All rights reserved.
//

#import "CTXBaseView.h"
#import "SiteModel.h"

typedef void (^ShowInfoListnener)(id _Nullable name, id _Nullable siteID);

/**
 地图详情
 */
@interface MapParkDetailView : CTXBaseView<CAAnimationDelegate>

@property (nonatomic, retain) SiteModel * _Nullable parkInfo;

@property (weak, nonatomic) IBOutlet UILabel * _Nullable titleLabel;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable parkLabel;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable timeLabel;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable freeLabel;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable freeTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable chargeLabel;

@property (nonatomic, copy) ShowInfoListnener _Nullable showInfoListnener;
@property (nonatomic, copy) ClickListener _Nullable naviListener;

- (instancetype _Nullable ) initWithMyFrame:(CGRect)frame;

- (void) show;
- (void) hide;

@end
