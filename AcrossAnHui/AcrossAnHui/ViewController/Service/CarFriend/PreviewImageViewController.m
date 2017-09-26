//
//  PreviewImageViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/9.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "PreviewImageViewController.h"

@interface PreviewImageViewController ()

@end

@implementation PreviewImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"图片预览";
    
    // rightBarButtonItem
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(deleteImage)];
    [rightBarButtonItem setTintColor:[UIColor whiteColor]];
    NSDictionary *dict = @{ NSFontAttributeName: [UIFont systemFontOfSize:CTXTextFont] };
    [rightBarButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.view.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    
    // UIImageView
    UIImageView *iv = [[UIImageView alloc] initWithImage:self.image];
    [self.view addSubview:iv];
    [iv makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
}

- (void) deleteImage {
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:DeleteImageNotificationName object:_image userInfo:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
