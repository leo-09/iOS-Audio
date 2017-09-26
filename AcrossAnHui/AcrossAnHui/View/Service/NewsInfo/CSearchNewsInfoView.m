//
//  CSearchNewsInfoView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CSearchNewsInfoView.h"
#import "CSearchNewsInfoCollectionViewCell.h"
#import "CSearchNewsInfoCollectionReusableView.h"
#import "KLCDTextHelper.h"

@implementation CSearchNewsInfoView

- (instancetype) init {
    if (self = [super init]) {
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
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return _records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSearchNewsInfoCell *cell = [CSearchNewsInfoCell cellWithTableView:tableView];
    cell.titleLabel.text = _records[indexPath.row];
    
    if (indexPath.row == (_records.count-1)) {
        [cell updateLastLineWidth];
    } else {
        [cell lineWidth];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.textField resignFirstResponder];
    
    if (self.searchListener) {
        self.searchListener(_records[indexPath.row]);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (_records.count > 0) ? 40 : 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.size.width, 30)];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"history"]];
    iv.contentMode = UIViewContentModeCenter;
    iv.frame = CGRectMake(5, 0, 30, 30);
    [headerSectionView addSubview:iv];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 150, 30)];
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

#pragma mark - getter/setter

- (UICollectionView *) collectionView {
    if (!_collectionView) {

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 12, 0, 12);
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        CGRect frame = CGRectMake(0, 0, CTXScreenWidth, [self caculateCollectionViewHeight]);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        // 注册collectionViewcell:WWCollectionViewCell是我自定义的cell的类型
        [_collectionView registerClass:[CSearchNewsInfoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        // 注册collectionView头部的view，需要注意的是这里的view需要继承自UICollectionReusableView
        [_collectionView registerClass:[CSearchNewsInfoCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    }
    
    return _collectionView;
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
        
        self.tableView.tableHeaderView = self.collectionView;
    } else {
        _hotKeywords = [[NSArray alloc] init];
        [self.collectionView reloadData];
        
        self.tableView.tableHeaderView = nil;
    }
}

- (void) setRecords:(NSArray *)records {
    if (records) {
        _records = records;
        [self.tableView reloadData];
        
        self.tableView.tableFooterView = self.footerBtn;
    } else {
        _records = [[NSArray alloc] init];
        [self.tableView reloadData];
        
        self.tableView.tableFooterView = nil;
    }
}

#pragma mark -- UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchListener) {
        self.searchListener(self.hotKeywords[indexPath.row]);
    }
}

#pragma mark -- UICollectionViewDataSource

// 每组cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.hotKeywords.count;
}

// cell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CSearchNewsInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.nameLabel.text = self.hotKeywords[indexPath.row];
    return cell;
}

// 头部/底部
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {// 头部
        CSearchNewsInfoCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        return view;
    } else {
        UICollectionReusableView *view = [[UICollectionReusableView alloc] init];
        return view;
    }
}

#pragma mark -- UICollectionViewDelegateFlowLayout

// 每个cell的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *hotKeyWord = self.hotKeywords[indexPath.row];
    
    CGFloat width = [KLCDTextHelper WidthForText:hotKeyWord withFontSize:CTXTextFont withTextHeight:50];
    return CGSizeMake(width + 15, 50); // 注意：每个cell的宽左右空留15，高是50
}

// 头部的尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(CTXScreenWidth, 49);
}

#pragma mark - 计算collectionView高度

- (CGFloat) caculateCollectionViewHeight {
    CGFloat totalWidth = 10;
    for (NSString *keyWord in self.hotKeywords) {
        // 注意：每个cell的宽左右空留15，高是50
        CGFloat width = [KLCDTextHelper WidthForText:keyWord withFontSize:CTXTextFont withTextHeight:50] + 15;
        totalWidth += (width + 10);
    }
    
    int lineNum = totalWidth / CTXScreenWidth;// 多少个正行
    CGFloat surplus = totalWidth - lineNum * CTXScreenWidth;// 剩余长度
    if (surplus > 0) {
        lineNum++;
    }
    
    // 每行高度50+行间距10;头部高度49
    return lineNum * (50 + 10) + 49;
}

@end
