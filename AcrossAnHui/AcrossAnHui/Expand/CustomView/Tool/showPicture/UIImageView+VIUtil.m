//
//  UIImageView+VIUtil.m
//  HiHiomeBaby
//
//  Created by liyy on 15/10/19.
//  Copyright © 2015年 liyy. All rights reserved.
//

#import "UIImageView+VIUtil.h"
#import "UIImage+VIUtil.h"

@implementation UIImageView (VIUtil)

- (CGSize)contentSize {
    return [self.image sizeThatFits:self.bounds.size];
}

@end
