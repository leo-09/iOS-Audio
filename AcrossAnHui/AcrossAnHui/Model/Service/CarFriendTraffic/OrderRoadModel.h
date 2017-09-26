//
//  OrderRoadModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/5.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"
#import <UIKit/UIKit.h>

/**
 定制路况Model
 */
@interface OrderRoadModel : CTXBaseModel

@property (nonatomic, copy) NSString *destination;
@property (nonatomic, copy) NSString *destinationAddr;
@property (nonatomic, copy) NSString *orderRoadID;
@property (nonatomic, copy) NSString *origin;
@property (nonatomic, copy) NSString *originAddr;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *week;

// 该Model对应的Cell高度
@property (nonatomic, assign) CGFloat cellHeight;

- (NSArray *) weekArray;
- (NSArray *) originArray;
- (NSArray *) destinationArray;
- (NSString *) weekDesc;

@end
