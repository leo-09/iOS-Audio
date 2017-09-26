//
//  TrafficEventModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/4.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 车友路况的 事件
 */
@interface TrafficEventModel : CTXBaseModel

@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *eventID;
@property (nonatomic, copy) NSString *scenePhotos;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *useful;
@property (nonatomic, copy) NSString *useless;

/**
 解析图片路径

 @return 图片路径集合
 */
- (NSArray *) sceneImagePaths;

@end
