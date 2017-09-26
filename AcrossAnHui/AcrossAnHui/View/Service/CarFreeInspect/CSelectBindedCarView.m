//
//  CSelectBindedCarView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CSelectBindedCarView.h"
#import "CSelectBindedCarCell.h"

@implementation CSelectBindedCarView

- (instancetype) init {
    if (self = [super init]) {
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 95;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self.tableView registerClass:[CSelectBindedCarCell class] forCellReuseIdentifier:@"CSelectBindedCarCell"];
        
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.carIllegals.count + 1;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSelectBindedCarCell *cell = [CSelectBindedCarCell cellWithTableView:tableView];
    
    if (indexPath.row == self.carIllegals.count) {// 添加车辆
        [cell setModel:nil isLastCell:YES];
    } else {
        CarIllegalInfoModel *model = self.carIllegals[indexPath.row];
        [cell setModel:model isLastCell:NO];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.carIllegals.count) {// 添加车辆
        if (self.submitCarInfoListener) {
            self.submitCarInfoListener();
        }
    } else {
        if (self.selectCarCellListener) {
            CarIllegalInfoModel *model = self.carIllegals[indexPath.row];
            self.selectCarCellListener(model);
        }
    }
}

- (void) setCarIllegals:(NSArray<CarIllegalInfoModel *> *)carIllegals {
    _carIllegals = carIllegals;
    
    if (!_carIllegals) {
        _carIllegals = @[];
    }
    
    [self.tableView reloadData];
}

@end
