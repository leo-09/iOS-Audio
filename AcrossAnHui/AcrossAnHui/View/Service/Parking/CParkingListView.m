//
//  CParkingListView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CParkingListView.h"
#import "CTXRefreshGifHeader.h"
#import "CTXRefreshGifFooter.h"
#import "PNChart.h"
#import "SiteModel.h"

@implementation CParkingListView

- (instancetype) init {
    if (self = [super init]) {
        
        _dataSource = [[NSMutableArray alloc] init];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 180;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        // 刷新header
        self.tableView.mj_header = [CTXRefreshGifHeader headerWithRefreshingBlock:^{
            if (self.refreshParkDataListener) {
                self.refreshParkDataListener(NO);
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
    static NSString *cellIden = @"ParkTableViewCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellIden owner:self options:nil] lastObject];
    }
    
    UILabel *areaLabel = (UILabel *)[cell viewWithTag:111];
    UILabel *roadLabel = (UILabel *)[cell viewWithTag:112];
    UILabel *distanceLabel = (UILabel *)[cell viewWithTag:113];
    UILabel *typeLabel = (UILabel *)[cell viewWithTag:114];
    UIView *chartView = [cell viewWithTag:115];
    
    SiteModel *model = _dataSource[indexPath.row];
    
    areaLabel.text = [NSString stringWithFormat:@"所在区域：%@", model.areaname];
    roadLabel.text = [NSString stringWithFormat:@"所在道路：%@", model.sitename];
    distanceLabel.text = [NSString stringWithFormat:@"离我距离：约%.2lf公里", model.distance];
    typeLabel.text = [NSString stringWithFormat:@"路段类型：%@", model.category];
    
    int total = model.siteTotalNumber;
    int free = model.siteFreeNumber;
    NSArray *values = @[ @(free), @(total - free) ];
    
    [chartView removeAllSubviews];
    [self addPaySourceChartViewToView:chartView names:@[@"空闲车位", @""] values:values freeCount:free totalCount:total];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectListener) {
        self.selectListener(_dataSource[indexPath.row]);
    }
}

#pragma mark - PieChartView

- (void) addPaySourceChartViewToView:(UIView *)view names:(NSArray *)names values:(NSArray *)values
                           freeCount:(int)free totalCount:(int) total {
    // 数据源
    NSArray *items = [self getPNPieChartDataItemWithNames:names values:values];
    
    CGSize size = view.bounds.size;
    CGRect frame = CGRectMake((size.width - ParkPieChartViewWH) / 2, 10, ParkPieChartViewWH, ParkPieChartViewWH);
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:frame items:items];
    // 设置pieChart属性
    [self setPNPieChart:pieChart];
    
    [self addLabelViewWithPieChart:pieChart freeCount:free totalCount:total];
    
    [view addSubview:pieChart];
    
    // legend
    UIView *legend = [self legendFromPNPieChart:pieChart];
    [view addSubview:legend];
}

#pragma mark - private method

// 在中间显示 比例view
- (void) addLabelViewWithPieChart:(PNPieChart *) pieChart freeCount:(int)free totalCount:(int) total {
    UIView *innerView = [pieChart getInnerContentView];
    
    NSString *freeText = [NSString stringWithFormat:@"%d", free];
    NSString *totalText = [NSString stringWithFormat:@"%d", total];
    NSString *contentStr = [NSString stringWithFormat:@"%@/%@", freeText, totalText];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:(contentStr ? contentStr : @"")];
    text.color = UIColorFromRGB(0x3676D6);
    text.font = [UIFont systemFontOfSize:16.0f];
    // 总计车位 标淡色
    NSRange range = [contentStr rangeOfString:(totalText ? totalText : @"") options:NSBackwardsSearch];
    [text setColor:UIColorFromRGB(CTXThemeColor) range:range];
    [text setFont:[UIFont systemFontOfSize:CTXTextFont] range:range];
    
    YYLabel *label = [[YYLabel alloc] initWithFrame:innerView.bounds];
    label.backgroundColor = [UIColor clearColor];
    label.attributedText = text;
    label.textAlignment = NSTextAlignmentCenter;
    
    [innerView addSubview:label];
}

// 获取数据源
- (NSMutableArray *) getPNPieChartDataItemWithNames:(NSArray *)names values:(NSArray *)values {
    NSArray *colors = @[UIColorFromRGB(0x3676D6), UIColorFromRGB(CTXThemeColor) ];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (int i = 0; i < names.count; i++) {
        double value = [values[i] doubleValue];
        [items addObject:[PNPieChartDataItem dataItemWithValue:value color:colors[i] description:names[i]]];
    }
    
    return items;
}

// 设置pieChart 属性
- (void) setPNPieChart:(PNPieChart *) pieChart {
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    pieChart.descriptionTextShadowColor = [UIColor clearColor];
    pieChart.showAbsoluteValues = NO;
    pieChart.hideValuesAndNames = YES;
    pieChart.innerCircleRadius = pieChart.frame.size.width / 3;
    pieChart.isShowHalo = NO;
    pieChart.displayAnimated = NO;
    [pieChart strokeChart];
}

// legend
- (UIView *) legendFromPNPieChart:(PNPieChart *) pieChart {
    // legend
    pieChart.legendStyle = PNLegendItemStyleSerial;
    pieChart.legendFont = [UIFont systemFontOfSize:14.0f];
    pieChart.legendFontColor = UIColorFromRGB(0x9e9e9e);
    
    UIView *legend = [pieChart getLegendWithMaxWidth:pieChart.frame.size.width];
    
    CGRect frame = CGRectMake(16, pieChart.frame.origin.y + pieChart.frame.size.height + 20,
                              pieChart.frame.size.width, 30);
    [legend setFrame:frame];
    return legend;
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
            if (self.loadParkDataListener) {
                self.loadParkDataListener();
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
    
    if (_dataSource.count == 0) {
        [self addNilDataView];
        [promptView setNilDataWithImagePath:@"icon_jzsb" tint:@"暂无符合该条件的停车位列表" btnTitle:nil];
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
            if (self.refreshParkDataListener) {
                self.refreshParkDataListener(YES);
            }
        }];
    }
    
    [self addSubview:promptView];
    [promptView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
