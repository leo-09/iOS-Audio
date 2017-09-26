//
//  CSelectCarTypeView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/14.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CSelectCarTypeView.h"
#import "CSelectCarTypeCell.h"
#import "CHotCarTypeCell.h"

@implementation CSelectCarTypeView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addUISearchbar];
        [self addTableView];
    }
    
    return self;
}

- (void) addUISearchbar {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    [self addSubview:view];
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(@60);
    }];
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.placeholder = @"输入关键字搜索";
    _searchBar.translucent = YES;
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.delegate = self;
    
    // 去除灰背景
    for (UIView *view in self.searchBar.subviews) {
        // for before iOS7.0
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    
    [view addSubview:_searchBar];
    [_searchBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(12);
        make.right.equalTo(-12);
        make.height.equalTo(60);
        make.centerY.equalTo(view.centerY);
    }];
}

- (void) addTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置索引样式
    self.tableView.sectionIndexColor = UIColorFromRGB(CTXThemeColor);// 设置默认时索引值颜色
    self.tableView.sectionIndexTrackingBackgroundColor = UIColorFromRGB(CTXBaseViewColor);//设置选中时，索引背景颜色
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];//设置默认时，索引的背景颜色
    
    [self addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.top.equalTo(@60);
    }];
}

- (void) addNilDataView {
    if (!promptView) {
        promptView = [[PromptView alloc] init];
        
        @weakify(self)
        [promptView setPromptRefreshListener:^{
            @strongify(self)
            if (self.refreshCarTypeModelListener) {
                self.refreshCarTypeModelListener(YES);
            }
        }];
    }
    
    [self addSubview:promptView];
    [promptView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - public method

- (BOOL) canPopToNavigationController {
    if (self.isSearch) {
        self.isSearch = NO;
        self.isSelect = NO;
        [self.tableView reloadData];
        
        return NO;
    }
    
    if (self.isSelect) {
        self.isSearch = NO;
        self.isSelect = NO;
        [self.tableView reloadData];
        
        return NO;
    }
    
    return YES;
}

- (void) addTitleArray:(NSMutableArray *)titleArray contentArray:(NSMutableArray *)contentArray {
    self.titleArray = titleArray;
    self.contentArray = contentArray;
    
    if (!self.titleArray) {
        [self addNilDataView];
        [promptView setRequestFailureImageView];
        
        return;
    }
    
    if (self.titleArray.count == 0) {
        [self addNilDataView];
        [promptView setNilDataWithImagePath:@"weizhaodao" tint:@"暂未查到车型" btnTitle:nil];
    } else {
        if (promptView) {
            [promptView removeFromSuperview];
            promptView = nil;
        }
        
        [self.tableView reloadData];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (!self.searchCarTypeMode) {
        self.searchCarTypeMode = [[NSMutableArray alloc] init];
    } else {
        [self.searchCarTypeMode removeAllObjects];
    }
    
    // 没有输入，则显示所有车型
    if ([searchText isEqualToString:@""]) {
        self.isSearch = NO;
        [self.tableView reloadData];
        
        return;
    }
    
    for (CarTypeModel *model in self.carTypes) {
        if ([model.cb.name containsString:searchText]) {
            [self.searchCarTypeMode addObject:model];
        }
    }
    
    // 没有匹配的车型，则显示所有车型
    if (self.searchCarTypeMode.count == 0) {
        self.isSearch = NO;
    } else {
        self.isSearch = YES;
    }
    
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

#pragma mark - UITableViewDataSource

// 返回section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 搜索的结果
    if (self.isSearch) {
        return self.searchCarTypeMode.count;
    }
    
    // 选择的结果
    if (self.isSelect) {
        return self.selectCarTypeMode.count;
    }
    
    // 展示所有汽车品牌
    if (!self.contentArray) {
        return 0;
    } else {
        return self.contentArray.count + 1;
    }
}

// 返回section中的row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 搜索的结果
    if (self.isSearch) {
        CarTypeModel *model = self.searchCarTypeMode[section];
        return model.cs.count;
    }
    
    // 选择的结果
    if (self.isSelect) {
        CarTypeModel *model = self.selectCarTypeMode[section];
        return model.cs.count;
    }
    
    // 展示所有汽车品牌
    if (section == 0) {
        return 1;
    } else {
        // 每个字母下的所有汽车品牌
        NSArray *items = self.contentArray[section - 1];
        return items.count;
    }
}

// 返回索引数组
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    // 搜索的结果
    if (self.isSearch) {
        return nil;
    }
    
    // 选择的结果
    if (self.isSelect) {
        return nil;
    }
    
    // 展示所有汽车品牌
    if (!self.titleArray) {
        return nil;
    }
    
    if (![self.titleArray[0] isEqualToString:@"字母"]) {
        [self.titleArray insertObject:@"字母" atIndex:0];
        [self.titleArray insertObject:@"索引" atIndex:1];
    }
    
    return self.titleArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 搜索的结果
    if (self.isSearch) {
        CarTypeModel *model = self.searchCarTypeMode[indexPath.section];
        CBModel *cb = model.cs[indexPath.row];
        
        CSelectCarTypeCell *cell = [CSelectCarTypeCell cellWithTableView:tableView];
        cell.label.text = cb.name;
        
        if (indexPath.row == (model.cs.count - 1)) {
            cell.lineView.hidden = YES;
        } else {
            cell.lineView.hidden = NO;
        }
        
        return cell;
    }
    
    // 选择的结果
    if (self.isSelect) {
        CarTypeModel *model = self.selectCarTypeMode[indexPath.section];
        CBModel *cb = model.cs[indexPath.row];
        
        CSelectCarTypeCell *cell = [CSelectCarTypeCell cellWithTableView:tableView];
        cell.label.text = cb.name;
        cell.lineView.hidden = NO;
        
        return cell;
    }
    
    // 展示所有汽车品牌
    if (indexPath.section == 0) {
        CHotCarTypeCell *cell = [CHotCarTypeCell cellWithTableView:tableView];
        
        [cell setSelectButtonModelListener:^(NSString *result) {
            [self selectCarType:result];
        }];
        
        return cell;
    } else {
        // 每个字母下的所有汽车品牌
        NSArray *items = self.contentArray[indexPath.section - 1];
        
        CSelectCarTypeCell *cell = [CSelectCarTypeCell cellWithTableView:tableView];
        cell.label.text = items[indexPath.row];
        
        if (indexPath.row == (items.count - 1)) {
            cell.lineView.hidden = YES;
        } else {
            cell.lineView.hidden = NO;
        }
        
        return cell;
    }
}

// 响应点击索引时的委托方法
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (index >= 2) {
        return index - 2;
    } else {
        return -1;
    }
}

