//
//  CEditHomeServeView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/8.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "ServeModel.h"

/**
 编辑首页 的服务的View
 */
@interface CEditHomeServeView : CTXBaseView<UICollectionViewDelegate, UICollectionViewDataSource>

// 加一起的数据源
@property (nonatomic, retain) NSMutableArray *dataSource;
// 我的应用
@property (nonatomic, retain) ServeSuperModel *superModel;
// 所有服务
@property (nonatomic, retain) NSArray *serveModels;

@property (nonatomic, retain) UICollectionView *collectionView;

- (void) addServeSuperModel:(ServeSuperModel *)superModel serveModels:(NSArray *)serveModels;

@end
