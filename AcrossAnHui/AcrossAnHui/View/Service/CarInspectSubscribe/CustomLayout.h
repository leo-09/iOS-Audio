//
//  CustomLayout.h
//  WaterFlowClass
//
//  Created by zhiyou on 16-3-1.
//  Copyright (c) 2016年 zhiyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLayout : UICollectionViewLayout

@property(nonatomic,assign)NSInteger column;//列数
@property(nonatomic,assign)float itemWidth;//宽度
@property(nonatomic,assign)UIEdgeInsets sectionInsets;//边界
@property(nonatomic,assign)NSInteger itemCounts;//个数
@property(nonatomic,assign)float itemSpace;//间隔
@property(nonatomic,retain)NSMutableArray *heightArray;
@property(nonatomic,retain)NSMutableArray *attributesArray;
@property(nonatomic,assign)id delegate;

@end

@protocol CustomLayoutDelegate <NSObject>

-(float)cellHeightWithIndexPath:(NSIndexPath *)indexPath;

@end
