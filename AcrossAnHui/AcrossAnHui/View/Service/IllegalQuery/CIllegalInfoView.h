//
//  CIllegalInfoView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "CarIllegalInfoModel.h"

/**
 违章详情 View
 */
@interface CIllegalInfoView : CTXBaseView

@property (nonatomic, retain) ViolationInfoModel *violationInfoModel;

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIImageView *iv;
@property (nonatomic, retain) UILabel *plateNumberLabel;    // 车牌号
@property (nonatomic, retain) UILabel *timeLabel;           // 违章时间
@property (nonatomic, retain) UILabel *addressLabel;        // 违章地点
@property (nonatomic, retain) UILabel *actionLabel;         // 违章行为
@property (nonatomic, retain) UILabel *scoreLabel;          // 违章扣分
@property (nonatomic, retain) UILabel *moneyLabel;          // 违章罚款
@property (nonatomic, retain) UIButton *showIllegalDisposalSiteBtn;

@property (nonatomic, copy) ClickListener showIllegalDisposalSiteListener;

@end
