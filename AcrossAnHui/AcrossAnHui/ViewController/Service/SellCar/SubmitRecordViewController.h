//
//  submitRecordViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import "CSubmitRecordView.h"

/**
 我要卖车 提交记录
 */
@interface SubmitRecordViewController : CTXBaseViewController

@property (nonatomic, retain) CSubmitRecordView *submitRecordView;

@property (nonatomic, assign) int currentPage;

@end
