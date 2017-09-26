//
//  CarAgencyRecordViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import "CTXSegmentedPageViewControllerDelegate.h"

/**
 车检代办的记录
 */
@interface CarAgencyRecordViewController : CTXBaseViewController<CTXSegmentedPageViewControllerDelegate>

@property(nonatomic,strong) NSString *viewTitle;

@property (nonatomic, assign) int currentPage;

@end
