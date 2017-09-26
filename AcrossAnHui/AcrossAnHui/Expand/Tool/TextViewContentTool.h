//
//  TextViewContentTool.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/16.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextViewContentTool : NSObject

/**
 检查TextView输入的内容，替换掉\n ‘ ’ \r  \t 后，还有没有其他字符

 @param str TextView输入的内容
 @return YES，验证通过
 */

/**
 检查TextView输入的内容，替换掉\n ‘ ’ \r  \t 后，还有没有其他字符

 @param str TextView输入的内容
 @return  替换收尾\n ‘ ’ \r  \t后的字符串
 */
+ (NSString *) isContaintContent:(NSString *)str;

/**
 是否是正确的浮点数

 @param str 内容
 @return YES: 浮点数
 */
+ (BOOL) isDoubleNumber:(NSString *)str;

@end
