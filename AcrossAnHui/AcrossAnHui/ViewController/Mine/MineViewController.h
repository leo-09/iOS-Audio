//
//  MineViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import "SelectView.h"

/**
 "我的"ViewController
 */
@interface MineViewController : CTXBaseViewController

@property (nonatomic, copy) NSString *account;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

// TODO
@property (weak, nonatomic) IBOutlet UILabel *carCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;

@property (weak, nonatomic) IBOutlet SelectView *signView;
@property (weak, nonatomic) IBOutlet SelectView *garageView;
@property (weak, nonatomic) IBOutlet SelectView *serveView;
@property (weak, nonatomic) IBOutlet SelectView *reportView;
@property (weak, nonatomic) IBOutlet SelectView *walletView;
@property (weak, nonatomic) IBOutlet SelectView *prideView;
@property (weak, nonatomic) IBOutlet SelectView *shareView;
@property (weak, nonatomic) IBOutlet SelectView *settingView;

- (instancetype) initWithStoryboard;

@end
