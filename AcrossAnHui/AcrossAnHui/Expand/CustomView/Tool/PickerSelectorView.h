//
//  PickerSelectorView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"

/**
 UIPickerView 的选择器
 */
@interface PickerSelectorView : CTXBaseView<CAAnimationDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, retain) UIView *bgView;
@property (nonatomic, retain) UIButton *cancleBtn;
@property (nonatomic, retain) UIButton *submitBtn;
@property (nonatomic, retain) UIPickerView *pickerView;

@property (nonatomic, retain) NSArray *dataSource;
@property (nonatomic, retain) NSArray *currentValue;

@property (nonatomic, copy) NSString *cancleBtnTitle;
@property (nonatomic, copy) NSString *submitBtnTitle;

// 返回的参数是一个数组
@property (nonatomic, copy) SelectCellModelListener selectorResultListener;

- (void) showView;

@end
