//
//  CarStationAnnotationView.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarStationAnnotationView.h"
#import "KLCDTextHelper.h"
#define kWidth  25.f
#define kHeight 30.f

@implementation CarStationAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f,kWidth,kHeight);
        self.backgroundColor = [UIColor clearColor];
        /* Create portrait image view and add to view hierarchy. */
        self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f,0.f, kWidth, kHeight)];
        [self addSubview:self.portraitImageView];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    if (_title!=title) {
        _title = title;
    }
    [self layoutIfNeeded];
}

- (void)setImageName:(NSString *)imageName{
    if (_imageName !=imageName) {
        _imageName = imageName;
    }
    self.portraitImageView.image = [UIImage imageNamed:_imageName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            /* Construct custom callout. */
            //           CGFloat *width = [KLCDTextHelper WidthForText:self.title withFontSize:14 withTextHeight:15];
            CGFloat width = [KLCDTextHelper WidthForText:self.title withFontSize:14 withTextHeight:15];
            self.calloutView = [[CarInspectCustomCalloutView alloc] initWithFrame:CGRectMake(-((width-15)/2),-30,width,15)];
        }
        self.calloutView.addressName = self.title;
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
    
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL inside = [super pointInside:point withEvent:event];
    if (!inside && self.selected){
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    return inside;
}

@end
