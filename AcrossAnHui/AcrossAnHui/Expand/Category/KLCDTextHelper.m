//
//  KLCDTextHelper.m
//  定制公交
//
//  Created by HWS on 16/5/13.
//  Copyright © 2016年 KL. All rights reserved.
//

#import "KLCDTextHelper.h"

@implementation KLCDTextHelper

#pragma mark - 计算内容文本的高度方法

+ (CGFloat)HeightForText:(NSString *)text withFontSize:(CGFloat)fontSize withTextWidth:(CGFloat)textWidth {
    // 获取文字字典
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    // 设定最大宽高
    CGSize size = CGSizeMake(textWidth, 2000);
    // 计算文字Frame
    CGRect frame = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return frame.size.height;
}

#pragma mark - 计算内容文本的宽度方法

+ (CGFloat)WidthForText:(NSString *)text withFontSize:(CGFloat)fontSize withTextHeight:(CGFloat)textHeight {
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = CGSizeMake(2000, textHeight);
    CGRect frame = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return frame.size.width;
}

@end
