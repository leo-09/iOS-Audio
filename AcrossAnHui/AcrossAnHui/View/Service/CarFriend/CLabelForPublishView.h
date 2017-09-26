//
//  CLabelForPublishView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "EventDetailModel.h"

/**
 发表 问小畅、随手拍 和报路况 选择标签View
 */
@interface CLabelForPublishView : CTXBaseView<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, retain) UICollectionView *collectionView;

@property (nonatomic, retain) NSArray<SuperEventDetailModel *> *dataSource;
@property (nonatomic, retain) EventDetailModel *currentModel;           // 选中标签
@property (nonatomic, retain) SuperEventDetailModel *currentSuperModel; // 选中的标签组

- (void) setDataSource:(NSArray<SuperEventDetailModel *> *)dataSource currentModel:(EventDetailModel *)currentModel;

@end