#pragma mark UITableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CTXScreenWidth, 50)];
    view.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    
    CGRect frame = CGRectMake(12, 0, CTXScreenWidth - 24, 50);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = UIColorFromRGB(CTXBaseFontColor);
    label.font = [UIFont systemFontOfSize:16.0];
    [view addSubview:label];
    
    // 搜索的结果
    if (self.isSearch) {
        CarTypeModel *model = self.searchCarTypeMode[section];
        label.text = model.cb.name;
        return view;
    }
    
    // 选择的结果
    if (self.isSelect) {
        CarTypeModel *model = self.selectCarTypeMode[section];
        label.text = model.cb.name;
        return view;
    }
    
    // 展示所有汽车品牌
    if (section == 0) {
        label.text = @"热门车型";
        return view;
    } else {
        label.text = self.titleArray[section - 1 + 2];// 排除字母、索引
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 搜索的结果
    if (self.isSearch) {
        return 50;
    }
    
    // 选择的结果
    if (self.isSelect) {
        return 50;
    }
    
    // 展示所有汽车品牌
    if (indexPath.section == 0) {
        return 4 * (40 + 10);
    } else {
        return 50;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 搜索的结果
    if (self.isSearch) {
        CarTypeModel *model = self.searchCarTypeMode[indexPath.section];
        CBModel *cb = model.cs[indexPath.row];
        
        if (self.selectCBModelListener) {
            self.selectCBModelListener(model.cb, cb);
        }
    }
    
    // 选择的结果
    if (self.isSelect) {
        CarTypeModel *model = self.selectCarTypeMode[indexPath.section];
        CBModel *cb = model.cs[indexPath.row];
        
        if (self.selectCBModelListener) {
            self.selectCBModelListener(model.cb, cb);
        }
    }
    
    // 展示所有汽车品牌，选中了某个汽车品牌
    if (indexPath.section == 0) {
        // 热门名牌, 在CHotCarTypeCell的block中处理
    } else {
        NSArray *items = self.contentArray[indexPath.section - 1];
        NSString *carTypeName = items[indexPath.row];
        
        [self selectCarType:carTypeName];
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

#pragma mark - private method

- (void) selectCarType:(NSString *)carTypeName {
    self.isSelect = YES;
    
    for (CarTypeModel *model in self.carTypes) {
        if ([carTypeName isEqualToString:model.cb.name]) {
            self.selectCarTypeMode = @[ model ];
            break;
        }
    }
    
    [self.tableView reloadData];
}

@end
