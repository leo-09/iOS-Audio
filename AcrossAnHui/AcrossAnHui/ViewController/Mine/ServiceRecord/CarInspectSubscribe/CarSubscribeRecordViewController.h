//
//  CarSubscribeRecordViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import "CTXSegmentedPageViewControllerDelegate.h"

/**
 车检预约的记录
 */
@interface CarSubscribeRecordViewController : CTXBaseViewController<CTXSegmentedPageViewControllerDelegate>

@property(nonatomic,strong) NSString *viewTitle;

@property (nonatomic, assign) BOOL isFromPayResultViewController;// 是否支付成功后点完成过来的
@property (nonatomic, assign) int currentPage;

@end
