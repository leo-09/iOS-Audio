//
//  ParkCarSelectPayTableViewController.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"
#import "ParkRecordModel.h"

/**
 停车记录   选择支付
 */
@interface ParkCarSelectPayTableViewController : CTXBaseTableViewController{
  void (^selectCellListener)();
}

@property (nonatomic ,retain)NSString * businessCode ;
@property (nonatomic ,assign) double payFee ;

- (instancetype) initWithStoryboard ;

- (void) setSelectCellListener:(void (^)())listener;

@end
