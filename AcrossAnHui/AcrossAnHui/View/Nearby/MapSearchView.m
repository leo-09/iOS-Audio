//
//  MapSearchView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/1.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "MapSearchView.h"
#import "AppDelegate.h"

@implementation MapSearchView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        
        _aMapSearchAPI = [[AMapSearchAPI alloc] init];
        _aMapSearchAPI.delegate = self;
        
        [self addItemView];
    }
    
    return self;
}

- (void) addItemView {
    // 搜索框
    _textField = [[UITextField alloc] init];
    _textField.placeholder = @"请输入您要查询的信息";
    _textField.textColor = UIColorFromRGB(0x6c6c6c);
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    [self addSubview:_textField];
    [_textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@40);
    }];
    
    UIButton *searchBtn = [[UIButton alloc] init];
    [searchBtn setImage:[UIImage imageNamed:@"near_sousuo"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchDown];
    [self addSubview:searchBtn];
    [searchBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@40);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
}

#pragma mark - event response

// 搜索
- (void) search {
    [self textFieldShouldReturn:self.textField];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (![textField.text isEqualToString:@""]) {
        // 请求数据
        [self configPOIAcTionWithKeyWords:textField.text];
    }
    
    return YES;
}

#pragma mark - private method

- (void) configPOIAcTionWithKeyWords:keywords {
    if (!_keyPOISearRequst) {
        _keyPOISearRequst = [[AMapPOIKeywordsSearchRequest alloc] init];
    }
    _keyPOISearRequst.city = [AppDelegate sharedDelegate].aMapLocationModel.city;
    _keyPOISearRequst.keywords = keywords;
    _keyPOISearRequst.offset = 50;
    //是否显示扩展信息
    _keyPOISearRequst.requireExtension = YES;
    [_aMapSearchAPI AMapPOIKeywordsSearch:_keyPOISearRequst];
    
    if (self.startSearchBlock) {
        self.startSearchBlock();
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResultData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"iden";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
    NearByMAPointAnnotation *anno = self.searchResultData[indexPath.row];
    cell.textLabel.text = anno.title;
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.updateViewHeightBlock) {
        self.updateViewHeightBlock(NO);
    }
    
    if (self.selectPointAnnotationListener) {
        self.selectPointAnnotationListener(self.searchResultData[indexPath.row]);
    }
}

#pragma mark - AMapSearchDelegate

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    if (self.stopSearchBlock) {
        self.stopSearchBlock(@"没有查询到相关信息");
    }
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (!_searchResultData) {
        _searchResultData = [[NSMutableArray alloc] init];
    } else {
        [_searchResultData removeAllObjects];
    }
    
    for (AMapPOI *aPOI in response.pois) {
        NearByMAPointAnnotation *anno = [[NearByMAPointAnnotation alloc] init];
        anno.coordinate = CLLocationCoordinate2DMake(aPOI.location.latitude, aPOI.location.longitude);
        anno.title = aPOI.name;
        anno.subtitle = aPOI.address;
        anno.tag = @"MapSearchView";
        [_searchResultData addObject:anno];
    }
    
    if (_searchResultData.count > 0 ) {
        if (self.updateViewHeightBlock) {
            self.updateViewHeightBlock(YES);
        }
        if (self.stopSearchBlock) {
            self.stopSearchBlock(nil);
        }
    } else {
        if (self.updateViewHeightBlock) {
            self.updateViewHeightBlock(NO);
        }
        if (self.stopSearchBlock) {
            self.stopSearchBlock(@"没有查询到相关信息");
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - public method

- (void) textFieldResignFirstResponder {
    [self.textField resignFirstResponder];
    
    if (self.updateViewHeightBlock) {
        self.updateViewHeightBlock(NO);
    }
}

@end
