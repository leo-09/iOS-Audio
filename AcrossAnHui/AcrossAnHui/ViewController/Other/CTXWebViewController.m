//
//  CTXWebViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXWebViewController.h"

@implementation CTXWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.naviTitle;
    
    CGRect frame = CGRectMake(0, 0, CTXScreenWidth, CTXScreenHeight - CTXBarHeight - CTXNavigationBarHeight);
    self.webView = [[UIWebView alloc] initWithFrame:frame];
    [self.webView setBackgroundColor:UIColorFromRGB(CTXBaseViewColor)];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.view addSubview:self.webView];
    
    NSString *path=[[NSBundle mainBundle] pathForResource:self.address ofType:@".html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    if(url) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 处理navigationBar
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSDictionary * attributes = @{ NSForegroundColorAttributeName:[UIColor whiteColor] };
    self.navigationController.navigationBar.titleTextAttributes = attributes;
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(CTXThemeColor);
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showHubWithLoadText:@"加载中..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideHub];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideHub];
}

@end
