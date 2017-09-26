//
//  RechargeViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"

/**
 充值
 */
@interface RechargeViewController : CTXBaseTableViewController {
    NSArray *moneyBtnArray;
}

@property (nonatomic, copy) NSString *ubalance;  // 用户余额

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UIButton *money20Btn;
@property (weak, nonatomic) IBOutlet UIButton *money50Btn;
@property (weak, nonatomic) IBOutlet UIButton *money100Btn;
@property (weak, nonatomic) IBOutlet UIButton *money500Btn;

@property (weak, nonatomic) IBOutlet UIImageView *alipayIV;
@property (weak, nonatomic) IBOutlet UIImageView *webChatIV;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;

- (instancetype) initWithStoryboard;

@end
