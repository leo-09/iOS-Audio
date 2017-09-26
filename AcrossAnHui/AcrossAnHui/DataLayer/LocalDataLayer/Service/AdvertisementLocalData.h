//
//  AdvertisementLocalData.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/24.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseLocalData.h"
#import "YYCache.h"
#import "AdvertisementModel.h"

@interface AdvertisementLocalData : CTXBaseLocalData

@property (nonatomic, retain) YYCache *yyCache;

+ (instancetype) sharedInstance;

- (void) saveAdvertisementModel:(AdvertisementModel *)loginModel;
- (void) removeAdvertisementModel;
- (AdvertisementModel *) getAdvertisementModel;

@end
