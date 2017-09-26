//
//  MessageCenterInfoViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"

typedef enum {
    Message_eventContent = 1,
    Message_systemContent = 2,
    Message_eventNotice = 3,
    Message_systemNotice = 4
} MessageCenterInfoTag;

/**
 消息内容
 */
@interface MessageCenterInfoViewController : CTXBaseViewController

@property (nonatomic, assign) MessageCenterInfoTag tag; // 1 事件内容 2.系统内容 3事件通知 4 系统通知
@property (nonatomic, copy) NSString *messageID;

@property (nonatomic, retain) NSDictionary *pushMsgDict;// 推送来的消息内容

@property (nonatomic, assign) BOOL isUnreadMessage;// 未读的消息，读完需要发送通知ReadMessageNotificationName

@end
