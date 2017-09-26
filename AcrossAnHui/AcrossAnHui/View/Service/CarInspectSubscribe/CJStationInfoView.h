//
//  CJStationInfoView.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTXBaseView.h"
#import "CSearchNewsInfoCell.h"

@interface CJStationInfoView : CTXBaseView<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UIView *textView;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UIButton *textViewDeleteBtn;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) UIButton *footerBtn;

@property (nonatomic, retain) NSArray *hotKeywords; // 热门搜索
@property (nonatomic, retain) NSArray *records;     // 搜索记录
@property (nonatomic, retain) NSMutableArray *dataSource;

@property (nonatomic, copy) ClickListener backListener;
@property (nonatomic, copy) SelectCellModelListener searchListener;
@property (nonatomic, copy) ClickListener clearRecordListener;
@property (nonatomic, copy) SelectCellModelListener selectStationCellListener;

- (void) refreshDataSource:(NSArray *)data;

@end
