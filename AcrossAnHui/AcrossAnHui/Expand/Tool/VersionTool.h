//
//  VersionTool.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionTool : NSObject

+ (instancetype) sharedInstance;

/**
 当前版本号

 @return 返回当前版本号
 */
- (NSString *) getVersion;

/**
 当前版本号 和 网络最新版本号 比较

 @param netVersion 网络最新版本号
 @return 返回是否是最新版本
 */
- (BOOL) isLastVersionWithNetVersion:(NSString *)netVersion;

/**
 当前版本号 和 本地记录的版本号 比较

 @param localVersion 本地记录的版本号
 @return 返回是否是最新版本
 */
- (BOOL) isLargeVersionWithLocalVersion:(NSString *)localVersion;

@end
