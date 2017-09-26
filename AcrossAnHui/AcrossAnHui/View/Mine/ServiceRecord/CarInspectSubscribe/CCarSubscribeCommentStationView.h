//
//  CCarSubscribeCommentStationView.h
//  AcrossAnHui
//
//  Created by ztd on 2017/8/10.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "CarInspectStationModel.h"

@interface CCarSubscribeCommentStationView : CTXBaseView
typedef void (^DBHeaderViewBlock)(CarInspectStationModel *stationList);

@property (nonatomic,strong)CarInspectStationModel *stationList;

@property (nonatomic,strong)DBHeaderViewBlock block;

- (void)setBlock:(DBHeaderViewBlock)block;
@end
