//
//  CCarAgencyRecordView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/16.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CCarAgencyRecordView.h"
#import "CCarAgencyRecordCell.h"
#import "CTXRefreshGifHeader.h"
#import "CTXRefreshGifFooter.h"

@interface CCarAgencyRecordView()

@property (nonatomic, retain) CCarAgencyRecordCell *tempCell;

@end

@implementation CCarAgencyRecordView

- (instancetype) init {
    if (self = [super init]) {
        
        _dataSource = [[NSMutableArray alloc] init];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 98;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self.tableView registerClass:[CCarAgencyRecordCell class] forCellReuseIdentifier:@"CCarAgencyRecordCell"];
        // 刷新header
        self.tableView.mj_header = [CTXRefreshGifHeader headerWithRefreshingBlock:^{
            if (self.refreshAgencyRecordDataListener) {
                self.refreshAgencyRecordDataListener(NO);
            }
        }];
        
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@1);
            make.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
        }];
        
        self.tempCell = [[CCarAgencyRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DBRecodeTableViewCell"];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCarAgencyRecordCell *cell = [CCarAgencyRecordCell cellWithTableView:tableView];
    
    CarInspectAgencyRecordModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    model.row = indexPath.row;
    
    // 评价
    [cell setCommentModelListener:^(id result) {
        if (self.commentModelListener) {
            self.commentModelListener(result);
        }
    }];
    
    // 确认订单
    [cell setCompleteModelListener:^(id result) {
        if (self.completeModelListener) {
            self.completeModelListener(result);
        }
    }];
    
    // 支付
    [cell setPayForModelListener:^(id result) {
        if (self.payForModelListener) {
            self.payForModelListener(result);
        }
    }];
    
    // 倒计时 时间到了
    [cell setWaitPayTimeListener:^(id result) {
        CarInspectAgencyRecordModel *model = (CarInspectAgencyRecordModel *)result;
        
        model.orderDetail.status = EOrderStatus_Cancel_Order;
        model.orderDetail.statusName = @"订单取消";
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:model.row inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataSource.count > indexPath.row) {
        CarInspectAgencyRecordModel *model = self.dataSource[indexPath.row];
        
        if (self.selectAgencyRecordCellListener) {
            self.selectAgencyRecordCellListener(model);
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarInspectAgencyRecordModel *model = self.dataSource[indexPath.row];
    
    if (model.cellHeight == 0) {
        CGFloat cellHeight = [self.tempCell heightForModel:model];
        model.cellHeight = cellHeight;// 缓存给model
        return cellHeight;
    } else {
        return model.cellHeight;
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0) {
        self.offsetY = scrollView.contentOffset.y;
    }
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
            if (self.loadAgencyRecordDataListener) {
                self.loadAgencyRecordDataListener();
            }
        }];
    }
}

- (void) updateCurrentModel:(CarInspectAgencyRecordModel *)model {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:model.row inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
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
        [promptView setNilDataWithImagePath:@"park_zwtcjl" tint:@"暂无记录，快去预约吧!" btnTitle:@"车检代办" isNeedAddData:NO];
    } else {
        if (promptView) {
            [promptView removeFromSuperview];
            promptView = nil;
        }
        
        [self.tableView reloadData];
        
        // 因为是分页显示，则超过一页的内容，就不能跳转到相应位置了
        if (self.offsetY <= self.tableView.contentSize.height) {
            [self.tableView setContentOffset:CGPointMake(0, self.offsetY) animated:NO];
        } else {
            [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height) animated:NO];
        }
    }
}

- (void) addNilDataView {
    if (!promptView) {
        promptView = [[PromptView alloc] init];
        
        @weakify(self)
        [promptView setPromptRefreshListener:^{
            @strongify(self)
            if (self.refreshAgencyRecordDataListener) {
                self.refreshAgencyRecordDataListener(YES);
            }
        }];
        
        [promptView setPromptOperationListener:^ {
            @strongify(self)
            
            if (self.toCarAgencyRecordListener) {
                self.toCarAgencyRecordListener();
            }
        }];
    }
    
    [self addSubview:promptView];
    [promptView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@1);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
}

@end
