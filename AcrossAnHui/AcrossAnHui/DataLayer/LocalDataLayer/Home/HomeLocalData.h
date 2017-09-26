//
//  HomeLocalData.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseLocalData.h"
#import "YYCache.h"
#import "AMapLocationModel.h"

@interface HomeLocalData : CTXBaseLocalData

@property (nonatomic, retain) YYCache *yyCache;

+ (instancetype) sharedInstance;

- (void) saveAMapLocationModel:(AMapLocationModel *)loginModel;
- (AMapLocationModel *) getAMapLocationModel;

@end
