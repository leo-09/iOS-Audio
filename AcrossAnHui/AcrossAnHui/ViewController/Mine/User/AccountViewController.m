//
//  AccountViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "AccountViewController.h"
#import "NickNameViewController.h"
#import "MobileViewController.h"
#import "ModifyPasswordViewController.h"
#import "ImageTool.h"

@implementation AccountViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"Setting" bundle:nil] instantiateViewControllerWithIdentifier:@"AccountViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人资料";
    CTXViewBorderRadius(self.headerImageView, self.headerImageView.frame.size.width / 2, 0, [UIColor clearColor]);
    
    self.settingNetData = [[SettingNetData alloc] init];
    self.settingNetData.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.headerImageView setImageWithURL:[NSURL URLWithString:self.loginModel.photo] placeholder:[UIImage imageNamed:@"touxiangzw"]];
    self.nickNameLabel.text = self.loginModel.loginName;
    self.genderLabel.text = [self.loginModel genderName];
    self.phoneLabel.text = self.loginModel.phone;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {// 头像
        [self showPhotoAlertController];
    } else if (indexPath.row == 3) {// 昵称
        NickNameViewController *controller = [[NickNameViewController alloc] initWithStoryboard];
        [self basePushViewController:controller];
    } else if (indexPath.row == 5) {// 性别
        [self showGenderAlertController];
    } else if (indexPath.row == 7) {// 手机号
        MobileViewController *controller = [[MobileViewController alloc] initWithStoryboard];
        [self basePushViewController:controller];
    } else if (indexPath.row == 9) {// 微信号
        // TODO
    } else if (indexPath.row == 11) {// 修改密码
        ModifyPasswordViewController *controller = [[ModifyPasswordViewController alloc] initWithStoryboard];
        [self basePushViewController:controller];
    }
}

#pragma mark - private method

- (void) showGenderAlertController {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"请选择性别" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _genderLabel.text = @"男";
        [self.settingNetData updateUserWithToken:self.loginModel.token photo:nil gender:@"0" nickName:nil tag:@"updateUserGenderTag"];
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _genderLabel.text = @"女";
        [self.settingNetData updateUserWithToken:self.loginModel.token photo:nil gender:@"1" nickName:nil tag:@"updateUserGenderTag"];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:photoAction];
    [controller addAction:cameraAction];
    [controller addAction:cancleAction];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) showPhotoAlertController {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"请选择照片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:photoAction];
    [controller addAction:cameraAction];
    [controller addAction:cancleAction];
    
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString*)kUTTypeImage]) {
        UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        [self performSelector:@selector(showImage:) withObject:image afterDelay:0];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) showImage:(UIImage*) image {
    [self.headerImageView setImage:image];
    
    [self showHubWithLoadText:@"头像上传中..."];
    
    // 上传头像
    NSData *data = [ImageTool compressImage:image];
    [self.settingNetData uploadUserHeaderImageWithData:data tag:@"uploadUserHeaderImageTag"];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"uploadUserHeaderImageTag"]) {
        [self hideHub];
        
        if ([result isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray *)result;
            if (array.count > 0) {
                NSString *path = array.firstObject[@"publishLocation"];
                [self.settingNetData updateUserWithToken:self.loginModel.token photo:path gender:nil nickName:nil tag:@"updateUserHeaderImageTag"];
            }
        }
    }
    
    if ([tag isEqualToString:@"updateUserHeaderImageTag"]) {
        [self showTextHubWithContent:@"头像上传成功"];
        
        // 保存最新账户信息
        [self updateLoginModelWithResult:(NSDictionary *)result];
        
        // 通知头像更新
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotificationName object:nil userInfo:nil];
    }
    
    if ([tag isEqualToString:@"updateUserGenderTag"]) {
        // 保存最新账户信息
        [self updateLoginModelWithResult:(NSDictionary *)result];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    
    [self hideHub];
    if ([tag isEqualToString:@"uploadUserHeaderImageTag"]) {
        [self showTextHubWithContent:@"头像上传失败"];
    }
}

@end
