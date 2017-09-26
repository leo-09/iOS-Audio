//
//  CSelectCarTypeView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/14.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "CarTypeModel.h"
#import "PromptView.h"

typedef void (^SelectCarTypeModelListener)(id cbModel, id csModel);

/**
 车型选择 View
 */
@interface CSelectCarTypeView : CTXBaseView<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
    PromptView *promptView;
}

@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, retain) NSArray<CarTypeModel *> *carTypes;// 车型的结果集合
@property (nonatomic, retain) NSMutableArray *titleArray;// 索引集合
@property (nonatomic, retain) NSMutableArray *contentArray;// 汽车品牌的集合(和索引顺序一样)
@property (nonatomic, retain) NSMutableArray<CarTypeModel *> *searchCarTypeMode;// 搜索的汽车品牌
@property (nonatomic, retain) NSArray<CarTypeModel *> *selectCarTypeMode; // 选择的汽车品牌

@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, strong) SelectCarTypeModelListener selectCBModelListener;
@property (nonatomic, copy) RefreshDataListener refreshCarTypeModelListener;

- (void) addTitleArray:(NSMutableArray *)titleArray contentArray:(NSMutableArray *)contentArray;

/**
 是否可以返回上一个ViewController

 @return isSearch 或者 isSelect，都不可以返回,只返回到展现所有品牌内容
 */
- (BOOL) canPopToNavigationController;

@end
