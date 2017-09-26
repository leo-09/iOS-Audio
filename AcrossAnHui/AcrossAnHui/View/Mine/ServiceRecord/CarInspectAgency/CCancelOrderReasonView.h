//
//  CCancelOrderReasonView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/21.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "CancelOrderReasonModel.h"
#import "PromptView.h"

/**
 取消原因View
 */
@interface CCancelOrderReasonView : CTXBaseView<UITableViewDelegate, UITableViewDataSource> {
    PromptView *promptView;
}

@property (nonatomic, retain) NSArray<CancelOrderReasonModel *> *dataSource;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, copy) SelectCellModelListener submitReasonListener;

@end
