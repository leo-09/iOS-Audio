//
//  COrderTrackView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "COrderTrackView.h"
#import "COrderTrackCell.h"

@implementation COrderTrackView

- (instancetype) init {
    if (self = [super init]) {
        
        _dataSource = [[NSMutableArray alloc] init];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 60;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self.tableView registerClass:[COrderTrackCell class] forCellReuseIdentifier:@"COrderTrackCell"];
        
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
    COrderTrackCell *cell = [COrderTrackCell cellWithTableView:tableView];
    
    BOOL isFirstCell = NO;
    BOOL isLastCell = NO;
    if (indexPath.row == 0) {
        isFirstCell = YES;
    }
    
    if (indexPath.row == _dataSource.count - 1) {
        isLastCell = YES;
    }
    
    [cell setModel:_dataSource[indexPath.row] isFirstCell:isFirstCell isLastCell:isLastCell];
    
    return cell;
}

#pragma mark - public method

- (void) setDataSource:(NSArray<CarInspectAgencyOrderTrackModel *> *)dataSource {
    
    if (!dataSource) {
        [self addNilDataView];
        [promptView setRequestFailureImageView];
        
        return;
    }
    
    _dataSource = dataSource;
    if (_dataSource.count == 0) {
        [self addNilDataView];
        [promptView setNilDataWithImagePath:@"weizhaodao" tint:@"暂无订单信息" btnTitle:nil];
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
        
        [self addSubview:promptView];
        [promptView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
}

@end
