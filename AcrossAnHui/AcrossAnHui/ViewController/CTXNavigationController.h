//
//  CTXNavigationController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/4/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 自定义UINavigationController
 */
@interface CTXNavigationController : UINavigationController<UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL enableRightGesture;

@end
