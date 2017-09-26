//
//  AddressForPublishViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "CarFriendMAPointAnnotation.h"

/**
 发表 问小畅、随手拍 和报路况 选择当前位置
 */
@interface AddressForPublishViewController : CTXBaseViewController<AMapSearchDelegate,MAMapViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) CarFriendMAPointAnnotation * selectAnno;  // 选中的点

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) MAMapView * mapView;
@property (nonatomic, retain) UIImageView *iv;

@property (nonatomic, retain) AMapSearchAPI *aMapSearchAPI;

@property (nonatomic, assign) int currentPage;

@end
