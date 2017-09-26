//
//  CTopicRecordView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTopicRecordView.h"
#import "CTXRefreshGifHeader.h"
#import "CTXRefreshGifFooter.h"
#import "CTopicRecordCell.h"
#import "CarFriendTopicModel.h"
#import "CarFriendCardModel.h"

@interface CTopicRecordView()

@property (nonatomic, strong) CTopicRecordCell *tempCell;
@property (nonatomic, retain) NSIndexPath *selectIndexPath;;  // 选择的位置
@property (nonatomic, retain) NSIndexPath *deleteIndexPath;;  // 删除的位置

@end

@implementation CTopicRecordView

- (instancetype) init {
    if (self = [super init]) {
        
        _dataSource = [[NSMutableArray alloc] init];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self.tableView registerClass:[CTopicRecordCell class] forCellReuseIdentifier:@"CTopicRecordCell"];
        // 刷新header
        self.tableView.mj_header = [CTXRefreshGifHeader headerWithRefreshingBlock:^{
            if (self.refreshNewsInfoDataListener) {
                self.refreshNewsInfoDataListener(NO);
            }
        }];
        
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        // 创建cell
        self.tempCell = [[CTopicRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CTopicRecordCell"];
    }
    
    return self;
}

- (void) updateSelectModel:(CarFriendCardModel *)model {
    if (self.selectIndexPath) {
        CarFriendTopicModel *selectModel = _dataSource[self.selectIndexPath.row];
        selectModel.isLaud = model.isLaud;              // 是否点赞
        selectModel.laudCount = model.laudCount;
        selectModel.commandCount = model.commandCount;
        selectModel.isRecommend = model.isRecommend;    // 是否推荐
        
        // 更新值
        [_dataSource replaceObjectAtIndex:self.selectIndexPath.row withObject:selectModel];
        [self.tableView reloadRowAtIndexPath:self.selectIndexPath withRowAnimation:UITableViewRowAnimationNone];
    }
    
    self.selectIndexPath = nil;
}

- (void) updateDeleteModel {
    if (self.deleteIndexPath) {
        [_dataSource removeObjectAtIndex:self.deleteIndexPath.row];
        
        if (_dataSource.count == 0) {
            if (self.refreshNewsInfoDataListener) {
                self.refreshNewsInfoDataListener(NO);
            }
        }
        
        // 因为删除的cell过多，所以不能显示mj_footer
        if (_tableView.contentSize.height <= _tableView.frame.size.height) {
            [self removeFooter];
        }
        
        [self reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CTopicRecordCell *cell = [CTopicRecordCell cellWithTableView:tableView];
    
    CarFriendTopicModel *model = _dataSource[indexPath.row];
    cell.model = model;
    
    [cell setDeleteRecordListener:^ {
        self.deleteIndexPath = indexPath;
        
        if (self.deleteTopicListener) {
            self.deleteTopicListener(model);
        }
    }];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < self.dataSource.count) {
        if (self.showCarFriendInfoListener) {
            self.selectIndexPath = indexPath;
            self.showCarFriendInfoListener(self.dataSource[indexPath.row]);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarFriendTopicModel *model = _dataSource[indexPath.row];
    if (model.cellHeight == 0) {
        CGFloat cellHeight = [self.tempCell heightForModel:model];
        model.cellHeight = cellHeight;// 缓存给model
        return cellHeight;
    } else {
        return model.cellHeight;
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
        [promptView setNilDataWithImagePath:@"zanwuhuati_1" tint:@"暂无话题记录" btnTitle:nil];
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
