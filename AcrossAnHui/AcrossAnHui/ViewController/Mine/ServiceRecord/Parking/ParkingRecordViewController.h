//
//  ParkingRecordViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import "CTXSegmentedPageViewControllerDelegate.h"

/**
 停车记录
 */
@interface ParkingRecordViewController : CTXBaseViewController<CTXSegmentedPageViewControllerDelegate>

@property(nonatomic,strong) NSString *viewTitle;

@property(nonatomic,retain)NSString * isPay;//传值 从停车服务界面过来  不传 从个人中心

@end
