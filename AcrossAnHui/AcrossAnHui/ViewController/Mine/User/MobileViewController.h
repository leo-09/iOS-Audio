//
//  MobileViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/11.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"
#import "SettingNetData.h"

/**
 修改手机号码
 */
@interface MobileViewController : CTXBaseTableViewController {
    NSString *account;
}

@property (nonatomic, retain) SettingNetData *settingNetData;

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, assign) int timeCount;

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UILabel *modifyLabel;

- (instancetype) initWithStoryboard;

@end
