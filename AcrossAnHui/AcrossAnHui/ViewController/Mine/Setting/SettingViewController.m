//
//  SettingViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/21.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "SettingViewController.h"
#import "CTXSegmentedPagerViewController.h"
#import "HelpCenterViewController.h"
#import "FeedBackViewController.h"
#import "AboutUSViewController.h"
#import "YYCacheManager.h"

@implementation SettingViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"Setting" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingViewController"];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    CTXViewBorderRadius(_quitLoginLabel, 5.0, 0, [UIColor clearColor]);
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 缓存信息
    _cacheLabel.text = [[YYCacheManager sharedInstance] sizeOfCache];
    
    // 获取帐号信息
    NSString *account = [[LoginInfoLocalData sharedInstance] getAccount];
    NSString *psw = [[LoginInfoLocalData sharedInstance] getPassword];
    if (account && psw && ![account isEqualToString:@""] && ![psw isEqualToString:@""]) {
        _quitLoginCell.hidden = NO;
    } else {
        _quitLoginCell.hidden = YES;
    }
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {// 清理缓存
        [self clearCache];
    } else if (indexPath.row == 3) {// 帮助与反馈
        [self help_feekback];
    } else if (indexPath.row == 5) {// 关于我们
        [self aboutUS];
    } else if (indexPath.row == 7) {// 退出登录
        [self quitLogin];
    }
}

#pragma mark - private method

- (void) help_feekback {
    CTXSegmentedPagerViewController *controller = [[CTXSegmentedPagerViewController alloc] init];
    controller.title = @"帮助与反馈";
    
    // 添加ViewController集合
    NSMutableArray *pages = [NSMutableArray new];
    
    HelpCenterViewController *helpController = [[HelpCenterViewController alloc] init];
    helpController.viewTitle = @"帮助中心";
    [pages addObject:helpController];
    
    FeedBackViewController *feedController = [[FeedBackViewController alloc] initWithStoryboard];
    feedController.viewTitle = @"意见反馈";
    [pages addObject:feedController];
    
    [controller setPages:pages];
    
    [self basePushViewController:controller];
}

- (void) clearCache {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                        message:@"确认清除缓存数据吗？"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[YYCacheManager sharedInstance] clearCache];
        _cacheLabel.text = @"0.0M";
    }];
    [controller addAction:cancelAction];
    [controller addAction:okAction];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) aboutUS {
    AboutUSViewController *controller = [[AboutUSViewController alloc] initWithStoryboard];
    [self basePushViewController:controller];
}

- (void) quitLogin {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                        message:@"确认退出该帐号吗？"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[LoginInfoLocalData sharedInstance] clearInfo];
        [[LoginInfoLocalData sharedInstance] removeLoginModel];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LogoffNotificationName object:nil userInfo:nil];
    }];
    [controller addAction:cancelAction];
    [controller addAction:okAction];
    
    [self presentViewController:controller animated:YES completion:nil];
}

@end
