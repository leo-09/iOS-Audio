//
//  CTXSegmentedPagerViewController.h
//  AcrossAnHui
//
//  Created by Hesham Abd-Elmegid on 23/12/12.
//  Modify by liyy on 2017/5/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import "CTXSegmentedControl.h"

/**
 集成 UIPageViewController
 */
@interface CTXSegmentedPagerViewController : CTXBaseViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (retain, nonatomic) CTXSegmentedControl *pageControl;
@property (retain, nonatomic) UIView *contentContainer;

@property (strong, nonatomic) NSMutableArray *pages;

- (void)setPageControlHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated;

- (UIViewController *)selectedController;

- (void)updateTitleLabels;

@end
