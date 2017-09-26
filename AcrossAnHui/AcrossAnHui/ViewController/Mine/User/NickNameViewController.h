//
//  NickNameViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/11.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"
#import "SettingNetData.h"

/**
 修改昵称
 */
@interface NickNameViewController : CTXBaseTableViewController

@property (nonatomic, retain) SettingNetData *settingNetData;

@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *saveLabel;

- (instancetype) initWithStoryboard;

@end
