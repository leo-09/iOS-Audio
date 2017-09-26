//
//  carInspectStationCollectionView.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/10.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "carInspectStationCollectionView.h"
#import "CarInspectImageCollectionViewCell.h"

@interface carInspectStationCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@end

@implementation carInspectStationCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
        self.backgroundColor = [UIColor whiteColor];
        [self registerClass:[CarInspectImageCollectionViewCell class] forCellWithReuseIdentifier:@"KLImageViewCell"];
    }
    return self;
}

- (void)setImagArray:(NSArray *)imagArray{
    if (_imagArray!=imagArray) {
        _imagArray = imagArray;
    }
    [self reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imagArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CarInspectImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KLImageViewCell" forIndexPath:indexPath];
    cell.imagUrl = [self.imagArray[indexPath.row] objectForKey:@"picAddr"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((CTXScreenWidth -32.5-25)/3,80);
}

@end
