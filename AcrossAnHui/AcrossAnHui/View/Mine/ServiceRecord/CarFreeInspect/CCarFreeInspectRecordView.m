//
//  CCarFreeInspectRecordView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CCarFreeInspectRecordView.h"
#import "CCarFreeInspectRecordCell.h"
#import "CTXRefreshGifHeader.h"
#import "CTXRefreshGifFooter.h"
#import "SubscribeModel.h"

@interface CCarFreeInspectRecordView()

@property (nonatomic, strong) CCarFreeInspectRecordCell *tempCell;

@end

@implementation CCarFreeInspectRecordView

- (instancetype) init {
    if (self = [super init]) {
        
        _dataSource = [[NSMutableArray alloc] init];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self.tableView registerClass:[CCarFreeInspectRecordCell class] forCellReuseIdentifier:@"CCarFreeInspectRecordCell"];
        // 刷新header
        self.tableView.mj_header = [CTXRefreshGifHeader headerWithRefreshingBlock:^{
            if (self.refreshRecordDataListener) {
                self.refreshRecordDataListener(NO);
            }
        }];
        
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@1);
            make.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
        }];
        
        // 创建cell
        self.tempCell = [[CCarFreeInspectRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CCarFreeInspectRecordCell"];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCarFreeInspectRecordCell *cell = [CCarFreeInspectRecordCell cellWithTableView:tableView];
    
    SubscribeModel *model = _dataSource[indexPath.row];
    cell.model = model;
    
    [cell setPaySubscribeRecordListener:^(id result) {
        if (self.paySubscribeRecordListener) {
            self.paySubscribeRecordListener(result);
        }
    }];
    [cell setRefundSubscribeRecordListener:^(id result) {
        if (self.refundSubscribeRecordListener) {
            self.refundSubscribeRecordListener(result);
        }
    }];
    [cell setLogisticsSubscribeRecordListener:^(id result) {
        if (self.logisticsSubscribeRecordListener) {
            self.logisticsSubscribeRecordListener(result);
        }
    }];
    [cell setCancelSubscribeRecordListener:^(id result) {
        if (self.cancelSubscribeRecordListener) {
            self.cancelSubscribeRecordListener(result);
        }
    }];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubscribeModel *model = _dataSource[indexPath.row];
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
            if (self.loadRecordDataListener) {
                self.loadRecordDataListener();
            }
        }];
    }
}

- (void) addDataSource:(NSArray *)data page:(int)page {
    if (!data || data.count == 0) {
        return;
    }
    
    // 找出本页数据开始的下标
    int startIndex = countPerPage * page;  // 因为分页从0开始
    startIndex = (startIndex < 0 ? 0 : startIndex);
    
    // 1、还没有到该页数据, 说明是加载缓存数据，则直接添加
    if (_dataSource.count < startIndex) {
        [_dataSource addObjectsFromArray:data];
    } else {
        // 2、再进来，就是加载的网络数据，则需要替换掉缓存数据
        
        int endIndex = countPerPage * (page + 1);    // 下一页开始的下标
        NSRange range;                                  // 当前页的下标范围
        
        if (_dataSource.count < endIndex) {             // _dataSource数据不足当前页的最大下标
            int lack = endIndex - (int)_dataSource.count;   // _dataSource中缺少该页数据的个数
            range = NSMakeRange(startIndex, countPerPage - lack);
        } else {
            range = NSMakeRange(startIndex, countPerPage);
        }
        
        // 替换掉缓存数据
        [_dataSource replaceObjectsInRange:range withObjectsFromArray:data];
    }
    
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
    [_dataSource addObjectsFromArray:data];
    
    if (_dataSource.count == 0) {
        [self addNilDataView];
        [promptView setNilDataWithImagePath:@"park_zwtcjl" tint:@"暂时没有记录，快去申请吧!" btnTitle:@"申请六年免检" isNeedAddData:NO];
    } else {
        if (promptView) {
            [promptView removeFromSuperview];
            promptView = nil;
        }
    }
    
    countPerPage = (int) _dataSource.count;// 第一页数据个数就是每页的个数，否则就没有下一页了
    [self.tableView reloadData];
    
    // 因为是分页显示，则超过一页的内容，就不能跳转到相应位置了
    if (self.offsetY <= self.tableView.contentSize.height) {
        [self.tableView setContentOffset:CGPointMake(0, self.offsetY) animated:NO];
    } else {
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height) animated:NO];
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
        
        [promptView setPromptOperationListener:^ {
            @strongify(self)
            
            if (self.toCarFreeInspectListener) {
                self.toCarFreeInspectListener();
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
