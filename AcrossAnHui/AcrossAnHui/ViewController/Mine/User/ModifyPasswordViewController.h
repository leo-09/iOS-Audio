//
//  ModifyPasswordViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/11.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"
#import "SettingNetData.h"

/**
 修改密码
 */
@interface ModifyPasswordViewController : CTXBaseTableViewController {
    NSString *newPassword;
}

@property (nonatomic, retain) SettingNetData *settingNetData;

@property (weak, nonatomic) IBOutlet UITextField *oldPswTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswTextField1;
@property (weak, nonatomic) IBOutlet UITextField *pswTextField2;
@property (weak, nonatomic) IBOutlet UILabel *saveLabel;

- (instancetype) initWithStoryboard;

@end
