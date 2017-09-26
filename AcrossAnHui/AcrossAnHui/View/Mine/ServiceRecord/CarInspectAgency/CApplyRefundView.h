//
//  CApplyRefundView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "PromptView.h"
#import "RefundOrderReasonModel.h"

/**
 申请退款View
 */
@interface CApplyRefundView : CTXBaseView<UITableViewDelegate, UITableViewDataSource> {
    PromptView *promptView;
}

@property (nonatomic, retain) RefundOrderReasonModel *model;
@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) UIView *typeView;
@property (nonatomic, retain) UILabel *typeLabel;
@property (nonatomic, retain) UILabel *moneyLabel;
@property (nonatomic, retain) UILabel *typeTintLabel;
@property (nonatomic, retain) UILabel *reasonTintLabel;

@property (nonatomic, copy) SelectCellModelListener submitReasonListener;
@property (nonatomic, copy) RefreshDataListener refreshReasonListener;

@end
