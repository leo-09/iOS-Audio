//
//  ServeTool.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTXBaseViewController.h"
#import "ServeModel.h"

@interface ServeTool : NSObject

/**
 Serve跳转逻辑

 @param model ServeModel
 @param vc  当前的ViewController
 @param loginSuccessBlock 登录成功后的回调
 */
+ (void) pushServeWithModel:(ServeModel *)model currentViewController:(CTXBaseViewController *) vc block:(ClickListener) loginSuccessBlock;

// 拨打电话
+ (void) callPhone:(NSString *)phone;

@end
