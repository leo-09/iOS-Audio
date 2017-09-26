//
//  HighTraficModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/4.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"
#import <UIKit/UIKit.h>

/**
 高速路况 Model
 */
@interface HighTraficModel : CTXBaseModel

@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *priorityNum;
@property (nonatomic, copy) NSString *type;

// 该Model对应的Cell高度
@property (nonatomic, assign) CGFloat cellHeight;

- (NSString *) time;

@end
