//
//  IllegalDisposalSiteInfoModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/31.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 违章查询点
 */
@interface IllegalDisposalSiteInfoModel : CTXBaseModel

@property (nonatomic, copy) NSString *addr;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *delFlag;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, copy) NSString *IllegalDisposalSiteInfoID;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *worktimeAM;
@property (nonatomic, copy) NSString *worktimePM;

@end
