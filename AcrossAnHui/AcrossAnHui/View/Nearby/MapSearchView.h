//
//  MapSearchView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/1.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import "NearByMAPointAnnotation.h"

typedef void (^UpdateViewHeightBlock)(BOOL isMax);

/**
 地图上的搜索
 */
@interface MapSearchView : CTXBaseView<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, AMapSearchDelegate>

@property (nonatomic, retain) NSMutableArray<NearByMAPointAnnotation *> *searchResultData;

@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) AMapSearchAPI *aMapSearchAPI;
@property (nonatomic, retain) AMapPOIKeywordsSearchRequest *keyPOISearRequst;

@property (nonatomic, copy) ClickListener startSearchBlock;
@property (nonatomic, copy) SelectCellModelListener stopSearchBlock;
@property (nonatomic, copy) UpdateViewHeightBlock updateViewHeightBlock;
@property (nonatomic, copy) SelectCellModelListener selectPointAnnotationListener;

- (void) textFieldResignFirstResponder;

@end
