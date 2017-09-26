//
//  HelpCenterModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"
#import <UIKit/UIKit.h>

@interface HelpCenterModel : CTXBaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *delFlag;

// 该Model对应的Cell高度
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) BOOL selected;

@end
