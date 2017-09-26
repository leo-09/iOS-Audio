//
//  CLabelForPublishView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CLabelForPublishView.h"
#import "CEventDetailReusableView.h"
#import "CEventDetailCell.h"
#import "KLCDTextHelper.h"

@implementation CLabelForPublishView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 10;// 纵向的行间距
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];// 设置collectionView的滚动方向
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.bounces = YES;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.alwaysBounceVertical = YES;// 解决数据过少UICollectionView无法滚动的方法
        
        // 注册collectionViewcell:WWCollectionViewCell是我自定义的cell的类型
        [self.collectionView registerClass:[CEventDetailCell class] forCellWithReuseIdentifier:@"CEventDetailCell"];
        // 注册collectionView头部的view，需要注意的是这里的view需要继承自UICollectionReusableView
        [self.collectionView registerClass:[CEventDetailReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        // // 注册collectionView尾部的view
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
        
        [self addSubview:self.collectionView];
        [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    return self;
}

#pragma mark -- UICollectionViewDataSource

// 总共多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

// 每组cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    SuperEventDetailModel *superModel = self.dataSource[section];
    NSArray<EventDetailModel *> *models = superModel.labelList;
    
    return models.count;
}

// cell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CEventDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CEventDetailCell" forIndexPath:indexPath];
    
    SuperEventDetailModel *superModel = self.dataSource[indexPath.section];
    NSArray<EventDetailModel *> *models = superModel.labelList;
    
    cell.model = models[indexPath.row];
    
    return cell;
}

// 头部/底部
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        // 头部
        CEventDetailReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        SuperEventDetailModel *superModel = self.dataSource[indexPath.section];
        view.nameLabel.text = superModel.title;
        [view hideLineView];
        
        if (superModel.title && ![superModel.title isEqualToString:@""]) {
            view.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        } else {
            view.backgroundColor = UIColorFromRGB(0xFFFFFF);
        }
        
        return view;
    } else {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        footerView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);;
        
        return footerView;
    }
}

#pragma mark -- UICollectionViewDelegateFlowLayout

// 头部的尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    SuperEventDetailModel *superModel = self.dataSource[section];
    
    if (superModel.title && ![superModel.title isEqualToString:@""]) {
        return CGSizeMake(CTXScreenWidth, 40);
    } else {
        return CGSizeMake(CTXScreenWidth, 10);
    }
}

// 尾部的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(CTXScreenWidth, 0);
}

// 每个cell的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // cel对应的model
    SuperEventDetailModel *superModel = self.dataSource[indexPath.section];
    NSArray<EventDetailModel *> *models = superModel.labelList;
    EventDetailModel *model = models[indexPath.row];
    
    CGFloat width = [KLCDTextHelper WidthForText:model.name withFontSize:CTXTextFont withTextHeight:50] + 30;
    return CGSizeMake(width, 30);
}

// 设置单元格间的横向间距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

// section的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(12, 12, 12, 12);// 边距12
}

#pragma mark -- UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 获取点击的model
    _currentSuperModel = self.dataSource[indexPath.section];
    NSArray<EventDetailModel *> *models = _currentSuperModel.labelList;
    EventDetailModel *model = models[indexPath.row];
    
    if (_currentModel) {
        _currentModel.isSelected = !_currentModel.isSelected;
    }
    
    _currentModel = model;
    _currentModel.isSelected = !_currentModel.isSelected;
    
    [self.collectionView reloadData];
}

#pragma mark - getter/setter

- (void) setDataSource:(NSArray<SuperEventDetailModel *> *)dataSource currentModel:(EventDetailModel *)currentModel {
    if (!dataSource) {
        return;
    }
    
    _dataSource = dataSource;
    
    if (currentModel) {
        _currentModel = currentModel;
    }
    
    [self.collectionView reloadData];
}

@end
