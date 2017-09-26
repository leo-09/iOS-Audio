//
//  CCarFreeInspectAddressView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/28.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CCarFreeInspectAddressView.h"
#import "CCarFreeInspectAddressCell.h"
#import "TextViewContentTool.h"
#import "SelectView.h"

// 限制最大输入字符数
#define MAX_LIMIT_NUMS 30

static float headerViewHeight = 60;

@implementation CCarFreeInspectAddressView

- (instancetype) init {
    if (self = [super init]) {
        
        self.tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:self.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self.tableView registerClass:[CCarFreeInspectAddressCell class] forCellReuseIdentifier:@"CCarFreeInspectAddressCell"];
        
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else if (section == 1) {
        if (showCity) {
            return self.townModels.count;
        } else {
            return 0;
        }
    } else if (section == 2) {
        if (showTown) {
            _model.currentCity = self.townModels[_model.currentCityIndex];
            return _model.currentCity.village.count;
        } else {
            return 0;
        }
    } else if (section == 3) {
        return 0;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        CCarFreeInspectAddressCell *cell = [CCarFreeInspectAddressCell cellWithTableView:tableView];
        
        TownModel *town = self.townModels[indexPath.row];
        cell.areaName = town.areaName;
        
        return cell;
    } else {
        CCarFreeInspectAddressCell *cell = [CCarFreeInspectAddressCell cellWithTableView:tableView];
        
        _model.currentCity = self.townModels[_model.currentCityIndex];
        VillageModel *model = _model.currentCity.village[indexPath.row];
        cell.areaName = model.areaName;
        
        return cell;
    }
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 0;
    } else if (indexPath.section == 1) {
        return headerViewHeight;
    } else if (indexPath.section == 2) {
        return headerViewHeight;
    } else if (indexPath.section == 3) {
        return 0;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    } else if (section == 1) {
        return 60;
    } else if (section == 2) {
        return 60;
    } else if (section == 3) {
        return CTXScreenHeight * 0.2 + 10;
    } else {
        return 60;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] init];
        return view;
    } else if (section == 1) {
        _model.currentCity = self.townModels[_model.currentCityIndex];
        SelectView *headerView = [self headerViewWithTitle:@"所在城市" areaName:_model.currentCity.areaName];
        
        [headerView setClickListener:^(id sender) {
            // 必须关闭二级section
            showTown = NO;
            [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
            
            showCity = !showCity;
            [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        return headerView;
    } else if (section == 2) {
        _model.currentCity = self.townModels[_model.currentCityIndex];
        _model.currentTown = _model.currentCity.village[_model.currentTownIndex];
        SelectView *headerView = [self headerViewWithTitle:@"所在区／县" areaName:_model.currentTown.areaName];
        
        [headerView setClickListener:^(id sender) {
            if (!showCity) {
                showTown = !showTown;
                [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
        
        return headerView;
    } else if (section == 3) {
        UIView *view = [self addrInfoHeaderView];
        return view;
    } else {
        UIView *view = [self btnHeaderView];
        return view;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {// 城市
        _model.currentCityIndex = (int)indexPath.row;
        _model.currentCity = self.townModels[_model.currentCityIndex];
        _model.currentTownIndex = 0;
        
        showCity = !showCity;
        [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationFade];
        
        // 刷新区县
        [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
    } else if (indexPath.section == 2) {// 区县
        _model.currentTownIndex = (int)indexPath.row;
        _model.currentTown = _model.currentCity.village[_model.currentTownIndex];
        
        showTown = !showTown;
        [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - headerView

- (SelectView *) headerViewWithTitle:(NSString *)title areaName:(NSString *)areaName {
    CGRect frame = CGRectMake(0, 0, CTXScreenWidth, headerViewHeight);
    SelectView *headerView = [[SelectView alloc] initWithFrame:frame];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    titleLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    [headerView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.centerY.equalTo(headerView.centerY);
    }];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select_date"]];
    [headerView addSubview:iv];
    [iv makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-12));
        make.centerY.equalTo(headerView.centerY);
    }];
    
    UILabel *areaNameLabel = [[UILabel alloc] init];
    areaNameLabel.text = areaName;
    areaNameLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    areaNameLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    [headerView addSubview:areaNameLabel];
    [areaNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(iv.left).offset(@(-12));
        make.centerY.equalTo(headerView.centerY);
    }];
    
    if ([title isEqualToString:@"所在城市"]) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [headerView addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.right.equalTo(@(-12));
            make.bottom.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
    }
    
    return headerView;
}

- (UIView *) addrInfoHeaderView {
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CTXScreenWidth, CTXScreenHeight * 0.2 + 10)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    [headerView addSubview:view];
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@10);
    }];
    
    UILabel *addrLabel = [[UILabel alloc] init];
    addrLabel.text = @"详细地址";
    addrLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    addrLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    [headerView addSubview:addrLabel];
    [addrLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@20);
    }];
    
    _textView = [[UITextView alloc] init];
    _textView.font = [UIFont systemFontOfSize:CTXTextFont];
    _textView.textColor = UIColorFromRGB(CTXTextBlackColor);
    _textView.delegate = self;
    _textView.text = _model.addrInfo;
    [headerView addSubview:_textView];
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addrLabel.right).offset(@15);
        make.top.equalTo(@10);
        make.right.equalTo(@(-12));
        make.bottom.equalTo(@0);
    }];
    
    _tintLabel = [[UILabel alloc] init];
    _tintLabel.text = @"请输入详细地址";
    _tintLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    _tintLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
    [headerView addSubview:_tintLabel];
    [_tintLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_textView.left).offset(6);
        make.top.equalTo(_textView.top).offset(8);
    }];
    
    if (_textView.text.length > 0) {
        _tintLabel.hidden = YES;
    }
    
    return headerView;
}

