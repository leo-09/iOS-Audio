//
//  ParkRecordDetailViewController.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkRecordModel.h"
#import "CTXBaseViewController.h"

/**
 停车记录 记录详情
 */
@interface ParkRecordDetailViewController : CTXBaseViewController{
    void (^selectCellListener)();
}

@property (nonatomic ,retain)ParkRecordModel * model ;

- (void) setSelectCellListener:(void (^)())listener;

@end
