//
//  PublishInfoViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import "iflyMSC/IFlyMSC.h"// 讯飞语音

typedef enum PublishInfoType {
    PublishInfoType_ASK = 0,        // 问小畅
    PublishInfoType_PHOTO = 1,      // 随手拍
    PublishInfoType_TRAFFIC,        // 报路况
} PublishInfoType;

/**
 发表 问小畅、随手拍 和报路况
 */
@interface PublishInfoViewController : CTXBaseViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, IFlySpeechRecognizerDelegate>

@property (nonatomic, assign) PublishInfoType publishInfoType;

@property (nonatomic, retain) IFlySpeechRecognizer *iFlySpeechRecod;

@end
