//
//  CarFriendCardModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"
#import <UIKit/UIKit.h>
#import "CarFriendUserCommentModel.h"
#import "CarFriendHeadImageModel.h"

/**
 车友记（问小畅、随手拍）的帖子
 */
@interface CarFriendCardModel : CTXBaseModel

// 车友记（问小畅、随手拍）的公告和帖子 共有的部分
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *carName;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *classifyID;
@property (nonatomic, copy) NSString *commandCount;
@property (nonatomic, copy) NSString *contents;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *cardID;
@property (nonatomic, copy) NSString *lastUdpateTime;
@property (nonatomic, copy) NSString *laudCount;                // 点赞数量
@property (nonatomic, copy) NSString *nikeName;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *postTime;
@property (nonatomic, copy) NSString *replyCount;               // 对小畅说点赞的数量
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *tagID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userPhoto;
@property (nonatomic, retain) NSMutableArray<CarFriendUserCommentModel *> *imageList;
@property (nonatomic, assign) BOOL isBulletin;
@property (nonatomic, assign) BOOL isDel;
@property (nonatomic, assign) BOOL isRecommend;                 // 是否推荐
@property (nonatomic, assign) BOOL isReply;

// 车友记（问小畅、随手拍）的帖子独有的部分
@property (nonatomic, retain) NSMutableArray<CarFriendHeadImageModel *> *headImageList;    // 点赞的头像
@property (nonatomic, assign) BOOL isLaud;                          // 是否点赞
@property (nonatomic, assign) BOOL isReplyLaud;                     // 是否对小畅说点赞
@property (nonatomic, copy) NSString *classifyName;
@property (nonatomic, copy) NSString *replyContents;
@property (nonatomic, copy) NSString *replyUserID;
@property (nonatomic, copy) NSString *replyUserName;
@property (nonatomic, copy) NSString *tagName;

// 该Model对应的Cell高度
@property (nonatomic, assign) CGFloat cellHeight;
// 话题内容 内容Cell高度
@property (nonatomic, assign) CGFloat cardCellHeight;
// 话题内容 小畅说Cell高度
@property (nonatomic, assign) CGFloat changCellHeight;

- (instancetype) ctxCopy;

@end

