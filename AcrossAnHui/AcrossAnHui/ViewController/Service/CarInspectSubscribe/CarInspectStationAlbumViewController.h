//
//  CarInspectStationAlbumViewController.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/10.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTXBaseViewController.h"

/**
 车检站相册
 */
@interface CarInspectStationAlbumViewController : CTXBaseViewController

@property (nonatomic,retain)NSMutableArray *stationImageArray;
@property(nonatomic,strong)NSString * stationid;

@end
