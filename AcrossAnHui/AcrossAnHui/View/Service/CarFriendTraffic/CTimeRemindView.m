//
//  CTimeRemindView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/5.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTimeRemindView.h"
#import "CTimeRemindCell.h"
#import "OrderRoadModel.h"

static NSString *noDataTint = @"你还没有定制路况,请添加您的定制路况!";

@interface CTimeRemindView()

@property (nonatomic, strong) CTimeRemindCell *tempCell;

@end

@implementation CTimeRemindView

- (instancetype) init {
    if (self = [super init]) {
        
        _dataSource = [[NSMutableArray alloc] init];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self.tableView registerClass:[CTimeRemindCell class] forCellReuseIdentifier:@"CTimeRemindCell"];
        
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        // 创建cell
        self.tempCell = [[CTimeRemindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CTimeRemindCell"];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CTimeRemindCell *cell = [CTimeRemindCell cellWithTableView:tableView];
    
    OrderRoadModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    
    [cell setEditRoadInfoCellListener:^(id result) {
        if (self.editRoadInfoCellListener) {
            self.editRoadInfoCellListener(result);
        }
    }];
    [cell setShowRoadInfoCellListener:^(id result) {
        if (self.showRoadInfoCellListener) {
            self.showRoadInfoCellListener(result);
        }
    }];
    
    return cell;
}

#pragma mark - UITableViewDelegate 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderRoadModel *model = self.dataSource[indexPath.row];
    if (model.cellHeight == 0) {
        CGFloat cellHeight = [self.tempCell heightForModel:model];
        model.cellHeight = cellHeight;// 缓存给model
        return cellHeight;
    } else {
        return model.cellHeight;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除定制路况
        OrderRoadModel *model = self.dataSource[indexPath.row];
        if (self.deleteRoadInfoCellListener) {
            self.deleteRoadInfoCellListener(model);
        }
        
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self refreshTableView];
    }
}

#pragma mark - public method

- (void) refreshDataSource:(NSArray *)data {
    if (!data) {
        if (_dataSource && _dataSource.count > 0) {
            return;
        }
        
        [self addNilDataView];
        [self.promptView setRequestFailureImageView];
        
        return;
    }
    
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:data];
    [self refreshTableView];
}

#pragma mark - private method

- (void) refreshTableView {
    if (_dataSource.count == 0) {
        [self addNilDataView];
        [self.promptView setNilDataWithImagePath:@"add_lukuangzhi" tint:noDataTint btnTitle:nil isNeedAddData:YES];
    } else {
        if (self.promptView) {
            [self.promptView removeFromSuperview];
            self.promptView = nil;
        }
    }
    
    [self.tableView reloadData];
}

- (void) addNilDataView {
    if (!self.promptView) {
        self.promptView = [[PromptView alloc] init];
        
        @weakify(self)
        [self.promptView setPromptRefreshListener:^{
            @strongify(self)
            
            if ([[self.promptView getLabelName] isEqualToString:noDataTint]) {
                // 没有数据 则添加数据
                if (self.addRoadInfoCellListener) {
                    self.addRoadInfoCellListener();
                }
            } else {
                // 网络错误 需要刷新界面
                if (self.refreshRoadInfoCellListener) {
                    self.refreshRoadInfoCellListener();
                }
            }
        }];
    }
    
    [self addSubview:self.promptView];
    [self.promptView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
