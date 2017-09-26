//
//  CustomLayout.m
//  WaterFlowClass
//
//  Created by zhiyou on 16-3-1.
//  Copyright (c) 2016年 zhiyou. All rights reserved.
//

#import "CustomLayout.h"

@implementation CustomLayout


-(void)prepareLayout
{
    float middleWidth = self.collectionView.frame.size.width - _sectionInsets.left - _sectionInsets.right;
    //cell 间距
    _itemSpace = (middleWidth - _itemWidth * _column) / (_column - 1);
    
    _heightArray = [[NSMutableArray alloc]initWithCapacity:0];
    _attributesArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i < _column; i++) {
        [_heightArray addObject:@(_sectionInsets.top)];
    }
    
    _itemCounts = [self.collectionView numberOfItemsInSection:0];
    
    for (int i = 0; i<_itemCounts; i++) {
        NSInteger index = [self shortestIndex];
        
        float x = _sectionInsets.left + (_itemWidth + _itemSpace) * index;
        float y = [[_heightArray objectAtIndex:index] floatValue];
        float width = _itemWidth;
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        float height = [_delegate cellHeightWithIndexPath:indexPath];
        
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectMake(x, y, width, height);
        [_attributesArray addObject:attributes];
        
        //获取新高度
        _heightArray[index] = @(y + height + _itemSpace);
    }
}

-(CGSize)collectionViewContentSize{
    NSInteger index = [self longestIndex];
    float height = [_heightArray[index] floatValue] - _itemSpace + _sectionInsets.bottom;
    return CGSizeMake(self.collectionView.frame.size.width, height);
}

//获取和屏幕相交的cell的个数
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    return [_attributesArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes * attributes, NSDictionary *bindings) {
        return CGRectIntersectsRect(attributes.frame, rect);
    }]];
}

-(NSInteger)longestIndex{
    __block NSInteger index;
    __block float height = 0 ;
    [_heightArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        float longHeight = [obj floatValue];
        if (height < longHeight) {
            height = longHeight;
            index = idx;
        }
    }];
    return index;
}

-(NSInteger)shortestIndex{
    __block NSInteger index;
    __block float height = MAXFLOAT;
    [_heightArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        float shorstHeight = [obj floatValue];
        if (height > shorstHeight) {
            height = shorstHeight;
            index = idx;
        }
    }];
    return index;
}

@end
