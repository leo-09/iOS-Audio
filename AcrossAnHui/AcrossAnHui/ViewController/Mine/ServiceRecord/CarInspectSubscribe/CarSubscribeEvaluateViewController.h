//
//  CarSubscribeEvaluateViewController.h
//  AcrossAnHui
//
//  Created by ztd on 2017/8/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import "SubscribeModel.h"

/**
 车检预约的评价
 */
@interface CarSubscribeEvaluateViewController : CTXBaseViewController{
   void (^getbackViewController)();
}

@property (nonatomic, retain) SubscribeModel *model;

-(void)setGetbackViewController:(void (^)())listener;

@end
