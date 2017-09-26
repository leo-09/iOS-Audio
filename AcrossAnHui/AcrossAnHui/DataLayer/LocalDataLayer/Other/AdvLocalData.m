//
//  AdvLocalData.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/8.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "AdvLocalData.h"

@implementation AdvLocalData

#pragma mark - 单例模式

static AdvLocalData *instance;

+ (id) allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

+ (instancetype) sharedInstance {
    static dispatch_once_t oncetToken;
    dispatch_once(&oncetToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (id) copyWithZone:(NSZone *)zone {
    return instance;
}

#pragma mark - public method

-(void)saveImageDocuments:(UIImage *)image {
    // 首先,需要获取沙盒路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    // 拼接图片名为"advertisement.png"的路径
    NSString *imageFilePath = [path stringByAppendingPathComponent:@"advertisement.png"];

    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(image) writeToFile:imageFilePath atomically:YES];
}

// 读取并存贮到相册
-(UIImage *)getDocumentImage {
    // 首先,需要获取沙盒路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    // 拼接图片名为"advertisement.png"的路径
    NSString *imageFilePath = [path stringByAppendingPathComponent:@"advertisement.png"];
    
    // 拿到沙盒路径图片
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageFilePath];
    
    return image;
}

@end
