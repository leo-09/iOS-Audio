//
//  CServiceView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CServiceView.h"
#import "CServiceCollectionViewCell.h"
#import "CServiceCollectionReusableView.h"

@implementation CServiceView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        
        [self addCollectionView];
        [self addCycleScrollView];
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
    // 设置轮播图位置
    self.collectionView.contentInset = UIEdgeInsetsMake(((CTXScreenWidth / 9) * 4), 0, 0, 0);
}

// cycleScrollView
- (void) addCycleScrollView {
    // 网络加载 --- 创建带标题的图片轮播器
    CGRect frame = CGRectMake(0, -((CTXScreenWidth / 9) * 4), CTXScreenWidth, (CTXScreenWidth / 9) * 4);
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:[UIImage imageNamed:@"banner_b"]];
    self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    self.cycleScrollView.pageControlDotSize = CGSizeMake(6, 6);
    self.cycleScrollView.currentPageDotColor = UIColorFromRGB(CTXThemeColor);
    self.cycleScrollView.pageDotColor = UIColorFromRGB(CTXBackGroundColor);
    self.cycleScrollView.autoScrollTimeInterval = 5.0f;
    self.cycleScrollView.backgroundColor = CTXColor(244, 244, 244);
    
    [self.collectionView addSubview:self.cycleScrollView];
}

#pragma mark -- UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectCellListener) {
        self.selectCellListener((int)indexPath.section, (int)indexPath.row);
    }
}

// 已经结束拖拽，手指刚离开view的那一刻
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < -200) {
        
        // imageURLStringsGroup为空时，添加下拉刷新功能
        if (!self.cycleScrollView.imageURLStringsGroup) {
            if (self.refreshAdvDataListener) {
                self.refreshAdvDataListener(YES);
            }
        }
    }
}

#pragma mark -- UICollectionViewDataSource

// 总共多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.serveModels.count;
}

// 每组cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    ServeSuperModel *superModel = self.serveModels[section];
    return superModel.serveArray.count;
}

// cell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CServiceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    ServeSuperModel *superModel = self.serveModels[indexPath.section];
    ServeModel *model = superModel.serveArray[indexPath.row];
    cell.serveModel = model;
    
    return cell;
}

// 头部/底部
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        // 头部
        CServiceCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];

        ServeSuperModel *superModel = self.serveModels[indexPath.section];
        view.imageView.image = [UIImage imageNamed:superModel.imageKey];
        view.nameLabel.text = superModel.nameKey;
        
        return view;
    } else {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        footerView.backgroundColor = CTXColor(244, 244, 244);
        return footerView;
    }
}

#pragma mark -- UICollectionViewDelegateFlowLayout

// 每个cell的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CTXScreenWidth / 4, 90+15);
}

// 头部的尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(CTXScreenWidth, 50);
}

// 尾部的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(CTXScreenWidth, 15);
}

// section的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(-5.0, 0, 0, 0);
}

#pragma mark - SDCycleScrollViewDelegate

// 点击图片回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.clickADVListener) {
        self.clickADVListener((int)index);
    }
}

#pragma mark - getter/setter

- (void) setImagePaths:(NSArray *)imagePaths {
    if (imagePaths) {
        self.cycleScrollView.imageURLStringsGroup = imagePaths;
    }
}

- (void) setServeModels:(NSArray<ServeModel *> *)serveModels {
    _serveModels = serveModels;
    [self.collectionView reloadData];
}

@end
