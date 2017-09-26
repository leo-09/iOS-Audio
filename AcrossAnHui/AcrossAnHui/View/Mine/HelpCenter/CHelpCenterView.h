//
//  CHelpCenterView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "PromptView.h"

/**
 帮助中心View 
 */
@interface CHelpCenterView : CTXBaseView<UITableViewDelegate, UITableViewDataSource> {
    PromptView *promptView;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataSource;

@property (nonatomic, copy) RefreshDataListener refreshHelpInfoDataListener;

- (void) refreshDataSource:(NSArray *)data;

@end
