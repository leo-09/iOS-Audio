//
//  OneListSelectorView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "OneListSelectorViewCell.h"

/**
 一个列表的 tableView 的选择器
 */
@interface OneListSelectorView : CTXBaseView<UITableViewDelegate, UITableViewDataSource, CAAnimationDelegate>

@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *btnTitle;
@property (nonatomic, assign) BOOL isMultiSelect;// 是否多选

@property (nonatomic, retain) UIView *bgView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIButton *btn;

@property (nonatomic, copy) SelectCellModelListener selectorResultListener;

- (void) showView;

@end
