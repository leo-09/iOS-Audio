//
//  AboutUSViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"

/**
 关于我们
 */
@interface AboutUSViewController : CTXBaseViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

- (instancetype) initWithStoryboard;

@end
