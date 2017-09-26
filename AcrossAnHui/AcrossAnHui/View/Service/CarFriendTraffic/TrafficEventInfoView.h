//
//  TrafficEventInfoView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/2.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "TrafficEventModel.h"

typedef void (^TrafficCountListener)(NSString *eventID, NSString *tagID);

/**
 车友路况 的事件详情
 */
@interface TrafficEventInfoView : CTXBaseView<CAAnimationDelegate> {
    NSString *currentBtnIndex;
    NSMutableArray *imageViewArray; // 保存imageView
}

@property (nonatomic, retain) TrafficEventModel *model;

@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIView *mainView;

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *infoLabel;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIView *svConentView;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UIButton *useableBtn;
@property (nonatomic, retain) UIButton *unUseableBtn;

@property (nonatomic, strong) ClickListener hideViewListener;
@property (nonatomic, strong) TrafficCountListener trafficCountListener;

- (void) showInfoView;
- (void) hideInfoView;
- (void) updateBtnTitle;

@end
