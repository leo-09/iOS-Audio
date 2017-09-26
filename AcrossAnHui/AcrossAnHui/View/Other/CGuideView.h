//
//  CGuideView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"

/**
 打开APP的引导页
 */
@interface CGuideView : CTXBaseView<UIScrollViewDelegate>

@property (nonatomic, retain) UIPageControl *pageControl;

@property (nonatomic, strong) ClickListener showMainPageListener;

@end
