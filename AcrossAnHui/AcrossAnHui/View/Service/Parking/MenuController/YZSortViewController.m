//
//  YZSortViewController.m
//  PullDownMenu
//
//  Created by yz on 16/8/12.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "YZSortViewController.h"
#import "YZSortCell.h"
#import "ParkingAreaModel.h"
#import "ParkingRoadModel.h"

extern NSString * const YZUpdateMenuTitleNote;
extern NSString * const YZUpdateMenuTitleKey;

NSString * const YZUpdateMenuTitleDictKey = @"YZUpdateMenuTitleDictKey";

static NSString * const ID = @"cell";

@implementation YZSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectedCol = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YZSortCell class] forCellReuseIdentifier:ID];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedCol inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZSortCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 根据业务逻辑
    id item = _titleArray[indexPath.row];
    
    if ([item isKindOfClass:[ParkingAreaModel class]]) {
        ParkingAreaModel *model = (ParkingAreaModel *) item;
        
        cell.textLabel.text = model.areaname;
    }
    
    if ([item isKindOfClass:[ParkingRoadModel class]]) {
        ParkingRoadModel *model = (ParkingRoadModel *) item;
        
        cell.textLabel.text = model.sitename;
    }
    
    if (indexPath.row == 0) {
        [cell setSelected:YES animated:NO];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedCol = indexPath.row;
    
    // 选中当前
    YZSortCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // 更新菜单标题
    NSDictionary *userInfo = @{ YZUpdateMenuTitleKey: cell.textLabel.text,
                                YZUpdateMenuTitleDictKey: _titleArray[indexPath.row] };
    [[NSNotificationCenter defaultCenter] postNotificationName:YZUpdateMenuTitleNote object:self userInfo:userInfo];
}

- (void) setTitleArray:(NSMutableArray *)titleArray {
    _titleArray = titleArray;
    
    [self.tableView reloadData];
}

@end
