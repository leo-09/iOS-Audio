//
//  NearbyStationView.h
//  AcrossAnHui
//
//  Created by ztd on 17/6/8.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarInspectStationModel.h"
@interface NearbyStationView : UIView{
     UILabel * currentAddressLab;
    void (^stationListener)(CarInspectStationModel * model);
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *stationArray;

-(void)refreshDataArr:(NSMutableArray *)stationArry;
- (void) setStationListener:(void (^)(CarInspectStationModel * model))listener;

@end