- (UIView *) btnHeaderView {
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CTXScreenWidth, 60)];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = UIColorFromRGB(CTXThemeColor);
    [btn setTitle:@"立即添加" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTarget:self action:@selector(addAreaAddress) forControlEvents:UIControlEventTouchDown];
    CTXViewBorderRadius(btn, 3.0, 0, [UIColor clearColor]);
    [headerView addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.bottom.equalTo(@0);
        make.left.equalTo(@12);
        make.right.equalTo(@(-12));
    }];
    
    return headerView;
}

// 立即添加
- (void) addAreaAddress {
    NSString *content = [TextViewContentTool isContaintContent:self.textView.text];
    if (!content) {
        [self showTextHubWithContent:@"请输入详细地址"];
        
        return;
    }
    
    self.model.addrInfo = content;
    
    if (self.addAddressListener) {
        self.addAddressListener(self.model);
    }
}

#pragma mark - public method

- (void) setTownModels:(NSArray<TownModel *> *)townModels model:(CarFreeInspectAddressModel *)model {
    _townModels = townModels;
    _model = model;
    
    showCity = NO;
    showTown = NO;
    
    if (!_model) {
        _model = [[CarFreeInspectAddressModel alloc] init];
        
        _model.currentCityIndex = 0;
        _model.currentTownIndex = 0;
        
        _model.currentCity = self.townModels[_model.currentCityIndex];
        _model.currentTown = _model.currentCity.village[_model.currentTownIndex];
        _model.addrInfo = @"";
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITextViewDelegate

// 有输入时触但对于中文键盘出示的联想字选择时不会触发
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [textView resignFirstResponder];
    }
    
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0]; //获取高亮部分
//    NSString * selectedtext = [textView textInRange:selectedRange];//获取高亮部分内容
    
    // 如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        } else {
            return NO;
        }
    }
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0) {
        return YES;
    } else {
        NSInteger len = text.length + caninputlen;
        // 防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0) {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        
        return NO;
    }
    
}

// 当输入且上面的代码返回YES时触发。或当选择键盘上的联想字时触发
- (void)textViewDidChange:(UITextView *)textView {
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];//获取高亮部分
    
    // 如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        self.tintLabel.hidden = YES;
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS) {
        //截取到最大位置的字符
        NSString *content = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:content];
    }
    
    if (existTextNum > 0) {
        self.tintLabel.hidden = YES;
    } else {
        self.tintLabel.hidden = NO;
    }
}

@end
