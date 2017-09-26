//
//  CarInspectAgencyOnlinePayViewController.h
//  AcrossAnHui
//
//  Created by ztd on 2017/8/2.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTXBaseViewController.h"
#import "CarInspectAgencyOrderModel.h"


/**
 车检代办 在线支付
 */
@interface CarInspectAgencyOnlinePayViewController :  CTXBaseViewController<UINavigationBarDelegate> {
    BOOL isBack;
}

@property(nonatomic ,strong)CarInspectAgencyOrderModel * orderModel;
@property (nonatomic, assign) BOOL isFromRecord;// 入口

@end
