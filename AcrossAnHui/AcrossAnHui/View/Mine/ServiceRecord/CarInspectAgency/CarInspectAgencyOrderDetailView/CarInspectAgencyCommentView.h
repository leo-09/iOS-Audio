//
//  CarInspectAgencyCommentView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "CarInspectAgencyOrderModel.h"
#import "CWStarRateView.h"

/**
 车检代办 订单详情 View---头部的状态（评价）
 */
@interface CarInspectAgencyCommentView : CTXBaseView

@property (nonatomic, retain) CarInspectAgencyOrderModel *orderModel;

@property (nonatomic, retain) CWStarRateView *commentStarView;  // 司机的星星
@property (nonatomic, retain) UILabel *commentResultLabel;      // 满意／不满意...

@property (nonatomic, assign) CGFloat viewHeight;

@end
