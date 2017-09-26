//
//  CSearchNewsInfoView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "CSearchNewsInfoCell.h"

/**
 搜索新闻 View
 */
@interface CSearchNewsInfoView : CTXBaseView<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, retain) UIView *textView;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UIButton *textViewDeleteBtn;

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) UIButton *footerBtn;

@property (nonatomic, retain) NSArray *hotKeywords; // 热门搜索
@property (nonatomic, retain) NSArray *records;     // 搜索记录

@property (nonatomic, copy) ClickListener backListener;
@property (nonatomic, copy) SelectCellModelListener searchListener;
@property (nonatomic, copy) ClickListener clearRecordListener;

@end
