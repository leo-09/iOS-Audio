//
//  CEventDetailCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventDetailModel.h"

@interface CEventDetailCell : UICollectionViewCell

@property (nonatomic, retain) EventDetailModel *model;

@property (nonatomic, retain) UILabel *label;

@end
