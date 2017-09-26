//
//  CarFriendHeadImageModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/2.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 车友记（问小畅、随手拍）的点赞的好友
 */
@interface CarFriendHeadImageModel : CTXBaseModel

@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *headImage;
@property (nonatomic, copy) NSString *createTime;

@end
