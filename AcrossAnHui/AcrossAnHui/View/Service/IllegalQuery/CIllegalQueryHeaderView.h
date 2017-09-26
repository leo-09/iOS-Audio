//
//  CIllegalQueryHeaderView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "CarIllegalInfoModel.h"

/**
 违章查询 View的headerView
 */
@interface CIllegalQueryHeaderView : CTXBaseView<UIScrollViewDelegate>

@property (nonatomic, retain) NSArray<CarIllegalInfoModel *> *dataSource;
@property (nonatomic, assign) int currentIndex;

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *noteLabels;

@property (nonatomic, copy) SelectCellListener selectCurrentIndexListener;
@property (nonatomic, copy) SelectCellModelListener editCarListener;

/**
 编辑此车
 
 @param note 备注
 @param name 车型名字
 @param carType 车型类型
 */
- (void) setEditCarNote:(NSString *)note name:(NSString *)name carType:(NSString *)carType;

- (void) setSelectedIndex:(int)index;

@end
