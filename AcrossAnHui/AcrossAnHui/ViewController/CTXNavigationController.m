//
//  CTXNavigationController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/4/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXNavigationController.h"
#import "CTXBaseViewController.h"
#import "CTXBaseTableViewController.h"

#define IOS7_PLUS [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

@implementation CTXNavigationController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName:[UIColor whiteColor] };
    
    if (IOS7_PLUS) {
        [self.navigationBar setTranslucent:NO];
    }
    self.navigationBar.barTintColor = UIColorFromRGB(CTXThemeColor);
    
    // 去除黑线
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.enableRightGesture = YES;
    self.interactivePopGestureRecognizer.delegate = self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.topViewController isKindOfClass:[CTXBaseViewController class]]) {
        if ([self.topViewController respondsToSelector:@selector(gestureRecognizerShouldBegin)]) {
            CTXBaseViewController *vc = (CTXBaseViewController *) self.topViewController;
            self.enableRightGesture = [vc gestureRecognizerShouldBegin];
        }
    } else if ([self.topViewController isKindOfClass:[CTXBaseTableViewController class]]) {
        if ([self.topViewController respondsToSelector:@selector(gestureRecognizerShouldBegin)]) {
            CTXBaseTableViewController *vc = (CTXBaseTableViewController *) self.topViewController;
            self.enableRightGesture = [vc gestureRecognizerShouldBegin];
        }
    } else {
        self.enableRightGesture = NO;
    }
    
    return self.enableRightGesture;
}

#pragma mark - push

- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[CTXBaseViewController class]]) {
        if ([viewController respondsToSelector:@selector(gestureRecognizerShouldBegin)]) {
            CTXBaseViewController *vc = (CTXBaseViewController *) viewController;
            self.enableRightGesture = [vc gestureRecognizerShouldBegin];
        }
    } else if ([self.topViewController isKindOfClass:[CTXBaseTableViewController class]]) {
        if ([self.topViewController respondsToSelector:@selector(gestureRecognizerShouldBegin)]) {
            CTXBaseTableViewController *vc = (CTXBaseTableViewController *) self.topViewController;
            self.enableRightGesture = [vc gestureRecognizerShouldBegin];
        }
    } else {
        self.enableRightGesture = NO;
    }
    
    [super pushViewController:viewController animated:YES];
}

#pragma mark - pop

- (NSArray<UIViewController *> *) popToRootViewControllerAnimated:(BOOL) animated {
    self.enableRightGesture = YES;
    return [super popToRootViewControllerAnimated:animated];
}

- (UIViewController *) popViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count == 1) {
        self.enableRightGesture = YES;
    } else {
        NSUInteger index = self.viewControllers.count - 2;
        UIViewController *destinationController = [self.viewControllers objectAtIndex:index];
        
        if ([destinationController isKindOfClass:[CTXBaseViewController class]]) {
            if ([destinationController respondsToSelector:@selector(gestureRecognizerShouldBegin)]) {
                CTXBaseViewController *vc = (CTXBaseViewController *)destinationController;
                self.enableRightGesture = [vc gestureRecognizerShouldBegin];
            }
        } else if ([self.topViewController isKindOfClass:[CTXBaseTableViewController class]]) {
            if ([self.topViewController respondsToSelector:@selector(gestureRecognizerShouldBegin)]) {
                CTXBaseTableViewController *vc = (CTXBaseTableViewController *) self.topViewController;
                self.enableRightGesture = [vc gestureRecognizerShouldBegin];
            }
        } else {
            self.enableRightGesture = NO;
        }
    }
    
    return [super popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *) popToViewController:(UIViewController *) viewController animated:(BOOL)animated {
    if (self.viewControllers.count == 1) {
        self.enableRightGesture = YES;
    } else {
        UIViewController *destinationController = viewController;
        
        if ([destinationController isKindOfClass:[CTXBaseViewController class]]) {
            if ([destinationController respondsToSelector:@selector(gestureRecognizerShouldBegin)]) {
                CTXBaseViewController *vc = (CTXBaseViewController *)destinationController;
                self.enableRightGesture = [vc gestureRecognizerShouldBegin];
            }
        } else if ([self.topViewController isKindOfClass:[CTXBaseTableViewController class]]) {
            if ([self.topViewController respondsToSelector:@selector(gestureRecognizerShouldBegin)]) {
                CTXBaseTableViewController *vc = (CTXBaseTableViewController *) self.topViewController;
                self.enableRightGesture = [vc gestureRecognizerShouldBegin];
            }
        } else {
            self.enableRightGesture = NO;
        }
    }
    
    return [super popToViewController:viewController animated:animated];
}

@end
