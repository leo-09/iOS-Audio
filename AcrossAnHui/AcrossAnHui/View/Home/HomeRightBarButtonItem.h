//
//  HomeRightBarButtonItem.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"

/**
 首页的rightBarButtonItem
 */
@interface HomeRightBarButtonItem : CTXBaseView

- (void) setMsgCount:(int)count;

@property (nonatomic, strong) ClickListener clickListener;

@end
