//
//  CJStationInfoView.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CJStationInfoView.h"
#import "CSearchNewsInfoCollectionViewCell.h"
#import "CSearchNewsInfoCollectionReusableView.h"
#import "CarInspectStationModel.h"
#import "KLCDTextHelper.h"

@implementation CJStationInfoView

- (instancetype) init {
    if (self = [super init]) {
        _dataSource = [[NSMutableArray alloc]init];
        [self addNavitationBar];
        [self addTableView];
    }
    
    return self;
}

// 头部
- (void) addNavitationBar {
    UIView *navitationView = [[UIView alloc] init];
    navitationView.backgroundColor = [UIColor whiteColor];
    [self addSubview:navitationView];
    [navitationView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    // 返回按钮
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    [navitationView addSubview:backBtn];
    [backBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.top.equalTo(CTXBarHeight);
        make.width.equalTo(@60);
        make.height.equalTo(CTXNavigationBarHeight);
    }];
    
    // 搜索按钮
    UIButton *searchBtn = [[UIButton alloc] init];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    searchBtn.backgroundColor = CTXColor(20, 155, 213);
    CTXViewBorderRadius(searchBtn, 4, 0, [UIColor clearColor]);
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchDown];
    [navitationView addSubview:searchBtn];
    [searchBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-15));
        make.top.equalTo((CTXBarHeight + 7));
        make.width.equalTo(@50);
        make.height.equalTo(@30);
    }];
    
    //  textView
    self.textView = [[UIView alloc] init];
    self.textView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    CTXViewBorderRadius(self.textView, 4, 0, [UIColor clearColor]);
    [navitationView addSubview:self.textView];
    [self.textView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backBtn.right);
        make.right.equalTo(@(-14));
        make.height.equalTo(@30);
        make.centerY.equalTo(searchBtn.centerY);
    }];
    
    // 搜索图标
    UIImageView *textViewSearchIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ellipse"]];
    textViewSearchIV.contentMode = UIViewContentModeCenter;
    [self.textView addSubview:textViewSearchIV];
    [textViewSearchIV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    // 删除图标
    self.textViewDeleteBtn = [[UIButton alloc] init];
    [self.textViewDeleteBtn setImage:[UIImage imageNamed:@"iconfont_quxiao"] forState:UIControlStateNormal];
    [self.textViewDeleteBtn addTarget:self action:@selector(deleteTextFieldContent) forControlEvents:UIControlEventTouchDown];
    self.textViewDeleteBtn.contentMode = UIViewContentModeCenter;
    self.textViewDeleteBtn.hidden = YES;
    [self.textView addSubview:self.textViewDeleteBtn];
    [self.textViewDeleteBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    // textField
    self.textField = [[UITextField alloc] init];
    self.textField.placeholder = @"输入您要搜索的关键字";
    self.textField.font = [UIFont systemFontOfSize:12.0f];
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeySearch;
    // 监听TextField的输入
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.textView addSubview:self.textField];
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textViewSearchIV.right);
        make.top.equalTo(self.textView.top);
        make.bottom.equalTo(self.textView.bottom);
        make.right.equalTo(self.textViewDeleteBtn.left);
    }];
    
    // 线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
    [navitationView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@(-0));
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.8);
    }];
}

// 内容 tableView
- (void) addTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    [self.tableView registerClass:[CSearchNewsInfoCell class] forCellReuseIdentifier:@"CSearchNewsInfoCell"];
    [self addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(CTXBarHeight + CTXNavigationBarHeight));
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
}

- (void) refreshDataSource:(NSArray *)data {
    if (!data) {
        if (_dataSource && _dataSource.count > 0) {
            return;
        }
        return;
    }
    
    [_dataSource removeAllObjects];
    [self.tableView reloadData];
    
    [_dataSource addObjectsFromArray:data];
    if (_dataSource.count == 0) {
      
    } else {
        [self.tableView reloadData];
    }
}

#pragma mark - event response

- (void) back {
    if (self.backListener) {
        self.backListener();
    }
}

- (void) search {
    [_textField resignFirstResponder];
    if (self.searchListener) {
        self.searchListener(self.textField.text);
    }
}

- (void) deleteTextFieldContent {
    [_textField resignFirstResponder];
    self.textField.text = @"";
    self.textViewDeleteBtn.hidden = YES;
    [self textFieldDidChange:self.textField];
}

- (void) clearRecord {
    if (self.clearRecordListener) {
        self.clearRecordListener();
    }
}

- (void) textFieldDidChange:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        self.textViewDeleteBtn.hidden = YES;
        [self.textView updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-14));
        }];
    } else {
        self.textViewDeleteBtn.hidden = NO;
        [self.textView updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-75));
        }];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    CarInspectStationModel * model = _dataSource[indexPath.row];
    cell.textLabel.text = model.stationName;
    return cell;
}

#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.textField resignFirstResponder];
    
    if (indexPath.row < self.dataSource.count) {
        CarInspectStationModel * model = _dataSource[indexPath.row];
        if (_selectStationCellListener) {
            self.selectStationCellListener(model);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (_dataSource.count > 0) ? 40 : 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.size.width, 30)];
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"history"]];
    iv.contentMode = UIViewContentModeCenter;
    iv.frame = CGRectMake(5, 5, 30, 30);
    [headerSectionView addSubview:iv];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, 150, 30)];
    label.text = @"历史搜索记录";
    label.textColor = UIColorFromRGB(CTXTextBlackColor);
    label.font = [UIFont systemFontOfSize:15.0f];
    [headerSectionView addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, self.tableView.size.width, 0.5)];
    line.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
    [headerSectionView addSubview:line];
    
    return headerSectionView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.textField resignFirstResponder];
    
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (![textField.text isEqualToString:@""]) {
        if (self.searchListener) {
            self.searchListener(textField.text);
        }
    }
    
    return YES;
}


- (UIButton *) footerBtn {
    if (!_footerBtn) {
        _footerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CTXScreenWidth, 70)];
        _footerBtn.backgroundColor = [UIColor clearColor];
        [_footerBtn setTitle:@"[清空历史搜索记录]" forState:UIControlStateNormal];
        [_footerBtn setTitleColor:CTXColor(254, 110, 0) forState:UIControlStateNormal];
        _footerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_footerBtn addTarget:self action:@selector(clearRecord) forControlEvents:UIControlEventTouchDown];
    }
    
    return _footerBtn;
}

- (void) setHotKeywords:(NSArray *)hotKeywords {
    if (hotKeywords) {
        _hotKeywords = hotKeywords;
        [self.collectionView reloadData];
        self.tableView.tableHeaderView = nil;
    } else {
        _hotKeywords = [[NSArray alloc] init];
        [self.collectionView reloadData];
        self.tableView.tableHeaderView = nil;
    }
}

- (void) setRecords:(NSArray *)records {
    if (records) {
        //[_dataSource removeAllObjects];
        _dataSource = (NSMutableArray *)records;
        [self.tableView reloadData];
        
        self.tableView.tableFooterView = self.footerBtn;
    } else {
        _dataSource = [[NSMutableArray alloc] init];
        [self.tableView reloadData];
        self.tableView.tableFooterView = nil;
    }
}




@end
