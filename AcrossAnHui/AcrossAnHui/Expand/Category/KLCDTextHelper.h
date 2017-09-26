//
//  KLCDTextHelper.h
//  定制公交
//
//  Created by HWS on 16/5/13.
//  Copyright © 2016年 KL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KLCDTextHelper : NSObject

/**
 *  计算文本高度
 *
 *  @param text      需要计算的文本
 *  @param fontSize  字体大小
 *  @param textWidth Label控件宽度
 *
 *  @return 计算高度的结果
 */
+ (CGFloat)HeightForText:(NSString *)text withFontSize:(CGFloat)fontSize withTextWidth:(CGFloat)textWidth;

/**
 *  计算文本宽度
 *
 *  @param text       需要计算的文本
 *  @param fontSize   字体大小
 *  @param textHeight Label控件高度
 *
 *  @return 计算告诉的结果
 */
+ (CGFloat)WidthForText:(NSString *)text withFontSize:(CGFloat)fontSize withTextHeight:(CGFloat)textHeight;


@end
