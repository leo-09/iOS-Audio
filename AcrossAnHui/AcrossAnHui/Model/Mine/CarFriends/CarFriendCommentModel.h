//
//  CarFriendCommentModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"
#import <UIKit/UIKit.h>

@interface CmsCard : CTXBaseModel

@property (nonatomic, copy) NSString *cmsCardID;
@property (nonatomic, copy) NSString *contents;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *carName;
@property (nonatomic, copy) NSString *classifyID;
@property (nonatomic, copy) NSString *classifyName;
@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) BOOL isBulletin;
@property (nonatomic, assign) BOOL isDel;
@property (nonatomic, assign) BOOL isRecommend;
@property (nonatomic, assign) BOOL isReply;

@property (nonatomic, copy) NSString *laudCount;
@property (nonatomic, copy) NSString *commandCount;

@property (nonatomic, copy) NSString *lastUdpateTime;
@property (nonatomic, copy) NSString *postTime;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *note;

@property (nonatomic, copy) NSString *tag_id;
@property (nonatomic, copy) NSString *user_id;

@end

/**
 随手拍记录的评论、收藏 Model
 */
@interface CarFriendCommentModel : CTXBaseModel

@property (nonatomic, copy) NSString *commentID;
@property (nonatomic, copy) NSString *cardID;
@property (nonatomic, copy) NSString *contents;

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *commentTime;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, assign) BOOL isLaud;
@property (nonatomic, assign) BOOL isDel;

@property (nonatomic, retain) CmsCard *cmsCard;

// 该Model对应的Cell高度
@property (nonatomic, assign) CGFloat cellHeight;

@end
