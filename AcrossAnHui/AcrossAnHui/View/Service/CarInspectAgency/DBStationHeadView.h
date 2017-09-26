//
//  DBStationHeadView.h
//  AcrossAnHui
//
//  Created by zjq on 2017/6/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarInspectStationModel.h"

typedef void (^DBHeaderViewBlock)(CarInspectStationModel *stationList);

@interface DBStationHeadView : UIView

@property (nonatomic,strong)CarInspectStationModel *stationList;
@property (nonatomic,strong)DBHeaderViewBlock block;

- (void)setBlock:(DBHeaderViewBlock)block;

@end
