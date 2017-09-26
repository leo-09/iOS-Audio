//
//  ImageTool.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/8.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ImageTool.h"

@implementation ImageTool

+ (NSData *) compressImage:(UIImage *)image {
    NSData *zipImageData = UIImageJPEGRepresentation(image, 1.0);
    NSData *imageData = [[NSData alloc] initWithData:zipImageData];
    
    // byte(8个二进制位为一个字节) B KB MB GB TB
    // imageData.length 获取NSData的字节长度(B)
    if (imageData.length > (2 * 1024 * 1024)) { // 上传的图片不超过2MB
        imageData = UIImageJPEGRepresentation(image, 1 / (imageData.length / 2 * 1024 * 1024));
    }
    
    return imageData;
}

@end
