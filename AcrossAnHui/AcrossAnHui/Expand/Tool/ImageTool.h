//
//  ImageTool.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/8.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageTool : NSObject

/**
 图片压缩

 @param image image
 @return data
 */
+ (NSData *) compressImage:(UIImage *)image;

@end
