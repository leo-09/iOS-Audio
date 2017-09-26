//
//  EditHomeServeViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/28.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "EditHomeServeViewController.h"
#import "ServeLocalData.h"
#import "CEditHomeServeView.h"

@interface EditHomeServeViewController ()

@property (nonatomic, retain) CEditHomeServeView *editHomeServeView;

@end

@implementation EditHomeServeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"编辑首页";
    
    // rightBarButtonItem
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(updateSelectedServe)];
    [rightBarButtonItem setTintColor:[UIColor whiteColor]];
    NSDictionary *dict = @{ NSFontAttributeName: [UIFont systemFontOfSize:CTXTextFont] };
    [rightBarButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    // 添加View
    [self.view addSubview:self.editHomeServeView];
}

- (void) updateSelectedServe {
    [[ServeLocalData sharedInstance] updateSelectedServe:self.editHomeServeView.superModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:EditHomeServeNotificationName object:nil userInfo:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (CEditHomeServeView *) editHomeServeView {
    if (!_editHomeServeView) {
        CGRect frame = CGRectMake(0, 0, CTXScreenWidth, (CTXScreenHeight - CTXNavigationBarHeight - CTXBarHeight));
        _editHomeServeView = [[CEditHomeServeView alloc] initWithFrame:frame];
        
        // 获取所有服务的集合
        ServeSuperModel *serveSuperModel = [[ServeLocalData sharedInstance] readSelectedServe];
        NSArray *serves = [[ServeLocalData sharedInstance] readLocalServeCollection];
        [_editHomeServeView addServeSuperModel:serveSuperModel serveModels:serves];
    }
    
    return _editHomeServeView;
}

@end
