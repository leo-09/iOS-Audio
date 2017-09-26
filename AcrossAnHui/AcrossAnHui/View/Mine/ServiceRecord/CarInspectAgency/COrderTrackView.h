//
//  COrderTrackView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "CarInspectAgencyOrderTrackModel.h"
#import "PromptView.h"

/**
 订单跟踪View
 */
@interface COrderTrackView : CTXBaseView<UITableViewDelegate, UITableViewDataSource> {
    PromptView *promptView;
}

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSArray <CarInspectAgencyOrderTrackModel *> *dataSource;

@end
