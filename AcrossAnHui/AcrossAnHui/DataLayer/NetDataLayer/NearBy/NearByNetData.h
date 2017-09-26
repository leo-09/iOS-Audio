//
//  NearByNetData.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/31.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseNetDataRequest.h"

@interface NearByNetData : CTXBaseNetDataRequest

/**
 查询快处中心

 @param city city
 @param province province
 @param tag tag
 */
- (void) getAllFastDealInfoWithCity:(NSString *)city province:(NSString *)province tag:(NSString *)tag;

/**
 查询违章处理

 @param city city
 @param province province
 @param tag tag
 */
- (void) getAllIllegalDisposalSiteInfoWithCity:(NSString *)city province:(NSString *)province tag:(NSString *)tag;

@end
