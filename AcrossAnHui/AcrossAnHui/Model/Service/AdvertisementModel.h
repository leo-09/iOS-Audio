//
//  AdvertisementModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 广告(轮播图)model
 */
@interface AdvertisementModel : CTXBaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *img;    // 轮播图地址
@property (nonatomic, copy) NSString *url;    // 广告详情url
@property (nonatomic, copy) NSString *desc;

- (NSString *) getActualURLWithToken:(NSString *)token userID:(NSString *)userID;

@end
