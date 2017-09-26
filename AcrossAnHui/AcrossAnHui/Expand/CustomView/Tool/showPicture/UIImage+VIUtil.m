//
//  UIImage+VIUtil.m
//  HiHiomeBaby
//
//  Created by liyy on 15/10/19.
//  Copyright © 2015年 liyy. All rights reserved.
//

#import "UIImage+VIUtil.h"

@implementation UIImage (VIUtil)

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize imageSize = CGSizeMake(self.size.width / self.scale,
                                  self.size.height / self.scale);
    
    CGFloat widthRatio = imageSize.width / size.width;
    CGFloat heightRatio = imageSize.height / size.height;
    
    if (widthRatio > heightRatio) {
        imageSize = CGSizeMake(imageSize.width / widthRatio, imageSize.height / widthRatio);
    } else {
        imageSize = CGSizeMake(imageSize.width / heightRatio, imageSize.height / heightRatio);
    }
    
    return imageSize;
}

@end
