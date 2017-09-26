//
//  EventDetailModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 事件订阅（还有随手拍的标签）的model
 */
@interface EventDetailModel : CTXBaseModel

@property (nonatomic, assign) BOOL isCity;
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, copy) NSString *eventID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) NSString *sort;   // 随手拍的标签的排序

@end

@interface SuperEventDetailModel : CTXBaseModel

@property (nonatomic, copy) NSString *superID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSArray<EventDetailModel *> *labelList;

@property (nonatomic, assign) BOOL isCity;

@end
