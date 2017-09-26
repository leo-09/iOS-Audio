//
//  CHomeView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CHomeView.h"
#import "CHomeServeCell.h"
#import "CHomeHeadlinesCell.h"
#import "CNewsInfoCell.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "CTXRefreshGifHeader.h"

#define headerCellCount 2

@implementation CHomeView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        self.tableView.tableHeaderView = self.cycleScrollView;
        self.tableView.showsVerticalScrollIndicator = NO;
        
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        // 下拉刷新
        self.tableView.mj_header = [CTXRefreshGifHeader headerWithRefreshingBlock:^{
            if (self.refreshHomeDataListener) {
                self.refreshHomeDataListener(NO);
            }
        }];
    }
    
    return self;
}

- (void) endRefreshing {
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.newsInfos && self.newsInfos.count > 0) {
        return self.newsInfos.count + headerCellCount + 1;
    } else {
        return headerCellCount;// 没有今日头条
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CHomeCarCell *carCell = [CHomeCarCell cellWithTableView:tableView];
        carCell.carIllegals = self.carIllegals;
        [carCell setSelectCarListener:^(id resullt) {
            if (self.selectCarListener) {
                self.selectCarListener(resullt);
            }
        }];
        
        return carCell;
    } else if (indexPath.row == 1) {
        CHomeServeCell *cell = [CHomeServeCell cellWithTableView:tableView];
        
        cell.serveModels = self.serveModels;
        [cell setSelectServeListener:^(id resullt) {
            if (self.selectServeListener) {
                self.selectServeListener(resullt);
            }
        }];
        return cell;
    } else if (indexPath.row == 2) {
        CHomeHeadlinesCell *cell = [CHomeHeadlinesCell cellWithTableView:tableView];
        [cell setMoreNewsInfoClickListener:^{
            if (self.moreNewsInfoClickListener) {
                self.moreNewsInfoClickListener();
            }
        }];
        
        return cell;
    } else {
        CNewsInfoCell *cell = [CNewsInfoCell cellWithTableView:tableView];
        
        NewsInfoModel *model = _newsInfos[indexPath.row - (headerCellCount + 1)];
        NSURL *url = [NSURL URLWithString:model.typeimg];
        [cell.iconIV setImageWithURL:url placeholder:[UIImage imageNamed:@"z_l"]];
        cell.titleLabel.text = model.name ? model.name : @"";
        cell.timeLabel.text = [model dataTime];
        // 调整行间距
        [UILabel changeLineSpaceForLabel:cell.titleLabel WithSpace:6];
        cell.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [cell isLastCell:(indexPath.row == (self.newsInfos.count + headerCellCount)) ? YES : NO];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 15 + 98;                 // 汽车cell的高98
    } else if (indexPath.row == 1) {    // 服务cell
        if (self.serveModels && self.serveModels.count > 4) {// 显示2行
            return (CTXScreenWidth / 4 + 8) * 2 + 15;
        } else {
            return CTXScreenWidth / 4 + 8 + 15;
        }
    } else if (indexPath.row == 2) {
        return 15 + 45;                 // 今日头条高45
    }else {// 新闻缩略 cell
        return 97;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row > headerCellCount) {
        if (self.selectNewsInfoCellListener) {
            self.selectNewsInfoCellListener(self.newsInfos[indexPath.row-(headerCellCount + 1)]);
        }
    }
}

#pragma mark - SDCycleScrollViewDelegate

// 点击图片回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.clickADVListener) {
        self.clickADVListener(self.advertisements[index]);
    }
}

#pragma mark - getter/setter

- (SDCycleScrollView *) cycleScrollView {
    if (!_cycleScrollView) {
        // 网络加载 --- 创建带标题的图片轮播器
        CGRect frame = CGRectMake(0, 0, CTXScreenWidth, (CTXScreenWidth / 9) * 4);
        self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:[UIImage imageNamed:@"banner_b"]];
        self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        self.cycleScrollView.pageControlDotSize = CGSizeMake(6, 6);
        self.cycleScrollView.currentPageDotColor = UIColorFromRGB(CTXThemeColor);
        self.cycleScrollView.pageDotColor = UIColorFromRGB(CTXBackGroundColor);
        self.cycleScrollView.autoScrollTimeInterval = 5.0f;
        self.cycleScrollView.backgroundColor = CTXColor(244, 244, 244);
    }
    
    return _cycleScrollView;
}

- (void) setAdvertisements:(NSArray<AdvertisementModel *> *)advertisements {
    _advertisements = advertisements;
    if (advertisements) {
        // 取出图片路径
        NSMutableArray *imagePaths = [[NSMutableArray alloc] init];
        for (AdvertisementModel *model in advertisements) {
            [imagePaths addObject:model.img];
        }
        self.cycleScrollView.imageURLStringsGroup = imagePaths;
    }
}

- (void) setCarIllegals:(NSArray<CarIllegalInfoModel *> *)carIllegals {
    _carIllegals = carIllegals;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void) setServeModels:(NSArray<ServeModel *> *)serveModels {
    _serveModels = serveModels;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void) setNewsInfos:(NSArray<NewsInfoModel *> *)newsInfos {
    _newsInfos = newsInfos;
    [self.tableView reloadData];
    
    if (_newsInfos.count > 0) {
        _isNewsInfoModelCorrect = YES;
    } else {
        _isNewsInfoModelCorrect = NO;
    }
}

@end
