//
//  CarStationAnnotationView.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//
#import <MAMapKit/MAMapKit.h>
#import <UIKit/UIKit.h>
#import "CarInspectCustomCalloutView.h"

@interface CarStationAnnotationView : MAAnnotationView

@property (nonatomic,copy)NSString *imageName;
@property (nonatomic,copy)NSString *title;

@property (nonatomic, strong) CarInspectCustomCalloutView *calloutView;
@property (nonatomic, strong) UIImageView *portraitImageView;

@end
