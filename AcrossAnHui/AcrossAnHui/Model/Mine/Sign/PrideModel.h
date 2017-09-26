//
//  PrideModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 奖品
 */
@interface PrideModel : CTXBaseModel

@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *validityBegin;
@property (nonatomic, copy) NSString *validityEnd;
@property (nonatomic, copy) NSString *goodsImg;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *rewardTime;
@property (nonatomic, copy) NSString *prideID;

@end
