//
//  MessageCenterModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 消息中心的 列表
 */
@interface MessageCenterModel : CTXBaseModel

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *messageID;
@property (nonatomic, copy) NSString *read;       // 1:未读；2:已读
@property (nonatomic, copy) NSString *tip;

- (NSString *)dataTime;

@end
