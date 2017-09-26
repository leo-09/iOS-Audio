//
//  SelectBindedCarViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import "CarInspectNetData.h"
#import "HomeNetData.h"

/**
 选择车辆 进行 六年免检、车检代办、车检预约
 */
@interface SelectBindedCarViewController : CTXBaseViewController

@property (nonatomic, copy) NSString *fromViewController;

@property (nonatomic, retain) CarInspectNetData *carInspectNetData;
@property (nonatomic, retain) HomeNetData *homeNetData;

@end
