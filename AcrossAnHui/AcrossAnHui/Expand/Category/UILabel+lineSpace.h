//
//  UILabel+lineSpace.h
//  DrawLine
//
//  Created by ctx2016 on 17/4/28.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (lineSpace)

// 原作者的计算方法
- (CGSize)getLabelHeightWithLineSpace:(CGFloat)lineSpace WithWidth:(CGFloat)width WithNumline:(NSInteger)lineCount;

// 改进的，优化包含了\n  \r\n文本 的计算方法
- (CGSize)labelHeightWithLineSpace:(CGFloat)lineSpace WithWidth:(CGFloat)width WithNumline:(NSInteger)lineCount;

@end
