//
//  CarFriendGoodResultModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/3.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"
#import "CarFriendHeadImageModel.h"

/**
 点赞结构的返回值
 */
@interface CarFriendGoodResultModel : CTXBaseModel

@property (nonatomic, assign) BOOL isLaud;                          // 是否点赞
@property (nonatomic, copy) NSString *laudCount;                  // 点赞数量
@property (nonatomic, retain) NSMutableArray<CarFriendHeadImageModel *> *data;          // 点赞成功后返回的头像

@property (nonatomic, copy) NSString *is_recommend;
@property (nonatomic, copy) NSString *laudType;
@property (nonatomic, copy) NSString *operateId;

@end
