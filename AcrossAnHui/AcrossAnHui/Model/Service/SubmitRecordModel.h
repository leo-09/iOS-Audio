//
//  SubmitRecordModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

@interface SubmitRecordModel : CTXBaseModel

@property (nonatomic, copy) NSString *carTime;
@property (nonatomic, copy) NSString *carType;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *del;
@property (nonatomic, copy) NSString *recordID;
@property (nonatomic, copy) NSString *mileage;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *userId;

- (NSString *)dataTime;

@end
