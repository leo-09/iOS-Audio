//
//  UseInfoLocalData.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseLocalData.h"

@interface UseInfoLocalData : CTXBaseLocalData

+ (instancetype) sharedInstance;

- (BOOL) isFirstUseOrUpdata;

// 极光的registrationID
- (void) saveRegistrationID:(NSString *)registrationID;
- (NSString *)getRegistrationID;
// 标志绑定成功
- (void) setJPushBindSuccess;
// 更新应用后，重置
- (void) updateJPushBindSuccess;
// 获取绑定释放成功
- (BOOL) isJPushBindSuccess;

@end
