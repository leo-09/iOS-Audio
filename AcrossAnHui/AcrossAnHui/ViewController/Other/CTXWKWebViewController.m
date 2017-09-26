//
//  CTXWKWebViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXWKWebViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "AdvertisementViewController.h"
#import "PromptView.h"

@interface CTXWKWebViewController () {
    PromptView *promptView;
}

@end

@implementation CTXWKWebViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:UIColorFromRGB(CTXBaseViewColor)];
    [self addView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = self.name;
    
    // leftBarButtonItem
    backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_white"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    if (self.desc) {
        backItem.tintColor = UIColorFromRGB(CTXThemeColor);
        
        // rightBarButtonItem
        UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"right_share"] style:UIBarButtonItemStyleDone target:self action:@selector(share)];
        shareItem.tintColor = UIColorFromRGB(CTXThemeColor);
        self.navigationItem.rightBarButtonItem = shareItem;
        
        // 处理navigationBar
        self.navigationController.navigationBar.tintColor = UIColorFromRGB(CTXThemeColor);
        NSDictionary * attributes = @{ NSForegroundColorAttributeName:[UIColor blackColor] };
        self.navigationController.navigationBar.titleTextAttributes = attributes;
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.desc) {
        // 处理navigationBar
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        NSDictionary * attributes = @{ NSForegroundColorAttributeName:[UIColor whiteColor] };
        self.navigationController.navigationBar.titleTextAttributes = attributes;
        self.navigationController.navigationBar.barTintColor = UIColorFromRGB(CTXThemeColor);
    }
}

- (void) dealloc {
    if ([self isViewLoaded]) {
        [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    }
    
    // if you have set either WKWebView delegate also set these to nil here
    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];
}

- (void) close:(id)sender {
    if (self.wkWebView.canGoBack) {
        [self.wkWebView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
} 

#pragma mark - getter/setter

- (WKWebView *) wkWebView {
    if (!_wkWebView) {
        CGRect frame = CGRectMake(0, 0, CTXScreenWidth, CTXScreenHeight - CTXBarHeight - CTXNavigationBarHeight);
        _wkWebView = [[WKWebView alloc] initWithFrame:frame configuration:self.wkConfig];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        [self.view addSubview:_wkWebView];
    }
    return _wkWebView;
}

- (WKWebViewConfiguration *)wkConfig {
    if (!_wkConfig) {
        _wkConfig = [[WKWebViewConfiguration alloc] init];
        _wkConfig.allowsInlineMediaPlayback = YES;
        _wkConfig.allowsPictureInPictureMediaPlayback = YES;
    }
    return _wkConfig;
}

#pragma mark - private method

- (void) addView {
    // 初始化progressView
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, 2);
    self.progressView = [[UIProgressView alloc] initWithFrame:frame];
    self.progressView.tintColor = [UIColor colorWithRed:0.400 green:0.863 blue:0.133 alpha:1.000];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    
    // 添加KVO，WKWebView有一个属性estimatedProgress，就是当前网页加载的进度，所以监听这个属性。
    [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:nil];
    
    [self startLoad];
    
    if (self.desc) {
        // 线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [self.view addSubview:lineView];
    }
}

- (void)startLoad {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    request.timeoutInterval = 15.0f;
    // 添加缓存策略
    if ([self isNetworkEnable]) {
        request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    } else {
        request.cachePolicy = NSURLRequestReturnCacheDataDontLoad;
    }
    
    [self.wkWebView loadRequest:request];
}

//在监听方法中获取网页加载的进度，并将进度赋给progressView.progress
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.wkWebView.estimatedProgress;
        if (self.progressView.progress == 1) {
            // 添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
            @weakify(self)
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                @strongify(self)
                self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                @strongify(self)
                self.progressView.hidden = YES;
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void) back {
    if ([self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
    } else {
        if (self.isBackToRootVC) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void) share {
    // 分享
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareWebPageToPlatformType:platformType];
    }];
}

