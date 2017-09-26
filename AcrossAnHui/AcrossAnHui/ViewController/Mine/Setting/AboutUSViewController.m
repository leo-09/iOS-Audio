//
//  AboutUSViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "AboutUSViewController.h"
#import "CTXWKWebViewController.h"
#import "VersionTool.h"
#import "ServeTool.h"

@implementation AboutUSViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"Setting" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutUSViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关于我们";
    
    self.contentViewHeightConstraint.constant = CTXScreenHeight - 64 + 1;
    self.versionLabel.text = [NSString stringWithFormat:@"V%@", [[VersionTool sharedInstance] getVersion]];
}

- (IBAction)phone:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSString *phone = btn.titleLabel.text;
    
    [ServeTool callPhone:phone];
}

- (IBAction)website:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSString *content = btn.titleLabel.text;
    
    CTXWKWebViewController *controller = [[CTXWKWebViewController alloc] init];
    controller.name = @"安徽畅通行交通信息服务有限公司";
    controller.url = [NSString stringWithFormat:@"http://%@", content];
    controller.desc = @"畅行安徽APP是安徽畅通行交通信息服务有限公司紧随移动互联网时代潮流，倾力打造的一站式车主综合服务平台。 平台为皖籍车辆提供实时路况查询、违法查询、在线缴费、机动车检测预约、资讯等系列车主服务。";
    [self basePushViewController:controller];
}

@end
