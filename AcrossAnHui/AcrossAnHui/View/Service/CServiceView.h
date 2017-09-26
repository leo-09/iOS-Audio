//
//  CServiceView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "SDCycleScrollView.h"
#import "ServeModel.h"

typedef void (^SelectCollectionCellListener)(int section, int index);

/**
 “服务”View
 */
@interface CServiceView : CTXBaseView<UICollectionViewDelegate, UICollectionViewDataSource, SDCycleScrollViewDelegate>

@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) SDCycleScrollView *cycleScrollView;

@property (nonatomic, retain) NSArray *serveModels;

@property (nonatomic, strong) SelectCollectionCellListener selectCellListener;
@property (nonatomic, strong) SelectCellListener clickADVListener;
@property (nonatomic, strong) RefreshDataListener refreshAdvDataListener;

- (void) setImagePaths:(NSArray *)imagePaths;

@end
