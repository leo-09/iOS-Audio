//
//  StationAlbumModel.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/10.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

@interface StationAlbumModel : CTXBaseModel

@property (nonatomic,copy)NSString *albumid;//主键id;
@property (nonatomic,copy)NSString *assessid;//评价id;
@property (nonatomic,copy)NSString *picAddr;//图片访问的URL;
@property (nonatomic,copy)NSString *stationid;//车检站id;

@end
