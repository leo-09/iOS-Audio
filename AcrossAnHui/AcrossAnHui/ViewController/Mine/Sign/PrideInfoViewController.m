//
//  PrideInfoViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "PrideInfoViewController.h"

@interface PrideInfoViewController ()

@end

@implementation PrideInfoViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"PrideInfoViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"奖品详情";
    
    self.nameLabel.text = [NSString stringWithFormat:@"领取人：%@", (self.model.name ? self.model.name : @"")];
    self.phoneLabel.text = [NSString stringWithFormat:@"手机号：%@", (self.model.phone ? self.model.phone : @"")];
    self.timeLabel.text = [NSString stringWithFormat:@"领取时间：%@", (self.model.rewardTime ? self.model.rewardTime : @"")];
    
    self.nameLeftConstraint.constant = (CTXScreenWidth - 300) / 2;
    self.phoneLeftConstraint.constant = (CTXScreenWidth - 300) / 2;
    self.timeLeftConstraint.constant = (CTXScreenWidth - 300) / 2;
    
    UIImage *image;
    if ([self.model.goodsName isEqualToString:@"5元话费"]) {
        image = [UIImage imageNamed:@"me_5"];
    } else if ([self.model.goodsName isEqualToString:@"30元话费"]) {
        image = [UIImage imageNamed:@"me_30"];
    } else if ([self.model.goodsName isEqualToString:@"300元加油基金"]) {
        image = [UIImage imageNamed:@"me_300"];
    } else if ([self.model.goodsName isEqualToString:@"iphone7"]) {
        image = [UIImage imageNamed:@"me_iPhone7"];
    } else {
        image = [UIImage imageNamed:@"me_prize"];
    }
    
    NSURL *url = [NSURL URLWithString:self.model.goodsImg];
    [self.imageView setImageWithURL:url placeholder:image];
}

@end
