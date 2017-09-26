//
//  CPrideView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "PromptView.h"

@interface CPrideView : CTXBaseView<UITableViewDelegate, UITableViewDataSource> {
    PromptView *promptView;
}

@property (nonatomic, strong) NSString *viewTitle;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSArray *dataSource;

@property (nonatomic, strong) SelectCellModelListener selectCellModelListener;
@property (nonatomic, strong) RefreshDataListener refreshPrideListener;

- (void) setDataSource:(NSArray *)dataSource viewTitle:(NSString *)viewTitle;

@end
