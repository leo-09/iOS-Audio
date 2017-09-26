//
// Created by Jörg Polakowski on 14/12/13.
// Copyright (c) 2013 kevinzhow. All rights reserved.
//

#import "PNLineChartData.h"

@implementation PNLineChartData

- (id)init {
    self = [super init];
    if (self) {
        [self setupDefaultValues];
    }
    
    return self;
}

- (void)setupDefaultValues {
    _inflexionPointStyle = PNLineChartPointStyleNone;
    _inflexionPointWidth = 4.f;
    _lineWidth = 2.f;
    _alpha = 1.f;
    _showPointLabel = NO;
    _pointLabelColor = [UIColor blackColor];
    _pointLabelFormat = @"%1.f";
    _color = [UIColor blackColor];
    _inflexionPointColor = [UIColor greenColor];
}

@end