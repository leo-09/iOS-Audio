//
//  CarFriendUserCommontModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"
#import <UIKit/UIKit.h>

/**
 车友记（问小畅、随手拍）的评论
 */
@interface CarFriendUserCommentModel : CTXBaseModel

@property (nonatomic, copy) NSString *commontID;
@property (nonatomic, copy) NSString *cardID;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) BOOL isDel;
@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *headImage;
@property (nonatomic, copy) NSString *commentTime;
@property (nonatomic, copy) NSString *contents;
@property (nonatomic, assign) BOOL isLaud;          // 是否点赞
@property (nonatomic, copy) NSString *laudCount;    // 点赞数量
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userPhoto;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *lastUdpateTime;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *carName;
@property (nonatomic, copy) NSString *nikeName;

@property (nonatomic, assign) CGFloat cellHeight;

@end
