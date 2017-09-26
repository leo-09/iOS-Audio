//
//  CarFriendTrafficRecordModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"
#import <UIKit/UIKit.h>

/**
 随手拍记录的路况 Model
 */
@interface CarFriendTrafficRecordModel : CTXBaseModel

@property (nonatomic, copy) NSString *addr;
@property (nonatomic, copy) NSString *delFlag;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) int status;           // 1 审核中; 2 已采用; 3 未采用
@property (nonatomic, copy) NSString *scenePhotos;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *resp;       // 小畅回复

@property (nonatomic, assign) CGFloat cellHeight;

// 所有上传的图片
- (NSArray *) photos;

// 状态描述
- (NSString *) statusDesc;
// 状态背景图
- (NSString *) statusImagePath;

@end
