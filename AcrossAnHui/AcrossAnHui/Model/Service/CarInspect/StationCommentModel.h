//
//  StationCommentModel.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/10.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTXBaseModel.h"

@interface StationCommentModel : CTXBaseModel

@property (nonatomic,copy)NSString *submitUSerid;//提交人id
@property (nonatomic,copy)NSString *assessContent;//评价内容
@property (nonatomic,copy)NSString *assessid;//评价id
@property (nonatomic,copy)NSString *submitDate;//评价日期
@property (nonatomic,copy)NSString *realname;//真实姓名
@property (nonatomic,copy)NSString *avatar;//评价人头像
@property (nonatomic,strong)NSArray *evalImgList;// 评价图片数组
@property (nonatomic,strong)NSString *assessStar;//评价星数

@end
