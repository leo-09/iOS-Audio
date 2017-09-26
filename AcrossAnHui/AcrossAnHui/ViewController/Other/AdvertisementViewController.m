//
//  AdvertisementViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "AdvertisementViewController.h"
#import "AdvertisementModel.h"
#import "CTXWKWebViewController.h"
#import "AdvertisementLocalData.h"
#import "AdvLocalData.h"
#import "ServiceNetData.h"

@interface AdvertisementViewController ()

@property (nonatomic, retain) UIButton *btn;
@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, retain) UITapGestureRecognizer *gesture;

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, assign) int timeInterval;

@end

@implementation AdvertisementViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _timeInterval = 3;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
    
    [self addView];
    
    ServiceNetData *serviceNetData = [[ServiceNetData alloc] init];
    serviceNetData.delegate = self;
    [serviceNetData getAdvertisementWithTag:@"getGuideAdv"];
    
    // 提前定位
    [self startUpdatingLocationWithBlock:^{
        // nothing
    }];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"getGuideAdv"]) {// 更新广告页数据
        NSArray *dataArray = (NSArray *)result;
        if (dataArray && (dataArray.count > 0)) {
            NSArray *advs = [AdvertisementModel convertFromArray:dataArray];
            AdvertisementModel *advModel = advs[0];
            // 保存到本地
            [[AdvertisementLocalData sharedInstance] saveAdvertisementModel:advModel];
        } else {
            [[AdvertisementLocalData sharedInstance] removeAdvertisementModel];
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
}


#pragma mark - add view

- (void) addView {
    self.imageView = [[UIImageView alloc] init];
    
    UIImage *placeholderImage = [[AdvLocalData sharedInstance] getDocumentImage];
    if (!placeholderImage) {
        placeholderImage = [UIImage imageNamed:@"welcome"];
    }
    
    NSString *img = [[AdvertisementLocalData sharedInstance] getAdvertisementModel].img;
    NSURL *url = [NSURL URLWithString:img];
    [self.imageView setImageWithURL:url
                        placeholder:placeholderImage
                            options:YYWebImageOptionProgressiveBlur
                         completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                             // 保存广告页的图片
                             if (image) {
                                 [[AdvLocalData sharedInstance] saveImageDocuments:image];
                             }
                         }];
    
    // 添加手势
    self.gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:self.gesture];
    
    [self.view addSubview:self.imageView];
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _btn = [[UIButton alloc] init];
    NSString *text = [NSString stringWithFormat:@"跳过(%d)s", _timeInterval];
    [_btn setTitle:text forState:UIControlStateNormal];
    _btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btn.backgroundColor = UIColorFromRGBA(0xbdbdbd, 0.6);
    CTXViewBorderRadius(_btn, 5, 0, [UIColor clearColor]);
    [_btn addTarget:self action:@selector(skipToMainTabBarView) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_btn];
    [_btn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@90);
        make.height.equalTo(@30);
        make.right.equalTo(@(-20));
        make.top.equalTo(@20);
    }];
}

- (void) skipToMainTabBarView {
    [self invalidate];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)timerFire:(id)userinfo {
    _timeInterval--;
    NSString *text = [NSString stringWithFormat:@"跳过(%d)s", _timeInterval];
    [_btn setTitle:text forState:UIControlStateNormal];
    
    if (_timeInterval == 1) {
        [self.imageView removeGestureRecognizer:self.gesture];
    }
    
    if (_timeInterval == 0) {
        [self skipToMainTabBarView];
    }
}

// 跳转到活动界面
- (void) tapGesture {
    [self invalidate];
    
    CTXWKWebViewController *controller = [[CTXWKWebViewController alloc] init];
    AdvertisementModel *adv = [[AdvertisementLocalData sharedInstance] getAdvertisementModel];
    controller.name = adv.name;
    controller.url = [adv getActualURLWithToken:self.loginModel.token userID:self.loginModel.loginID];
    controller.desc = adv.desc;
    controller.isBackToRootVC = YES;
    [self basePushViewController:controller];
}

- (void) invalidate {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
