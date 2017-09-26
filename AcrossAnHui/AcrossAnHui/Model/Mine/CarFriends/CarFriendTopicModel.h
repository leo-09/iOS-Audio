//
//  CarFriendTopicModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"
#import <UIKit/UIKit.h>
#import "CarFriendUserCommentModel.h"

/**
 随手拍记录的话题 Model
 */
@interface CarFriendTopicModel : CTXBaseModel

@property (nonatomic, copy) NSString *topicID;
@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *carName;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *classifyID;
@property (nonatomic, copy) NSString *classifyName;

@property (nonatomic, copy) NSString *contents;
@property (nonatomic, retain) NSArray<CarFriendUserCommentModel *> *imageList;
@property (nonatomic, copy) NSString *commandCount;
@property (nonatomic, copy) NSString *laudCount;
@property (nonatomic, copy) NSString *replyCount;
@property (nonatomic, assign) BOOL isLaud;
@property (nonatomic, assign) BOOL isBulletin;
@property (nonatomic, assign) BOOL isDel;
@property (nonatomic, assign) BOOL isRecommend;             // 是否推荐
@property (nonatomic, assign) BOOL isReply;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_photo;
@property (nonatomic, copy) NSString *nike_name;
@property (nonatomic, copy) NSString *post_time;
@property (nonatomic, copy) NSString *tag_id;
@property (nonatomic, copy) NSString *tag_name;
@property (nonatomic, copy) NSString *status;             // 0:审核中 1:审核通过; 审核失败

// 该Model对应的Cell高度
@property (nonatomic, assign) CGFloat cellHeight;

@end
