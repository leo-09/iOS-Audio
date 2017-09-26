
//
//  CEventDetailView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CEventDetailView.h"
#import "CEventDetailReusableView.h"
#import "KLCDTextHelper.h"

@implementation CEventDetailView

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
    layout.minimumLineSpacing = 10;// 纵向的行间距
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

#pragma mark -- UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 获取点击的model
    SuperEventDetailModel *superModel = self.dataSource[indexPath.section];
    EventDetailModel *model = superModel.labelList[indexPath.row];
    
    if (model.isCity) {
        if (currentCityModel) {
            currentCityModel.isSelected = !currentCityModel.isSelected;
        }
        currentCityModel = model;
        currentCityModel.isSelected = !currentCityModel.isSelected;
        
        // 记录当前选择的城市
        self.selectedcity = currentCityModel.name;
        
        // 更新城市的section
        NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:0];
        [self.collectionView reloadSections:set];
    } else {
        model.isSelected = !model.isSelected;
        
        // 记录当前选择的标签
        if (!self.selectedLabel) {
            self.selectedLabel = [[NSMutableArray alloc] init];
        } else {
            [self.selectedLabel removeAllObjects];
        }
        for (EventDetailModel *item in superModel.labelList) {
            if (item.isSelected) {
                [self.selectedLabel addObject:item.name];
            }
        }
        
        [self.collectionView reloadItemsAtIndexPaths:@[ indexPath ]];
    }
}

#pragma mark -- UICollectionViewDataSource

// 总共多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

// 每组cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    SuperEventDetailModel *superModel = self.dataSource[section];
    return superModel.labelList.count;
}

// cell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CEventDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CEventDetailCell" forIndexPath:indexPath];
    
    SuperEventDetailModel *superModel = self.dataSource[indexPath.section];
    cell.model = superModel.labelList[indexPath.row];
    
    return cell;
}

// 头部/底部
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        // 头部
        CEventDetailReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        SuperEventDetailModel *superModel = self.dataSource[indexPath.section];
        view.nameLabel.text = superModel.title;
        
        return view;
    } else {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor whiteColor];
        
        [footerView removeAllSubviews];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"选择城市和标签可以第一时间收到事件消息提醒！";
        label.font = [UIFont systemFontOfSize:14.0];
        label.numberOfLines = 0;
        label.textColor = UIColorFromRGB(CTXBaseFontColor);
        [footerView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.right.equalTo(-12);
            make.centerY.equalTo(footerView.centerY);
        }];
        
        return footerView;
    }
}

#pragma mark -- UICollectionViewDelegateFlowLayout

// 每个cell的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGFloat width = (CTXScreenWidth - 12 * 5) / 4;// 城市间隔12，左右边距12，一行4个cell
        return CGSizeMake(width, width / 2);// 宽高比 2:1
    } else {
        SuperEventDetailModel *superModel = self.dataSource[indexPath.section];
        EventDetailModel *model = superModel.labelList[indexPath.row];
        
        CGFloat width = [KLCDTextHelper WidthForText:model.name withFontSize:CTXTextFont withTextHeight:50] + 30;
        return CGSizeMake(width, 30);
    }
}

// 头部的尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(CTXScreenWidth, 60);
}

// 尾部的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return CGSizeMake(CTXScreenWidth, 100);
    } else {
        return CGSizeMake(CTXScreenWidth, 0);
    }
}

// 设置单元格间的横向间距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 12;// 城市间隔12，左右边距12
    } else {
        return 20;// 标签间隔20，左右边距12
    }
}

// section的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 12, 2, 12);// 左右边距12
}

#pragma mark - getter/setter

- (void) setDataSource:(NSArray<SuperEventDetailModel *> *)dataSource selectCity:(NSString *)selectCity selectLabels:(NSMutableArray *) selectLabels {
    if (!dataSource) {
        return;
    }
    
    // 所有的标签/城市
    _dataSource = dataSource;
    
    // 标记已选择的标签
    if (selectCity && ![selectCity isEqualToString:@""]) {
        self.selectedcity = selectCity;
        
        for (int i = 0; i < _dataSource.count; i++) {
            SuperEventDetailModel *superModel = _dataSource[i];
            if (i == 0) {// 比较城市
                for (EventDetailModel *model in superModel.labelList) {
                    if ([self.selectedcity containsString:model.name]) {
                        model.isSelected = YES;
                        currentCityModel = model;
                        break;
                    }
                }
            }
        }
        
    }
    
    // 标记已选择的城市
    if (selectLabels && selectLabels.count > 0) {
        self.selectedLabel = selectLabels;
        
        for (int i = 0; i < _dataSource.count; i++) {
            SuperEventDetailModel *superModel = _dataSource[i];
            if (i == 1) {// 比较标签
                for (EventDetailModel *model in superModel.labelList) {
                    for (NSString *selectLabel in self.selectedLabel) {
                        if ([model.name isEqualToString:selectLabel]) {
                            model.isSelected = YES;
                        }
                    }
                }
            }
        }
        
    }
    
    [self.collectionView reloadData];
}

@end
