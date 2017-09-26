//
//  CTXRecordPagerViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/9/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXRecordPagerViewController.h"
#import "CTXSegmentedPageViewControllerDelegate.h"

@interface CTXRecordPagerViewController () {
    BOOL isShowSelect;
    BOOL delRightButton;
    
    UIImageView *selectImg;
    UIView *rightView;
}

@property (strong, nonatomic)UIPageViewController *pageViewController;

@end

@implementation CTXRecordPagerViewController

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
    
    // 停车记录的筛选按钮 删除/还原筛选内容的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteRightButton) name:ParkingRecordDeleteNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resotreRightButton) name:ParkingRecordRestoreNotificationName object:nil];
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
    NSUInteger index = [self.pageControl selectedSegmentIndex];
    
    [self judgeWithIndex:index];
    
    return self.pages[index];
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
    
    [self judgeWithIndex:index];
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    
    return self.pages[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self.pages indexOfObject:viewController];
    
    [self judgeWithIndex:index];
    
    if ((index == NSNotFound)||(index + 1 >= [self.pages count])) {
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

#pragma 导航右按钮：筛选

// 第3个的停车记录 有导航右按钮：筛选
- (void) judgeWithIndex:(NSUInteger) index {
    if (delRightButton) {
        [self removeRightBarButtonItem];
        return;
    }
    
    if (index == 3) {// 停车记录
        [self addRightBarButtonItem];
    } else {
        [self removeRightBarButtonItem];
    }
}

- (void) removeRightBarButtonItem {
    self.navigationItem.rightBarButtonItem = nil;
}

- (void) addRightBarButtonItem {
    // 自定义 导航栏右侧按钮
    if (!rightView) {
        rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        rightView.backgroundColor = [UIColor clearColor];
        
        UILabel * changeAddressLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, 34, 20)];
        changeAddressLab.text = @"筛选";
        changeAddressLab.textColor = [UIColor whiteColor];
        [rightView addSubview:changeAddressLab];
        changeAddressLab.font =  [UIFont systemFontOfSize:15];
        
        selectImg = [[UIImageView alloc]initWithFrame:CGRectMake(34, 8, 16, 8)];
        selectImg.image = [UIImage imageNamed:@"park_down"];
        [rightView addSubview:selectImg];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
        tap.cancelsTouchesInView = NO;
        
        [rightView addGestureRecognizer:tap];
        isShowSelect = NO;
    }
    
    UIBarButtonItem * addressRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = addressRight;
}

-(void)tapGesture {
    isShowSelect = !isShowSelect;
    
    if (isShowSelect == YES) {// 出现
        selectImg.image = [UIImage imageNamed:@"park_more"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ParkingRecordShowNotificationName object:nil userInfo:nil];
    } else {// 消失
        selectImg.image = [UIImage imageNamed:@"park_down"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ParkingRecordHideNotificationName object:nil userInfo:nil];
    }
}

- (void) deleteRightButton {
    delRightButton = YES;
}

- (void) resotreRightButton {
    isShowSelect = NO;
    selectImg.image = [UIImage imageNamed:@"park_down"];
}

@end
