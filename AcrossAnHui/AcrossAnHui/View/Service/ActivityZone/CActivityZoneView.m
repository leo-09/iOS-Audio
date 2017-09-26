//
//  CActivityZoneView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/24.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CActivityZoneView.h"
#import "CTXRefreshGifHeader.h"
#import "CTXRefreshGifFooter.h"
#import "ActivityZoneModel.h"

@implementation CActivityZoneView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _dataSource = [[NSMutableArray alloc] init];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        [self addSubview:self.tableView];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = (CTXScreenWidth - 60) / 9 * 4 + 60;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor whiteColor];
        
        self.tableView.mj_header = [CTXRefreshGifHeader headerWithRefreshingBlock:^{
            if (self.refreshActivityDataListener) {
                self.refreshActivityDataListener(NO);
            }
        }];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIden = @"CActivityZoneViewCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellIden owner:self options:nil] lastObject];
    }
    
    UIView *topLine = [cell viewWithTag:111];
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:112];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:113];
    UIView *bgView = [cell viewWithTag:114];
    UILabel *statusLabel = (UILabel *)[cell viewWithTag:115];
    
    ActivityZoneModel *model = _dataSource[indexPath.row];
    
    if (indexPath.row == 0) {
        topLine.hidden = YES;
    } else {
        topLine.hidden = NO;
    }
    
    timeLabel.text = model.startTime;
    
    NSURL *url = [NSURL URLWithString:model.imgPath];
    [imageView setImageWithURL:url placeholder:[UIImage imageNamed:@"default_activity_zone"]];
    
    if ([model.status isEqualToString:@"1"]) {// 活动进行中
        bgView.backgroundColor = CTXColor(254, 110, 0);
        statusLabel.text = @"活动进行中";
    } else  if ([model.status isEqualToString:@"2"]) {// 敬请期待
        bgView.backgroundColor = CTXColor(3, 163, 214);
        statusLabel.text = @"敬请期待";
    } else {// 活动已结束
        bgView.backgroundColor = UIColorFromRGB(0xb1b1b1);
        statusLabel.text = @"活动已结束";
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataSource.count) {
        if (self.selectActivityCellListener) {
            self.selectActivityCellListener(self.dataSource[indexPath.row]);
        }
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
            if (self.loadActivityDataListener) {
                self.loadActivityDataListener();
            }
        }];
    }
}

- (void) addDataSource:(NSArray *)data page:(int) page {
    if (!data || data.count == 0) {
        return;
    }
    
    // 第一次取缓存数据，第二次取网络数据，所以需要对比，替换掉缓存数据／添加缓存数据
    NSMutableArray *newData = [[NSMutableArray alloc] init];
    // 遍历查找数据
    for (ActivityZoneModel *newMdoel in data) {
        BOOL isEqual = NO;
        // 和原数据比对
        for (int i = 0; i < _dataSource.count; i++) {
            ActivityZoneModel *oldModel = _dataSource[i];
            // 找到相同的数据，则替换
            if ([newMdoel.title isEqualToString:oldModel.title]) {
                isEqual = YES;
                [_dataSource replaceObjectAtIndex:i withObject:newMdoel];
                break;
            }
        }
        // 数据没有出现重复的，则记录该数据
        if (!isEqual) {
            [newData addObject:newMdoel];
        }
    }
    // 添加没有出现重复的数据
    [_dataSource addObjectsFromArray:newData];
    
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
        [promptView setNilDataWithImagePath:nil tint:@"暂无活动" btnTitle:nil];
    } else {
        if (promptView) {
            [promptView removeFromSuperview];
            promptView = nil;
        }
    }
    
    [self.tableView reloadData];
}

- (void) addNilDataView {
    if (!promptView) {
        CGRect frame = CGRectMake(0, 0, CTXScreenWidth, (CTXScreenHeight- CTXBarHeight - CTXNavigationBarHeight));
        promptView = [[PromptView alloc] initWithFrame:frame];
        
        @weakify(self)
        [promptView setPromptRefreshListener:^{
            @strongify(self)
            if (self.refreshActivityDataListener) {
                self.refreshActivityDataListener(YES);
            }
        }];
    }
    
    [self addSubview:promptView];
}

@end
