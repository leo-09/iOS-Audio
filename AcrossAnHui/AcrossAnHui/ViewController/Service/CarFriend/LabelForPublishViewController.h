//
//  LabelForPublishViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import "PublishInfoViewController.h"
#import "EventDetailModel.h"

/**
 发表 问小畅、随手拍 和报路况 选择标签
 */
@interface LabelForPublishViewController : CTXBaseViewController

@property (nonatomic, assign) PublishInfoType publishInfoType;
@property (nonatomic, retain) EventDetailModel *currentModel;           // 选中的标签
@property (nonatomic, retain) SuperEventDetailModel *currentSuperModel; // 选中的标签组

@end
