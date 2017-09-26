//
//  CarInspectStationHeadView.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarInspectStationModel.h"

@interface CarInspectStationHeadView : UIView

typedef void (^DBHeaderViewBlock)(CarInspectStationModel *stationList);

@property (nonatomic,strong)CarInspectStationModel *stationList;

@property (nonatomic,strong)DBHeaderViewBlock block;

- (void)setBlock:(DBHeaderViewBlock)block;

@end
