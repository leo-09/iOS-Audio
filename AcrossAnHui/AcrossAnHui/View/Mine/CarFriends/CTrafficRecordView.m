//
//  CTrafficRecordView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTrafficRecordView.h"
#import "CTXRefreshGifHeader.h"
#import "CTXRefreshGifFooter.h"
#import "CTrafficRecordCell.h"
#import "CarFriendCardModel.h"
#import "CarFriendTrafficRecordModel.h"

@interface CTrafficRecordView()

@property (nonatomic, strong) CTrafficRecordCell *tempCell;

@end

@implementation CTrafficRecordView

- (instancetype) init {
    if (self = [super init]) {
        
        _dataSource = [[NSMutableArray alloc] init];
        
        // 本月上报 已采用 的View
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:topView];
        [topView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@60);
        }];
        
        UIView *contentView = [[UIView alloc] init];
        CTXViewBorderRadius(contentView, 4.0, 0.8, UIColorFromRGB(CTXThemeColor));
        [topView addSubview:contentView];
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.right.equalTo(@(-12));
            make.height.equalTo(@40);
            make.centerY.equalTo(topView.centerY);
        }];
        
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.text = @"本月上报 0";
        _totalLabel.textColor = UIColorFromRGB(CTXThemeColor);
        _totalLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _totalLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:_totalLabel];
        [_totalLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
            make.width.equalTo((CTXScreenWidth - 24) / 2);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(CTXThemeColor);
        [contentView addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
            make.centerX.equalTo(contentView.centerX);
            make.width.equalTo(0.8);
        }];
        
        _usedLabel = [[UILabel alloc] init];
        _usedLabel.text = @"已采用 0";
        _usedLabel.textColor = UIColorFromRGB(CTXThemeColor);
        _usedLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _usedLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:_usedLabel];
        [_usedLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@0);
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
            make.width.equalTo((CTXScreenWidth - 24) / 2);
        }];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self.tableView registerClass:[CTrafficRecordCell class] forCellReuseIdentifier:@"CTrafficRecordCell"];
        // 刷新header
        self.tableView.mj_header = [CTXRefreshGifHeader headerWithRefreshingBlock:^{
            if (self.refreshNewsInfoDataListener) {
                self.refreshNewsInfoDataListener(NO);
            }
        }];
        
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.bottom);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
        
        // 创建cell
        self.tempCell = [[CTrafficRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CTrafficRecordCell"];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CTrafficRecordCell *cell = [CTrafficRecordCell cellWithTableView:tableView];
    
    CarFriendTrafficRecordModel *model = _dataSource[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarFriendTrafficRecordModel *model = _dataSource[indexPath.row];
    if (model.cellHeight == 0) {
        CGFloat cellHeight = [self.tempCell heightForModel:model];
        model.cellHeight = cellHeight;// 缓存给model
        return cellHeight;
    } else {
        return model.cellHeight;
    }
}

#pragma mark - getter/setter

- (void) setTotalRecords:(NSString *)totalRecords usedCount:(NSString *)usedCount {
    self.totalLabel.text = [NSString stringWithFormat:@"本月上报 %@", totalRecords];
    self.usedLabel.text = [NSString stringWithFormat:@"已采用 %@", usedCount];
}

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
            if (self.loadNewsInfoDataListener) {
                self.loadNewsInfoDataListener();
            }
        }];
    }
}

- (void) addDataSource:(NSArray *)data page:(int)page {
    if (!data || data.count == 0) {
        return;
    }
    
    // 找出本页数据开始的下标
    int startIndex = countPerPage * (page - 1);  // 因为分页从1开始
    startIndex = (startIndex < 0 ? 0 : startIndex);
    
    // 1、还没有到该页数据, 说明是加载缓存数据，则直接添加
    if (_dataSource.count < startIndex) {
        [_dataSource addObjectsFromArray:data];
    } else {
        // 2、再进来，就是加载的网络数据，则需要替换掉缓存数据
        
        int endIndex = countPerPage * page;  // 下一页开始的下标
        NSRange range;                          // 当前页的下标范围
        
        if (_dataSource.count < endIndex) {     // _dataSource数据不足当前页的最大下标
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
    
    [self reloadData];
}

- (void) reloadData {
    if (_dataSource.count == 0) {
        [self addNilDataView];
        [promptView setNilDataWithImagePath:@"sb_1" tint:@"本月暂无上报记录！" btnTitle:nil];
    } else {
        if (promptView) {
            [promptView removeFromSuperview];
            promptView = nil;
        }
    }
    
    countPerPage = (int) _dataSource.count;// 第一页数据个数就是每页的个数，否则就没有下一页了
    [self.tableView reloadData];
}

- (void) addNilDataView {
    if (!promptView) {
        promptView = [[PromptView alloc] init];
        
        @weakify(self)
        [promptView setPromptRefreshListener:^{
            @strongify(self)
            if (self.refreshNewsInfoDataListener) {
                self.refreshNewsInfoDataListener(YES);
            }
        }];
    }
    
    [self addSubview:promptView];
    [promptView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
