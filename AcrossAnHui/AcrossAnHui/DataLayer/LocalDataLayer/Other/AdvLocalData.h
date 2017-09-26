//
//  AdvLocalData.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/8.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseLocalData.h"
#import <UIKit/UIKit.h>

/**
 广告页 保存图片
 */
@interface AdvLocalData : CTXBaseLocalData

+ (instancetype) sharedInstance;

/**
 保存图片

 @param image image
 */
-(void)saveImageDocuments:(UIImage *)image;

/**
 读取图片

 @return image
 */
-(UIImage *)getDocumentImage;

@end
