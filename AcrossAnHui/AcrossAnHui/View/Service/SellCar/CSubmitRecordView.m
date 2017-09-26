//
//  CSubmitRecordView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CSubmitRecordView.h"
#import "CSubmitRecordTCell.h"
#import "CTXRefreshGifHeader.h"
#import "CTXRefreshGifFooter.h"
#import "SubmitRecordModel.h"

@implementation CSubmitRecordView

- (instancetype) init {
    if (self = [super init]) {
        
        _dataSource = [[NSMutableArray alloc] init];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 255;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self.tableView registerClass:[CSubmitRecordTCell class] forCellReuseIdentifier:@"CSubmitRecordTCell"];
        // 刷新header
        self.tableView.mj_header = [CTXRefreshGifHeader headerWithRefreshingBlock:^{
            if (self.refreshSubmitRecordDataListener) {
                self.refreshSubmitRecordDataListener(NO);
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSubmitRecordTCell *cell = [CSubmitRecordTCell cellWithTableView:tableView];
    
    SubmitRecordModel *model = _dataSource[indexPath.row];
    cell.labels[0].text = [NSString stringWithFormat:@"提交时间：%@", [model dataTime]];
    cell.labels[1].text = [NSString stringWithFormat:@"联系人：%@", model.name];
    cell.labels[2].text = [NSString stringWithFormat:@"手机号码：%@", model.phone];
    cell.labels[3].text = [NSString stringWithFormat:@"车型：%@", model.carType];
    cell.labels[4].text = [NSString stringWithFormat:@"所在城市：%@", model.city];
    cell.labels[5].text = [NSString stringWithFormat:@"首次上牌：%@", model.carTime];
    cell.labels[6].text = [NSString stringWithFormat:@"行驶公里：%@公里", model.mileage];
    
    return cell;
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
            if (self.loadSubmitRecordDataListener) {
                self.loadSubmitRecordDataListener();
            }
        }];
    }
}

- (void) addDataSource:(NSArray *)data {
    [_dataSource addObjectsFromArray:data];
    [self.tableView reloadData];
}

- (void) refreshDataSource:(NSArray *)data {
    if (!data) {
        if (_dataSource && _dataSource.count > 0) {
            return;
        }
        
        [self addNilDataView];
        [promptView setRequestFailureImageView];
        
        return;
    }
    
    [_dataSource removeAllObjects];
    [self.tableView reloadData];
    
    [_dataSource addObjectsFromArray:data];
    if (_dataSource.count == 0) {
        [self addNilDataView];
        [promptView setNilDataWithImagePath:@"weizhaodao" tint:@"暂无记录信息" btnTitle:nil];
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
            if (self.refreshSubmitRecordDataListener) {
                self.refreshSubmitRecordDataListener(YES);
            }
        }];
    }
    
    [self addSubview:promptView];
    [promptView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
