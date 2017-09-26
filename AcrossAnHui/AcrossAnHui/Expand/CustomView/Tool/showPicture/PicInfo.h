//
//  PicInfo.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/4.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PicInfo : NSObject

@property (nonatomic, retain) UIImage *image;       // 图片

@property (nonatomic, copy) NSString *imageURL;     // 图片的路径

@property (nonatomic, assign) CGRect picOldFrame;   // 原frame

@end
