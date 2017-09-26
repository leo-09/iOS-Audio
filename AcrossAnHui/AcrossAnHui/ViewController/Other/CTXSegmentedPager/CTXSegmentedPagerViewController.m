//
//  CTXSegmentedPagerViewController.m
//  AcrossAnHui
//
//  Created by Hesham Abd-Elmegid on 23/12/12.
//  Modify by liyy on 2017/5/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXSegmentedPagerViewController.h"
#import "CTXSegmentedPageViewControllerDelegate.h"

@interface CTXSegmentedPagerViewController ()

@property (strong, nonatomic)UIPageViewController *pageViewController;

@end

@implementation CTXSegmentedPagerViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.contentContainer];
    
    [self addChildViewController:self.pageViewController];
    [self.contentContainer addSubview:self.pageViewController.view];
    
    if ([self.pages count] > 0) {
        [self.pageViewController setViewControllers:@[self.pages[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    }
    [self updateTitleLabels];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if ([self.pages count] > 0) {
//        [self.pageViewController setViewControllers:@[self.pages[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
//    }
//    [self updateTitleLabels];
}

#pragma mark - getter/setter

- (CTXSegmentedControl *) pageControl {
    if (!_pageControl) {
        CGRect pcFrame = CGRectMake(0, 0, self.view.size.width, 50);
        _pageControl = [[CTXSegmentedControl alloc] initWithFrame:pcFrame];
        _pageControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _pageControl.selectionIndicatorHeight = 2.0f;
        _pageControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        // 添加点击事件
        [_pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _pageControl;
}

- (UIView *) contentContainer {
    if (!_contentContainer) {
        CGRect ccFrame = CGRectMake(0, 50, self.view.size.width, self.view.size.height - 50);
        _contentContainer = [[UIView alloc] initWithFrame:ccFrame];
        _contentContainer.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    }
    
    return _contentContainer;
}

- (UIPageViewController *) pageViewController {
    if (!_pageViewController) {
        // Init PageViewController
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.view.frame = CGRectMake(0, 0, self.contentContainer.frame.size.width, self.contentContainer.frame.size.height);
        [_pageViewController setDataSource:self];
        [_pageViewController setDelegate:self];
        [_pageViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    }
    
    return _pageViewController;
}

#pragma mark - Cleanup

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup

- (void)updateTitleLabels {
    [self.pageControl setSectionTitles:[self titleLabels]];
}

- (NSArray *)titleLabels {
    NSMutableArray *titles = [NSMutableArray new];
    for (UIViewController *vc in self.pages) {
        if ([vc conformsToProtocol:@protocol(CTXSegmentedPageViewControllerDelegate)] &&
            [vc respondsToSelector:@selector(viewControllerTitle)] &&
            [((UIViewController<CTXSegmentedPageViewControllerDelegate> *) vc) viewControllerTitle]) {
            
            [titles addObject:[((UIViewController<CTXSegmentedPageViewControllerDelegate> *)vc) viewControllerTitle]];
        } else {
            [titles addObject:(vc.title ? vc.title : NSLocalizedString(@"NoTitle", @""))];
        }
    }
    return [titles copy];
}

- (void)setPageControlHidden:(BOOL)hidden animated:(BOOL)animated {
    [UIView animateWithDuration:(animated ? 0.25f : 0.f) animations:^{
        if (hidden) {
            self.pageControl.alpha = 0.0f;
        } else {
            self.pageControl.alpha = 1.0f;
        }
    }];
    
    [self.pageControl setHidden:hidden];
    [self.view setNeedsLayout];
}

- (UIViewController *)selectedController {
    return self.pages[[self.pageControl selectedSegmentIndex]];
}

- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated {
    if (index < [self.pages count]) {
        [self.pageControl setSelectedSegmentIndex:index animated:YES];
        [self.pageViewController setViewControllers:@[self.pages[index]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:animated
                                         completion:NULL];
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self.pages indexOfObject:viewController];
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    
    return self.pages[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self.pages indexOfObject:viewController];
    
    if ((index == NSNotFound)||(index+1 >= [self.pages count])) {
        return nil;
    }
    
    return self.pages[++index];
}

- (void)pageViewController:(UIPageViewController *)viewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (!completed) {
        return;
    }
    
    [self.pageControl setSelectedSegmentIndex:[self.pages indexOfObject:[viewController.viewControllers lastObject]] animated:YES];
}

#pragma mark - Callback

- (void)pageControlValueChanged:(id)sender {
    UIPageViewControllerNavigationDirection direction = UIPageViewControllerNavigationDirectionReverse;
    if ([self.pageControl selectedSegmentIndex] > [self.pages indexOfObject:[self.pageViewController.viewControllers lastObject]]) {
        direction = UIPageViewControllerNavigationDirectionForward;
    }
    
    [self.pageViewController setViewControllers:@[[self selectedController]] direction:direction animated:YES completion:NULL];
}

#pragma mark - getter/setter

- (NSMutableArray *)pages {
    if (!_pages) {
        _pages = [[NSMutableArray alloc] init];
    }
    return _pages;
}

@end
