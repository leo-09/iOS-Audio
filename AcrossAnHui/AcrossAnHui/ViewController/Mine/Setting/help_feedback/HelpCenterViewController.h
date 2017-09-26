//
//  HelpCenterViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/9.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import "CTXSegmentedPageViewControllerDelegate.h"

/**
 帮助中心
 */
@interface HelpCenterViewController : CTXBaseViewController<CTXSegmentedPageViewControllerDelegate>

@property(nonatomic,strong) NSString *viewTitle;

@end
