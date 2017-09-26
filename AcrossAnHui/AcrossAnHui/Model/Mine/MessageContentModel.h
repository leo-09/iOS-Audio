//
//  MessageContentModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 消息中心的 消息内容
 */
@interface MessageContentModel : CTXBaseModel

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *createUser;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *messageID;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *read;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *tip;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *address;

- (NSString *)dataTime;

@end
