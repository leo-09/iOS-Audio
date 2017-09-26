//
//  CCarFreeInspectAddressView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/28.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "AreaModel.h"
#import "TPKeyboardAvoidingTableView.h"

/**
 选择地址View
 */
@interface CCarFreeInspectAddressView : CTXBaseView<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate> {
    BOOL showCity;
    BOOL showTown;
}

@property (nonatomic, retain) TPKeyboardAvoidingTableView *tableView;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UILabel *tintLabel;

@property (nonatomic, retain) NSArray<TownModel *> *townModels;

@property (nonatomic, retain) CarFreeInspectAddressModel *model;

@property (nonatomic, copy) SelectCellModelListener addAddressListener;

- (void) setTownModels:(NSArray<TownModel *> *)townModels model:(CarFreeInspectAddressModel *)model;

@end