#pragma mark - WKNavigationDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
    
    NSString *path= [webView.URL absoluteString];
    NSString * newPath = [path lowercaseString];
    
    if ([newPath hasPrefix:@"sms:"] || [newPath hasPrefix:@"tel:"]) {
        NSURL *url = [NSURL URLWithString:newPath];
        
        CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 10.0) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];// 大于等于10.0系统使用此openURL方法
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self isIllegalPayment];
    
    if (!self.isNotUpdateNaviTitle) {
        // 页面加载完成 后将navigationBar的标题修改成 网页的标题
        if(webView.title && webView.title.length > 0) {
            self.navigationItem.title = webView.title;
        }
    }
    
    self.name = webView.title;
    
    //加载完成后隐藏progressView
    self.progressView.hidden = YES;
    
    if (promptView) {
        [promptView removeFromSuperview];
        promptView = nil;
    }
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
    
    /*  以下url都是 有针对性的适配的：
            itms-appss://itunes.apple.com/cn/app/tong-cheng-lu-you-jing-dian/id475966832?mt=8
            itms-appss://itunes.apple.com/app/apple-store/id1019481423?mt=8
     */
    
    if (error) {
        if ([error.userInfo.allKeys containsObject:@"NSLocalizedDescription"]) {
            NSString *descKey = error.userInfo[@"NSLocalizedDescription"];
            
            if ([descKey isEqualToString:@"unsupported URL"]) {
                // 显示 网络开小差界面
                [self addNilDataView];
                [promptView setRequestFailureWithImagePath:nil tint:@"抱歉，您访问的页面不存在"];
            }
        }
        
        id urlKey = error.userInfo[@"NSErrorFailingURLKey"];
        if ([urlKey isKindOfClass:[NSURL class]]) {
            NSURL *url = (NSURL *)urlKey;
            if ([url.absoluteString containsString:@"tel:"] || [url.absoluteString containsString:@"sms:"] || [url.absoluteString containsString:@"zaapp:"] ||
                [url.absoluteString isEqualToString:@"itms-appss://itunes.apple.com/cn/app/tong-cheng-lu-you-jing-dian/id475966832?mt=8"]) {
                
                // 包含：“打电话、发短信、下载”,不可出现加载失败
                if (promptView) {
                    [promptView removeFromSuperview];
                    promptView = nil;
                }
            } else {
                if (![url.absoluteString isEqualToString:@"itms-appss://itunes.apple.com/app/apple-store/id1019481423?mt=8"]) {
                    // 显示 网络开小差界面
                    [self addNilDataView];
                    [promptView setRequestFailureImageView];
                }
            }
        }
    }
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    self.url = navigationResponse.response.URL.absoluteString;
    CTXLog(@"%@",navigationResponse.response.URL.absoluteString);
    
    decisionHandler(WKNavigationResponsePolicyAllow);       // 允许跳转
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    self.url = navigationAction.request.URL.absoluteString;
    CTXLog(@"%@",navigationAction.request.URL.absoluteString);
    
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow); //允许跳转
}

#pragma mark - WKUIDelegate

// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    return [[WKWebView alloc] init];
}

// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:message ? message : @""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       completionHandler();
                                                   }];
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:message ? message : @""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:prompt
                                                                   message:prompt ? prompt : @""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alert.textFields[0].text?:@"");
    }];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 分享

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    // 创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    // 创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:(self.name ? self.name : @"")
                                                                             descr:(self.desc ? self.desc : @"")
                                                                         thumImage:[UIImage imageNamed:@"app_logo"]];
    //设置网页地址
    shareObject.webpageUrl = self.url;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********", error);
        } else {
            UMSocialLogInfo(@"response data is %@",data);
        }
    }];
}

#pragma mark - super method

- (BOOL) gestureRecognizerShouldBegin {
    if (self.isBackToRootVC) {
        return NO;// 取消侧滑返回
    } else {
        return YES;
    }
}

#pragma mark - 网络判断
- (BOOL) isNetworkEnable {
    struct sockaddr zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sa_len = sizeof(zeroAddress);
    zeroAddress.sa_family = AF_INET;
    SCNetworkReachabilityRef defaultRouteReachability =
    SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags =
    SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if (!didRetrieveFlags) {
        printf("Error. Count not recover network reachability flags\n");
        return NO;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL isNetworkEnable  =(isReachable && !needsConnection) ? YES : NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        /*  网络指示器的状态： 有网络 ： 开  没有网络： 关  */
        [UIApplication sharedApplication].networkActivityIndicatorVisible =isNetworkEnable;
    });
    return isNetworkEnable;
}

#pragma mark - PromptView

- (void) addNilDataView {
    if (!promptView) {
        promptView = [[PromptView alloc] init];
        
        @weakify(self)
        [promptView setPromptRefreshListener:^{
            @strongify(self)
            [self startLoad];
        }];
    }
    
    [self.view addSubview:promptView];
    [promptView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@3);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
}

#pragma mark - 违章缴费

- (void) isIllegalPayment {
    if ([self.name isEqualToString:@"违章缴费"]) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_ditu"]];
        [self.view addSubview:iv];
        [iv makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
            make.centerX.equalTo(self.view.centerX);
        }];
        
        [_wkWebView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(iv.top);
        }];
    }
}

@end
