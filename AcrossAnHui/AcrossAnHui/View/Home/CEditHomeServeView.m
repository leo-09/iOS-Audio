//
//  CEditHomeServeView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/8.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CEditHomeServeView.h"
#import "CServiceCollectionViewCell.h"
#import "CServiceCollectionReusableView.h"

@interface CEditHomeServeView() {
    NSMutableArray *allServeArray;
}

@end

@implementation CEditHomeServeView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        
        [self addCollectionView];
    }
    
    return self;
}

// collectionView
- (void) addCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 10;
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];// 设置collectionView的滚动方向
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // 注册collectionViewcell:WWCollectionViewCell是我自定义的cell的类型
    [self.collectionView registerClass:[CServiceCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    // 注册collectionView头部的view，需要注意的是这里的view需要继承自UICollectionReusableView
    [self.collectionView registerClass:[CServiceCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    // // 注册collectionView尾部的view
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    [self addSubview:self.collectionView];
}

#pragma mark -- UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ServeSuperModel *superModel = self.dataSource[indexPath.section];
    ServeModel *model = superModel.serveArray[indexPath.row];
    
    if (model.selectStatus == CAN_DELETE_STATUS) {// 可删除
        // 删除‘我的应用’的服务
        [_superModel.serveArray removeObject:model];
        // 更新所有服务中，该服务的selectStatus
        for (ServeModel *allServeModel in allServeArray) {
            if ([allServeModel.serveID isEqualToString:model.serveID]) {
                allServeModel.selectStatus = CAN_ADD_STATUS;
                break;
            }
        }
    } else if (model.selectStatus == CAN_ADD_STATUS) {// 可添加
        if (_superModel.serveArray.count >= 7) {
            [self showTextHubWithContent:@"亲，您的首页已满"];
        } else {
            model.selectStatus = SELECTED_STATUS;
            ServeModel *copyModel = [model copy];
            copyModel.selectStatus = CAN_DELETE_STATUS;
            [_superModel.serveArray addObject:copyModel];
        }
    }
    
    [self.collectionView reloadData];
}

#pragma mark -- UICollectionViewDataSource

// 总共多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

// 每组cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    ServeSuperModel *superModel = self.dataSource[section];
    return superModel.serveArray.count;
}

// cell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CServiceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    ServeSuperModel *superModel = self.dataSource[indexPath.section];
    ServeModel *model = superModel.serveArray[indexPath.row];
    cell.serveModel = model;
    cell.isShowEdit = YES;
    
    return cell;
}

// 头部/底部
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        // 头部
        CServiceCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        ServeSuperModel *superModel = self.dataSource[indexPath.section];
        view.imageView.image = [UIImage imageNamed:superModel.imageKey];
        view.nameLabel.text = superModel.nameKey;
        
        return view;
    } else {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        footerView.backgroundColor = CTXColor(244, 244, 244);
        if (indexPath.section == 0) {
            if (_superModel.serveArray.count == 0) {
                CGRect frame = CGRectMake(0, 0, footerView.frame.size.width, 30);
                UIView *view = [[UIView alloc] initWithFrame:frame];
                view.backgroundColor = [UIColor whiteColor];
                [footerView addSubview:view];
            } else {
                [footerView removeAllSubviews];
            }
        }
        
        return footerView;
    }
}

#pragma mark -- UICollectionViewDelegateFlowLayout

// 每个cell的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CTXScreenWidth / 4, 90 + 15);
}

// 头部的尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(CTXScreenWidth, 50);
}

// 尾部的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        if (_superModel.serveArray.count == 0) {
            return CGSizeMake(CTXScreenWidth, 30 + 15);
        }
    }
    
    return CGSizeMake(CTXScreenWidth, 15);
}

// section的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(-5.0, 0, 0, 0);
}

- (void) addServeSuperModel:(ServeSuperModel *)superModel serveModels:(NSArray *)serveModels {
    _superModel = superModel;
    _serveModels = serveModels;
    
    if (!_dataSource) {
        _dataSource = [[NSMutableArray array] init];
    }
    
    // 取出最新的所有的服务集合
    allServeArray = [[NSMutableArray alloc] init];
    for (ServeSuperModel *superModel in _serveModels) {
        [allServeArray addObjectsFromArray:superModel.serveArray];
    }
    
    for (ServeModel *allServeModel in allServeArray) {
        // 每个服务 默认可添加
        allServeModel.selectStatus = CAN_ADD_STATUS;
        
        for (int i = 0; i < _superModel.serveArray.count; i++) {
            ServeModel *serveModel = _superModel.serveArray[i];
            
            if ([serveModel.serveID isEqualToString:allServeModel.serveID]) {
                // 更新最新的服务
                [_superModel.serveArray replaceObjectAtIndex:i withObject:[allServeModel copy]];
                // superModel即“我的额 应用”，都是可以删除的
                _superModel.serveArray[i].selectStatus = CAN_DELETE_STATUS;
                
                // 所有的服务与定制服务一样，则表示已选中
                allServeModel.selectStatus = SELECTED_STATUS;
            }
        }
    }
    
    [_dataSource addObject:_superModel];
    [_dataSource addObjectsFromArray:_serveModels];
    
    [self.collectionView reloadData];
}

@end
