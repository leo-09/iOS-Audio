//
//  TextViewContentTool.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/16.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "TextViewContentTool.h"

@implementation TextViewContentTool

+ (NSString *) isContaintContent:(NSString *)str {
    
    // str为nil，则返回nil
    if (!str) {
        return nil;
    }
    
    NSMutableString *content = [[NSMutableString alloc] initWithString:str];
    
    // 删除以 \n 开头
    while ([content hasPrefix:@"\n"]) {
        [content deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    
    // 删除以 \r 开头
    while ([content hasPrefix:@"\r"]) {
        [content deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    
    // 删除以 " " 开头
    while ([content hasPrefix:@" "]) {
        [content deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    
    // 删除以 \n 结尾
    while ([content hasSuffix:@"\n"]) {
        [content deleteCharactersInRange:NSMakeRange(content.length - 1, 1)];
    }
    
    // 删除以 \r 结尾
    while ([content hasSuffix:@"\r"]) {
        [content deleteCharactersInRange:NSMakeRange(content.length - 1, 1)];
    }
    
    // 删除以 " " 结尾
    while ([content hasSuffix:@" "]) {
        [content deleteCharactersInRange:NSMakeRange(content.length - 1, 1)];
    }
    
    if ([content isEqualToString:@""]) {
        // str为全部都替换掉了，则返回nil
        return nil;
    } else {
        return content;
    }
}

+ (BOOL) isDoubleNumber:(NSString *)str {
    NSString *registPhone = @"^(([0-9]+\\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\\.[0-9]+)|([0-9]*[1-9][0-9]*))$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", registPhone];
    if ([regextestmobile evaluateWithObject:str]) {
        return YES;
    } else {
        return NO;
    }
}

@end
