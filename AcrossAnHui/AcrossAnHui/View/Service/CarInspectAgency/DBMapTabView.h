//
//  DBMapTabView.h
//  AcrossAnHui
//
//  Created by ztd on 17/5/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapView.h>
#import <AMapSearchKit/AMapSearchKit.h>

@protocol PlaceAroundTableViewDeleagate <NSObject>

- (void)didTableViewSelectedChanged:(AMapPOI *)selectedPoi;

- (void)didLoadMorePOIButtonTapped;

- (void)didPositionCellTapped;

@end


@interface DBMapTabView : UIView <UITableViewDataSource, UITableViewDelegate, AMapSearchDelegate>

@property (nonatomic, weak) id<PlaceAroundTableViewDeleagate> delegate;

@property (nonatomic, copy) NSString *currentAddress;

- (instancetype)initWithFrame:(CGRect)frame;

- (AMapPOI *)selectedTableViewCellPoi;
-(void)getSearchdata:(NSMutableArray *)dataArr;

@end
