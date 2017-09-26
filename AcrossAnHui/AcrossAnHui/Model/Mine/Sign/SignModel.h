//
//  SignModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/11.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

@interface SignList : CTXBaseModel

@property (nonatomic, copy) NSString *signDate;

@end

/**
 签到
 */
@interface SignModel : CTXBaseModel

@property (nonatomic, copy) NSString *curDate;                // 当前时间
@property (nonatomic, copy) NSString *content;                //
@property (nonatomic, copy) NSString *curMonthSignNum;        // 本月已累计签到
@property (nonatomic, assign) BOOL isSign;                      // false 不能签到 true能签到
@property (nonatomic, copy) NSString *curMonthSignTotalNum;   //
@property (nonatomic, copy) NSString *shareLink;              //
@property (nonatomic, copy) NSString *shareTitle;             //
@property (nonatomic, copy) NSString *shareContent;           //
@property (nonatomic, retain) NSMutableArray<SignList *> *signList;    // 已签到的日期

- (NSString *) currentDate;

@end
