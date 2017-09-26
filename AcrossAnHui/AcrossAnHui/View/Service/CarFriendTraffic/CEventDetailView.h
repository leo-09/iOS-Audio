//
//  CEventDetailView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "CEventDetailCell.h"
#import "EventDetailModel.h"

/**
  事件订阅 (事件的详情)View
 */
@interface CEventDetailView : CTXBaseView<UICollectionViewDelegate, UICollectionViewDataSource> {
    EventDetailModel *currentCityModel;
}

@property (nonatomic, retain) UICollectionView *collectionView;

@property (nonatomic, retain) NSArray<SuperEventDetailModel *> *dataSource;

// 选中的城市和标签
@property (nonatomic, copy) NSString *selectedcity;
@property (nonatomic, retain) NSMutableArray *selectedLabel;

- (void) setDataSource:(NSArray<SuperEventDetailModel *> *)dataSource selectCity:(NSString *)selectCity selectLabels:(NSMutableArray *) defaultLabels;

@end
