//
//  CSearchParkingView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CSearchParkingView.h"
#import "CTXRefreshGifHeader.h"
#import "CTXRefreshGifFooter.h"
#import "SiteModel.h"
#import "CSearchParkingCell.h"

@implementation CSearchParkingView

- (instancetype) init {
    if (self = [super init]) {
        _dataSource = [[NSMutableArray alloc] init];
        
        self.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self addItemView];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 80;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self.tableView registerClass:[CSearchParkingCell class] forCellReuseIdentifier:@"CSearchParkingCell"];
        
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textField.bottom).offset(2);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
    }
    
    return self;
}

- (void) addItemView {
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:[UIImage imageNamed:@"iconfont_fh_blank"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    [self addSubview:backBtn];
    [backBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.left.equalTo(@0);
        make.top.equalTo(@24);
    }];
    
    _textField = [[UITextField alloc] init];
    _textField.placeholder = @"搜目的地、找停车场";
    _textField.textColor = UIColorFromRGB(0x6c6c6c);
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    [self addSubview:_textField];
    [_textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@40);
        make.top.equalTo(@24);
        make.right.equalTo(@(-15));
        make.height.equalTo(@40);
    }];
    
    UIButton *searchBtn = [[UIButton alloc] init];
    [searchBtn setImage:[UIImage imageNamed:@"icon_sous"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchDown];
    [self addSubview:searchBtn];
    [searchBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-15));
        make.top.equalTo(@24);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
}

#pragma mark - event response

- (void) back {
    if (self.backListener) {
        self.backListener();
    }
}

- (void) search {
    if (self.searchSiteListener) {
        self.searchSiteListener(_textField.text);
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    [self search];
    
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSearchParkingCell * cell = [CSearchParkingCell cellWithTableView:tableView];
    
    SiteModel *model = _dataSource[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SiteModel *model = _dataSource[indexPath.row];
    
    if ([model.siteID isEqualToString:@"noSearchResult"]) {
        // 没有搜索到相关目的地
    } else  if ([model.siteID isEqualToString:@"noRecord"]) {
        // 清除历史记录
        if (self.cleanRecordListener) {
            
            // 先更新UI
            [_dataSource removeAllObjects];
            [self.tableView reloadData];
            
            // 再删除存储的数据
            self.cleanRecordListener();
        }
    } else {
        if (self.selectListener) {
            self.selectListener(_dataSource[indexPath.row]);
        }
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    [_textField resignFirstResponder];
}

#pragma mark - getter/setter

- (void) hideFooter {
    CGFloat y = self.tableView.contentOffset.y;
    CGFloat height = self.tableView.mj_footer.frame.size.height;
    CGPoint offset = CGPointMake(0, y - height);
    [self.tableView setContentOffset:offset animated:YES];
}

- (void) endRefreshing {
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

- (void) addDataSource:(NSArray *)data {
    [_dataSource addObjectsFromArray:data];
    [self.tableView reloadData];
}

- (void) refreshDataSource:(NSArray *)data isRecord:(BOOL) isRecord {
    if (isRecord) {
        [_dataSource addObjectsFromArray:data];
        
        if (_dataSource.count > 0) {
            // 显示历史记录，才有以下提示
            SiteModel *model = [[SiteModel alloc] init];
            model.siteID = @"noRecord";
            model.sitename = @"清除历史记录";
            [_dataSource addObject:model];
        }
    } else {
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
            // 不是显示历史记录，才有以下提示
            SiteModel *model = [[SiteModel alloc] init];
            model.siteID = @"noSearchResult";
            model.sitename = @"没有搜索到相关目的地";
            
            [_dataSource addObject:model];
        } else {
            if (promptView) {
                [promptView removeFromSuperview];
                promptView = nil;
            }
        }
    }
    
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
        make.top.equalTo(_textField.bottom).offset(2);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
}

@end
