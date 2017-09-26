//
//  AccountViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"
#import "SettingNetData.h"

/**
 个人资料
 */
@interface AccountViewController : CTXBaseTableViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (nonatomic, retain) SettingNetData *settingNetData;

- (instancetype) initWithStoryboard;

@end
