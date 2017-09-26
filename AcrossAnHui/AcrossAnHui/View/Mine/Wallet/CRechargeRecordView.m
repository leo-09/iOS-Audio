//
//  CRechargeRecordView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CRechargeRecordView.h"
#import "CRechargeRecordCell.h"
#import "CTXRefreshGifHeader.h"
#import "CTXRefreshGifFooter.h"

static CGFloat headerViewHeight = 40;

@implementation CRechargeRecordView

- (instancetype) init {
    if (self = [super init]) {
        
        _dataSource = [[NSMutableArray alloc] init];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 75;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self.tableView registerClass:[CRechargeRecordCell class] forCellReuseIdentifier:@"CRechargeRecordCell"];
        // 刷新header
        self.tableView.mj_header = [CTXRefreshGifHeader headerWithRefreshingBlock:^{
            if (self.refreshRecordDataListener) {
                self.refreshRecordDataListener(NO);
            }
        }];
        
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    RechargeRecordCollection *collection = _dataSource[section];
    return collection.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRechargeRecordCell *cell = [CRechargeRecordCell cellWithTableView:tableView];
    
    RechargeRecordCollection *collection = _dataSource[indexPath.section];
    RechargeRecordModel *record = collection.records[indexPath.row];
    
    if (indexPath.row == (collection.records.count - 1)) {
        [cell setModel:record isLastCell:YES];
    } else {
        [cell setModel:record isLastCell:NO];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return headerViewHeight;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CTXScreenWidth, headerViewHeight)];
    headerView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, CTXScreenWidth-24, headerViewHeight)];
    label.textColor = UIColorFromRGB(CTXTextBlackColor);
    label.font = [UIFont systemFontOfSize:CTXTextFont];
    [headerView addSubview:label];
    
    RechargeRecordCollection *collection = _dataSource[section];
    label.text = [collection month];
    
    return headerView;
}

#pragma mark - getter/setter

- (void) hideFooter {
    CGFloat y = self.tableView.contentOffset.y;
    CGFloat height = self.tableView.mj_footer.frame.size.height;
    CGPoint offset = CGPointMake(0, y - height);
    [self.tableView setContentOffset:offset animated:YES];
}

- (void) endRefreshing {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void) removeFooter {
    self.tableView.mj_footer = nil;
}

- (void) addFooter {
    if (!self.tableView.mj_footer) {
        self.tableView.mj_footer = [CTXRefreshGifFooter footerWithRefreshingBlock:^{
            if (self.loadRecordDataListener) {
                self.loadRecordDataListener();
            }
        }];
    }
}

- (void) addDataSource:(NSArray<RechargeRecordModel *> *)records {
    // 添加充值记录，并分组
    _dataSource = [RechargeRecordCollection recordCollection:_dataSource recordModels:records];
    
    [self.tableView reloadData];
}

- (void) refreshDataSource:(NSArray<RechargeRecordModel *> *)records {
    if (!records) {
        if (_dataSource && _dataSource.count > 0) {
            return;
        }
        
        [self addNilDataView];
        [promptView setRequestFailureImageView];
        
        return;
    }
    
    [_dataSource removeAllObjects];
    [self.tableView reloadData];
    
    _dataSource = [RechargeRecordCollection recordCollection:_dataSource recordModels:records];
    
    if (_dataSource.count == 0) {
        [self addNilDataView];
        [promptView setNilDataWithImagePath:@"park_zwtcjl" tint:@"暂无充值记录" btnTitle:nil];
    } else {
        if (promptView) {
            [promptView removeFromSuperview];
            promptView = nil;
        }
        
        [self.tableView reloadData];
    }
}

- (void) addNilDataView {
    if (!promptView) {
        promptView = [[PromptView alloc] init];
        
        @weakify(self)
        [promptView setPromptRefreshListener:^{
            @strongify(self)
            if (self.refreshRecordDataListener) {
                self.refreshRecordDataListener(YES);
            }
        }];
    }
    
    [self addSubview:promptView];
    [promptView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
