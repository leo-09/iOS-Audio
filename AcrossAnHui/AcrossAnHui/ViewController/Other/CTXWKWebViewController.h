//
//  CTXWKWebViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import <WebKit/WebKit.h>
#import "AdvertisementModel.h"

/**
 加载web的html的页面
 */
@interface CTXWKWebViewController : CTXBaseViewController<UIWebViewDelegate, WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;    // 广告详情url
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) BOOL isNotUpdateNaviTitle;
@property (nonatomic, assign) BOOL isBackToRootVC;

// WKNavigationDelegate主要处理一些跳转、加载处理操作，WKUIDelegate主要处理JS脚本，确认框，警告框等
@property (retain, nonatomic) WKWebView *wkWebView;
@property (nonatomic, strong) WKWebViewConfiguration *wkConfig;
@property (nonatomic, strong) UIProgressView *progressView;

@end
