//
//  CarFriendTrafficModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/2.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

static NSString *faultType = @"故障";
static NSString *controlType = @"管制";
static NSString *constructionType = @"施工";
static NSString *traffiJamType = @"拥堵";
static NSString *waterType = @"积水";
static NSString *accidentType = @"事故";
static NSString *otherType = @"其他";
static NSString *policeType = @"警察";
static NSString *signType = @"标志";
static NSString *markingType = @"标线";

/**
  车友路况 的 事件
 */
@interface CarFriendTrafficModel : CTXBaseModel

@property (nonatomic, copy) NSString *delFlag;        // 是否删除
@property (nonatomic, copy) NSString *trafficID;      // id
@property (nonatomic, copy) NSString *line;           //
@property (nonatomic, copy) NSString *lnglat;         // 经纬度的集合,以","分割
@property (nonatomic, copy) NSString *type;           // 如：施工...

- (NSString *) imageName;

@end
