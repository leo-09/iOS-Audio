//
//  CTXWebViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"

/**
  加载本地html的页面
 */
@interface CTXWebViewController : CTXBaseViewController<UIWebViewDelegate>

@property (nonatomic, copy) NSString *naviTitle;
@property (nonatomic, copy) NSString *address;

@property (retain, nonatomic) UIWebView *webView;

@end
