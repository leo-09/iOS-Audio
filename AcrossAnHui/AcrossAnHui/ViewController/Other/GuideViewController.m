//
//  GuideViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "GuideViewController.h"
#import "CGuideView.h"
#import "AdvertisementModel.h"
#import "AdvertisementLocalData.h"
#import "ServiceNetData.h"
#import "AdvLocalData.h"

@interface GuideViewController ()

@property (nonatomic, retain) CGuideView *guideView;

@end

@implementation GuideViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.view addSubview:self.guideView];
    
    // 预加载广告位数据
    ServiceNetData *serviceNetData = [[ServiceNetData alloc] init];
    serviceNetData.delegate = self;
    [serviceNetData getAdvertisementWithTag:@"getGuideAdv"];
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

// 网络请求成功
- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    if ([tag isEqualToString:@"getGuideAdv"]) {
        NSArray *dataArray = (NSArray *)result;
        if (dataArray && (dataArray.count > 0)) {
            NSArray *advs = [AdvertisementModel convertFromArray:dataArray];
            AdvertisementModel *advModel = advs[0];
            // 保存到本地
            [[AdvertisementLocalData sharedInstance] saveAdvertisementModel:advModel];
            
            // 保存广告页的图片
            [self saveImageWithPath:advModel.img];
        }
    }
}

// 获取广告位图片地址后，下载图片
- (void) saveImageWithPath:(NSString *)path {
    NSURL *url = [NSURL URLWithString:path];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImageWithURL:url
                   placeholder:[UIImage imageNamed:@"welcome"]
                       options:YYWebImageOptionProgressiveBlur
                    completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                        // 保存广告页的图片
                        if (image) {
                            [[AdvLocalData sharedInstance] saveImageDocuments:image];
                        }
                    }];
    
    [self.view addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(@0);
        make.height.equalTo(@0);
    }];
}

#pragma mark - getter/setter

- (CGuideView *) guideView {
    _guideView = [[CGuideView alloc] init];
    [self.view addSubview:_guideView];
    [_guideView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    @weakify(self)
    
    // 跳转到MainTabBarController
    [_guideView setShowMainPageListener:^{
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    return _guideView;
}

@end
