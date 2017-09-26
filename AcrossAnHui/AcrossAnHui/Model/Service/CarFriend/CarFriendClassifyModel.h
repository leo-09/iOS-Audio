//
//  CarFriendClassifyModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 车友记（问小畅、随手拍）的分类信息
 */
@interface CarFriendClassifyModel : CTXBaseModel

@property (nonatomic, copy) NSString *code;               // 编码
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *classifyID;         // 分类id
@property (nonatomic, copy) NSString *image;              // 图片
@property (nonatomic, copy) NSString *isDel;
@property (nonatomic, copy) NSString *lastUdpateTime;
@property (nonatomic, copy) NSString *name;               // 名称
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *sort;               // 排序

@end
