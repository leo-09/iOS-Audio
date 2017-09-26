//
//  PNLineChart.m
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNLineChart.h"
#import "PNColor.h"
#import "PNChartLabel.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"
#import <CoreText/CoreText.h>

#define IOS7_OR_LATER [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

@interface PNLineChart () {
    CGFloat maxYLabelWidth;
    CGFloat yAxisOffset;
}

@property(nonatomic) NSMutableArray *chartLineArray;  // Array[CAShapeLayer]
@property(nonatomic) NSMutableArray *chartPointArray; // Array[CAShapeLayer] save the point layer

@property(nonatomic) NSMutableArray *chartPath;       // Array of line path, one for each line.
@property(nonatomic) NSMutableArray *pointPath;       // Array of point path, one for each line
@property(nonatomic) NSMutableArray *endPointsOfPath;      // Array of start and end points of each line path, one for each line

@property(nonatomic) CABasicAnimation *pathAnimation; // will be set to nil if _displayAnimation is NO

// display grade
@property(nonatomic) NSMutableArray *gradeStringPaths;

@end

@implementation PNLineChart

@synthesize pathAnimation = _pathAnimation;

#pragma mark - initialization

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setupDefaultValues];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupDefaultValues];
    }
    
    return self;
}

- (void)setupDefaultValues {
    [super setupDefaultValues];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    self.chartLineArray = [NSMutableArray new];
    _showLabel = YES;
    _showGenYLabels = YES;
    _pathPoints = [[NSMutableArray alloc] init];
    _endPointsOfPath = [[NSMutableArray alloc] init];
    self.userInteractionEnabled = YES;
    
    _yFixedValueMin = -FLT_MAX;
    _yFixedValueMax = -FLT_MAX;
    _yLabelNum = 5.0;
    _yLabelHeight = [[[[PNChartLabel alloc] init] font] pointSize];
    
    _chartMarginTop = 25.0;
    _chartMarginBottom = 25.0;
    
    _showYAxis = YES;
    _showXArrow = NO;
    _showYArrow = NO;
    _isFillColor = YES;
    
    maxYLabelWidth = 6.0;
    yAxisOffset = 10.0;
    
    _yLabelFormat = @"%1.f";
    
    _chartCavanWidth = self.frame.size.width - maxYLabelWidth - yAxisOffset * 2.5;
    _chartCavanHeight = self.frame.size.height - _chartMarginBottom - _chartMarginTop;
    
    // Coordinate Axis Default Values
    _showCoordinateAxis = NO;
    _axisColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.f];
    _axisWidth = 1.f;
    
    // do not create curved line chart by default
    _showSmoothLines = NO;
}

#pragma mark - drawRect

- (void)drawRect:(CGRect)rect {
    if (self.isShowCoordinateAxis) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        UIGraphicsPushContext(ctx);
        CGContextSetLineWidth(ctx, self.axisWidth);
        CGContextSetStrokeColorWithColor(ctx, [self.axisColor CGColor]);
        
        CGFloat xAxisWidth = CGRectGetWidth(rect);// - (_chartMarginLeft + _chartMarginRight) / 2;
        CGFloat yAxisHeight = _chartMarginBottom + _chartCavanHeight;
        
        // draw coordinate axis
        if (_showYAxis) { // 显示 X Y轴
            CGContextMoveToPoint(ctx, maxYLabelWidth + yAxisOffset, 0);
            CGContextAddLineToPoint(ctx, maxYLabelWidth + yAxisOffset, yAxisHeight);
            CGContextAddLineToPoint(ctx, xAxisWidth, yAxisHeight);
            CGContextStrokePath(ctx);
        } else {
            // 只显示 X轴
            CGContextMoveToPoint(ctx, maxYLabelWidth + yAxisOffset, yAxisHeight);
            CGContextAddLineToPoint(ctx, xAxisWidth, yAxisHeight);
            CGContextStrokePath(ctx);
        }
        
        if (_showYArrow) {// Y轴箭头
            // draw y axis arrow
            CGContextMoveToPoint(ctx, maxYLabelWidth + yAxisOffset - 3, 6);
            CGContextAddLineToPoint(ctx, maxYLabelWidth + yAxisOffset, 0);
            CGContextAddLineToPoint(ctx, maxYLabelWidth + yAxisOffset + 3, 6);
            CGContextStrokePath(ctx);
        }
        
        if (_showXArrow) {// X轴箭头
            // draw x axis arrow
            CGContextMoveToPoint(ctx, xAxisWidth - 6, yAxisHeight - 3);
            CGContextAddLineToPoint(ctx, xAxisWidth, yAxisHeight);
            CGContextAddLineToPoint(ctx, xAxisWidth - 6, yAxisHeight + 3);
            CGContextStrokePath(ctx);
        }
        
        if (self.showLabel) {
            // draw x axis separator  X轴标示线
            CGPoint point;
            for (NSUInteger i = 0; i < [self.xLabels count]; i++) {
                point = CGPointMake(maxYLabelWidth + (i * _xLabelWidth) + yAxisOffset, _chartMarginBottom + _chartCavanHeight);
                CGContextMoveToPoint(ctx, point.x, point.y - 2);
                CGContextAddLineToPoint(ctx, point.x, point.y);
                CGContextStrokePath(ctx);
            }
        }
        
        UIFont *font = [UIFont systemFontOfSize:11];
        // draw y unit
        if ([self.yUnit length]) {
            CGFloat height = [PNLineChart sizeOfString:self.yUnit withWidth:30.f font:font].height;
            CGRect drawRect = CGRectMake(0 + 10 + 5, 0, 30.f, height);
            [self drawTextInContext:ctx text:self.yUnit inRect:drawRect font:font];
        }
        
        // draw x unit
        if ([self.xUnit length]) {
            CGFloat height = [PNLineChart sizeOfString:self.xUnit withWidth:30.f font:font].height;
            CGRect drawRect = CGRectMake(CGRectGetWidth(rect) - 0 + 5, _chartMarginBottom + _chartCavanHeight - height / 2, 25.f, height);
            [self drawTextInContext:ctx text:self.xUnit inRect:drawRect font:font];
        }
    }
    
    if (self.showYGridLines) {// 显示网格线
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        if (self.yGridLinesColor) {
            CGContextSetStrokeColorWithColor(ctx, self.yGridLinesColor.CGColor);
        } else {
            CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
        }
        
        CGFloat yStepHeight = _chartCavanHeight / _yLabelNum;
        CGPoint point;
        for (NSUInteger i = 0; i < (_yLabelNum + 1); i++) {
            point = CGPointMake(maxYLabelWidth + yAxisOffset, (_chartCavanHeight - i * yStepHeight + _yLabelHeight / 2));
            CGContextMoveToPoint(ctx, point.x, point.y);
            // add dotted style grid
            CGFloat dash[] = {6, 5};
            // dot diameter is 20 points
            CGContextSetLineWidth(ctx, 0.5);
            CGContextSetLineCap(ctx, kCGLineCapRound);// 横向的虚线
            CGContextSetLineDash(ctx, 0.0, dash, 2);
            CGContextAddLineToPoint(ctx, CGRectGetWidth(rect), point.y);
            CGContextStrokePath(ctx);
        }
    }
    
    [super drawRect:rect];
}

#pragma mark Draw Chart

- (void)strokeChart {
    _chartPath = [[NSMutableArray alloc] init];
    _pointPath = [[NSMutableArray alloc] init];
    _gradeStringPaths = [NSMutableArray array];
    
    [self calculateChartPath:_chartPath andPointsPath:_pointPath andPathKeyPoints:_pathPoints andPathStartEndPoints:_endPointsOfPath];
    
    // Draw each line
    for (NSUInteger lineIndex = 0; lineIndex < self.chartData.count; lineIndex++) {
        PNLineChartData *chartData = self.chartData[lineIndex];
        CAShapeLayer *chartLine = (CAShapeLayer *) self.chartLineArray[lineIndex];
        CAShapeLayer *pointLayer = (CAShapeLayer *) self.chartPointArray[lineIndex];
        
        UIGraphicsBeginImageContext(self.frame.size);
        
        // setup the color of the chart line
        if (_isFillColor) {
            pointLayer.fillColor = [[chartData.inflexionPointColor colorWithAlphaComponent:chartData.alpha] CGColor];
//            chartLine.fillColor = [[chartData.color colorWithAlphaComponent:0.5] CGColor];
        } else {
            pointLayer.strokeColor = [[chartData.inflexionPointColor colorWithAlphaComponent:chartData.alpha] CGColor];
//            chartLine.strokeColor = [[chartData.color colorWithAlphaComponent:chartData.alpha] CGColor];
        }
        chartLine.strokeColor = [[chartData.color colorWithAlphaComponent:chartData.alpha] CGColor];
        
        // 值的连线
        UIBezierPath *progressline = [_chartPath objectAtIndex:lineIndex];
        
//        // TODOs
//        [progressline addLineToPoint:CGPointMake(maxYLabelWidth + _xLabelWidth * (_xLabels.count-1) - _xLabelWidth / 2 + yAxisOffset, _chartCavanHeight)];
//        [progressline addLineToPoint:CGPointMake(0, _chartCavanHeight)];
        
        chartLine.path = progressline.CGPath;
        
        // 值的节点
        UIBezierPath *pointPath = [_pointPath objectAtIndex:lineIndex];
        pointLayer.path = pointPath.CGPath;
        
        [CATransaction begin];
        
        [chartLine addAnimation:self.pathAnimation forKey:@"strokeEndAnimation"];
        chartLine.strokeEnd = 1.0;
        
        // if you want cancel the point animation, conment this code, the point will show immediately
        if (chartData.inflexionPointStyle != PNLineChartPointStyleNone) {
            [pointLayer addAnimation:self.pathAnimation forKey:@"strokeEndAnimation"];
        }
        
        [CATransaction commit];
        
        NSMutableArray *textLayerArray = [self.gradeStringPaths objectAtIndex:lineIndex];
        for (CATextLayer *textLayer in textLayerArray) {
            CABasicAnimation *fadeAnimation = [self fadeAnimation];
            [textLayer addAnimation:fadeAnimation forKey:nil];
        }
        
        UIGraphicsEndImageContext();
    }
}

- (void)calculateChartPath:(NSMutableArray *)chartPath andPointsPath:(NSMutableArray *)pointsPath andPathKeyPoints:(NSMutableArray *)pathPoints andPathStartEndPoints:(NSMutableArray *)pointsOfPath {
    
    // Draw each line
    for (NSUInteger lineIndex = 0; lineIndex < self.chartData.count; lineIndex++) {
        PNLineChartData *chartData = self.chartData[lineIndex];
        
        CGFloat yValue;
        CGFloat innerGrade;
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        UIBezierPath *pointPath = [UIBezierPath bezierPath];
        
        [chartPath insertObject:progressline atIndex:lineIndex];
        [pointsPath insertObject:pointPath atIndex:lineIndex];
        
        NSMutableArray *gradePathArray = [NSMutableArray array];
        [self.gradeStringPaths addObject:gradePathArray];
        
        NSMutableArray *linePointsArray = [[NSMutableArray alloc] init];
        NSMutableArray *lineStartEndPointsArray = [[NSMutableArray alloc] init];
        int last_x = 0;
        int last_y = 0;
        NSMutableArray<NSDictionary<NSString *, NSValue *> *> *progrssLinePaths = [NSMutableArray new];
        CGFloat inflexionWidth = chartData.inflexionPointWidth;
        
        for (NSUInteger i = 0; i < chartData.itemCount; i++) {
            NSString *indexStr = @"";
            if (i == 0) {
                indexStr = @"first";
            }
            if (i == (chartData.itemCount-1)) {
                indexStr = @"last";
            }
            
            yValue = chartData.getData(i).y;
            if (!(_yValueMax - _yValueMin)) {
                innerGrade = 0.5;
            } else {
                innerGrade = (yValue - _yValueMin) / (_yValueMax - _yValueMin);
            }
            
            int x = i * _xLabelWidth + maxYLabelWidth + yAxisOffset;
            int y = _chartCavanHeight - (innerGrade * _chartCavanHeight) + (_yLabelHeight / 2) + _chartMarginTop - _chartMarginBottom;
            
            // Circular point
            if (chartData.inflexionPointStyle == PNLineChartPointStyleCircle) {
                CGRect circleRect = CGRectMake(x - inflexionWidth / 2, y - inflexionWidth / 2, inflexionWidth, inflexionWidth);
                CGPoint circleCenter = CGPointMake(circleRect.origin.x + (circleRect.size.width / 2), circleRect.origin.y + (circleRect.size.height / 2));
                
                [pointPath moveToPoint:CGPointMake(circleCenter.x + (inflexionWidth / 2), circleCenter.y)];
                [pointPath addArcWithCenter:circleCenter radius:inflexionWidth / 2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
                
                //jet text display text
                if (chartData.showPointLabel) {
                    [gradePathArray addObject:[self createPointLabelFor:chartData.getData(i).rawY pointCenter:circleCenter width:inflexionWidth withChartData:chartData index:indexStr]];
                }
                
                if (i > 0) {
                    // calculate the point for line
                    float distance = sqrt(pow(x - last_x, 2) + pow(y - last_y, 2));
                    float last_x1 = last_x + (inflexionWidth / 2) / distance * (x - last_x);
                    float last_y1 = last_y + (inflexionWidth / 2) / distance * (y - last_y);
                    float x1 = x - (inflexionWidth / 2) / distance * (x - last_x);
                    float y1 = y - (inflexionWidth / 2) / distance * (y - last_y);
                    
                    [progrssLinePaths addObject:@{@"from" : [NSValue valueWithCGPoint:CGPointMake(last_x1, last_y1)],
                                                  @"to" : [NSValue valueWithCGPoint:CGPointMake(x1, y1)]}];
                }
            } else if (chartData.inflexionPointStyle == PNLineChartPointStyleSquare) {// Square point
                CGRect squareRect = CGRectMake(x - inflexionWidth / 2, y - inflexionWidth / 2, inflexionWidth, inflexionWidth);
                CGPoint squareCenter = CGPointMake(squareRect.origin.x + (squareRect.size.width / 2), squareRect.origin.y + (squareRect.size.height / 2));
                
                [pointPath moveToPoint:CGPointMake(squareCenter.x - (inflexionWidth / 2), squareCenter.y - (inflexionWidth / 2))];
                [pointPath addLineToPoint:CGPointMake(squareCenter.x + (inflexionWidth / 2), squareCenter.y - (inflexionWidth / 2))];
                [pointPath addLineToPoint:CGPointMake(squareCenter.x + (inflexionWidth / 2), squareCenter.y + (inflexionWidth / 2))];
                [pointPath addLineToPoint:CGPointMake(squareCenter.x - (inflexionWidth / 2), squareCenter.y + (inflexionWidth / 2))];
                [pointPath closePath];
                
                // text display text
                if (chartData.showPointLabel) {
                    [gradePathArray addObject:[self createPointLabelFor:chartData.getData(i).rawY pointCenter:squareCenter width:inflexionWidth withChartData:chartData index:indexStr]];
                }
                
                if (i > 0) {
                    // calculate the point for line
                    float distance = sqrt(pow(x - last_x, 2) + pow(y - last_y, 2));
                    float last_x1 = last_x + (inflexionWidth / 2);
                    float last_y1 = last_y + (inflexionWidth / 2) / distance * (y - last_y);
                    float x1 = x - (inflexionWidth / 2);
                    float y1 = y - (inflexionWidth / 2) / distance * (y - last_y);
                    
                    [progrssLinePaths addObject:@{@"from" : [NSValue valueWithCGPoint:CGPointMake(last_x1, last_y1)],
                                                  @"to" : [NSValue valueWithCGPoint:CGPointMake(x1, y1)]}];
                }
            } else if (chartData.inflexionPointStyle == PNLineChartPointStyleTriangle) {// Triangle point
                CGRect squareRect = CGRectMake(x - inflexionWidth / 2, y - inflexionWidth / 2, inflexionWidth, inflexionWidth);
                
                CGPoint startPoint = CGPointMake(squareRect.origin.x, squareRect.origin.y + squareRect.size.height);
                CGPoint endPoint = CGPointMake(squareRect.origin.x + (squareRect.size.width / 2), squareRect.origin.y);
                CGPoint middlePoint = CGPointMake(squareRect.origin.x + (squareRect.size.width), squareRect.origin.y + squareRect.size.height);
                
                [pointPath moveToPoint:startPoint];
                [pointPath addLineToPoint:middlePoint];
                [pointPath addLineToPoint:endPoint];
                [pointPath closePath];
                
                // text display text
                if (chartData.showPointLabel) {
                    [gradePathArray addObject:[self createPointLabelFor:chartData.getData(i).rawY pointCenter:middlePoint width:inflexionWidth withChartData:chartData index:indexStr]];
                }
                
                if (i > 0) {
                    // calculate the point for triangle
                    float distance = sqrt(pow(x - last_x, 2) + pow(y - last_y, 2)) * 1.4;
                    float last_x1 = last_x + (inflexionWidth / 2) / distance * (x - last_x);
                    float last_y1 = last_y + (inflexionWidth / 2) / distance * (y - last_y);
                    float x1 = x - (inflexionWidth / 2) / distance * (x - last_x);
                    float y1 = y - (inflexionWidth / 2) / distance * (y - last_y);
                    
                    [progrssLinePaths addObject:@{@"from" : [NSValue valueWithCGPoint:CGPointMake(last_x1, last_y1)],
                                                  @"to" : [NSValue valueWithCGPoint:CGPointMake(x1, y1)]}];
                }
            } else {
                CGRect squareRect = CGRectMake(x - inflexionWidth / 2, y - inflexionWidth / 2, inflexionWidth, inflexionWidth);
                CGPoint middlePoint = CGPointMake(squareRect.origin.x + (squareRect.size.width), squareRect.origin.y + squareRect.size.height);
                
                // text display text
                if (chartData.showPointLabel) {
                    [gradePathArray addObject:[self createPointLabelFor:chartData.getData(i).rawY pointCenter:middlePoint width:inflexionWidth withChartData:chartData index:indexStr]];
                }
                
                if (i > 0) {
                    [progrssLinePaths addObject:@{@"from" : [NSValue valueWithCGPoint:CGPointMake(last_x, last_y)],
                                                  @"to" : [NSValue valueWithCGPoint:CGPointMake(x, y)]}];
                }
            }
            [linePointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
            last_x = x;
            last_y = y;
        }
        
        if (self.showSmoothLines && chartData.itemCount >= 4) {
            [progressline moveToPoint:[progrssLinePaths[0][@"from"] CGPointValue]];
            for (NSDictionary<NSString *, NSValue *> *item in progrssLinePaths) {
                CGPoint p1 = [item[@"from"] CGPointValue];
                CGPoint p2 = [item[@"to"] CGPointValue];
                [progressline moveToPoint:p1];
                CGPoint midPoint = [PNLineChart midPointBetweenPoint1:p1 andPoint2:p2];
                [progressline addQuadCurveToPoint:midPoint
                                     controlPoint:[PNLineChart controlPointBetweenPoint1:midPoint andPoint2:p1]];
                [progressline addQuadCurveToPoint:p2
                                     controlPoint:[PNLineChart controlPointBetweenPoint1:midPoint andPoint2:p2]];
            }
        } else {
            for (NSDictionary<NSString *, NSValue *> *item in progrssLinePaths) {
                if (item[@"from"]) {
                    [progressline moveToPoint:[item[@"from"] CGPointValue]];
                    [lineStartEndPointsArray addObject:item[@"from"]];
                }
                if (item[@"to"]) {
                    [progressline addLineToPoint:[item[@"to"] CGPointValue]];
                    [lineStartEndPointsArray addObject:item[@"to"]];
                }
            }
        }
        [pathPoints addObject:[linePointsArray copy]];
        [pointsOfPath addObject:[lineStartEndPointsArray copy]];
    }
}

#pragma mark - Set Chart Data

- (void)setChartData:(NSArray *)data {
    if (data != _chartData) {
        // remove all shape layers before adding new ones
        for (CALayer *layer in self.chartLineArray) {
            [layer removeFromSuperlayer];
        }
        for (CALayer *layer in self.chartPointArray) {
            [layer removeFromSuperlayer];
        }
        
        self.chartLineArray = [NSMutableArray arrayWithCapacity:data.count];
        self.chartPointArray = [NSMutableArray arrayWithCapacity:data.count];
        
        for (PNLineChartData *chartData in data) {
            // create as many chart line layers as there are data-lines
            CAShapeLayer *chartLine = [CAShapeLayer layer];
            chartLine.lineCap = kCALineCapButt;
            chartLine.lineJoin = kCALineJoinMiter;
            chartLine.fillColor = [[UIColor whiteColor] CGColor];
            chartLine.lineWidth = chartData.lineWidth;
            chartLine.strokeEnd = 0.0;
            [self.layer addSublayer:chartLine];
            [self.chartLineArray addObject:chartLine];
            
            // create point
            CAShapeLayer *pointLayer = [CAShapeLayer layer];
            pointLayer.strokeColor = [[chartData.color colorWithAlphaComponent:chartData.alpha] CGColor];
            pointLayer.lineCap = kCALineCapRound;
            pointLayer.lineJoin = kCALineJoinBevel;
            pointLayer.fillColor = nil;
            pointLayer.lineWidth = chartData.lineWidth;
            [self.layer addSublayer:pointLayer];
            [self.chartPointArray addObject:pointLayer];
        }
        
        _chartData = data;
        
        [self prepareYLabelsWithData:data];
        // Cavan height and width needs to be set before
        // setNeedsDisplay is invoked because setNeedsDisplay
        // will invoke drawRect and if Cavan dimensions is not
        // set the chart will be misplaced
        if (!_showLabel) {
            _chartCavanHeight = self.frame.size.height - 2 * _yLabelHeight;
            _chartCavanWidth = self.frame.size.width - maxYLabelWidth - yAxisOffset * 2.5;
            _xLabelWidth = (_chartCavanWidth / ([_xLabels count]-1));
        }
        [self setNeedsDisplay];
    }
}

- (void)prepareYLabelsWithData:(NSArray *)data {
    CGFloat yMax = 0.0f;
    CGFloat yMin = MAXFLOAT;
    NSMutableArray *yLabelsArray = [NSMutableArray new];
    
    for (PNLineChartData *chartData in data) {
        // create as many chart line layers as there are data-lines
        for (NSUInteger i = 0; i < chartData.itemCount; i++) {
            CGFloat yValue = chartData.getData(i).y;
            [yLabelsArray addObject:[NSString stringWithFormat:@"%2f", yValue]];
            yMax = fmaxf(yMax, yValue);
            yMin = fminf(yMin, yValue);
        }
    }
    
    // Min value for Y label
    if (yMax < 5) {
        yMax = 5.0f;
    }
    
    _yValueMin = (_yFixedValueMin > -FLT_MAX) ? _yFixedValueMin : yMin;
    _yValueMax = (_yFixedValueMax > -FLT_MAX) ? _yFixedValueMax : yMax + yMax / 10.0;
    
    if (_showGenYLabels) {
        [self setYLabels];
    }
}

#pragma mark setter X\Y methods

- (void)setYLabels {
    CGFloat yStep = (_yValueMax - _yValueMin) / _yLabelNum;
    CGFloat yStepHeight = _chartCavanHeight / _yLabelNum;
    
    if (_yChartLabels) {
        for (PNChartLabel *label in _yChartLabels) {
            [label removeFromSuperview];
        }
    } else {
        _yChartLabels = [NSMutableArray new];
    }
    
    if (yStep == 0.0) {
        PNChartLabel *minLabel = [[PNChartLabel alloc] initWithFrame:CGRectMake(0.0, (NSInteger) _chartCavanHeight, (NSInteger) _chartMarginBottom, (NSInteger) _yLabelHeight)];
        minLabel.text = [self formatYLabel:0.0];
        [self setCustomStyleForYLabel:minLabel];
        [self addSubview:minLabel];
        [_yChartLabels addObject:minLabel];
        
        PNChartLabel *midLabel = [[PNChartLabel alloc] initWithFrame:CGRectMake(0.0, (NSInteger) (_chartCavanHeight / 2), (NSInteger) _chartMarginBottom, (NSInteger) _yLabelHeight)];
        midLabel.text = [self formatYLabel:_yValueMax];
        [self setCustomStyleForYLabel:midLabel];
        [self addSubview:midLabel];
        [_yChartLabels addObject:midLabel];
        
        PNChartLabel *maxLabel = [[PNChartLabel alloc] initWithFrame:CGRectMake(0.0, 0.0, (NSInteger) _chartMarginBottom, (NSInteger) _yLabelHeight)];
        maxLabel.text = [self formatYLabel:_yValueMax * 2];
        [self setCustomStyleForYLabel:maxLabel];
        [self addSubview:maxLabel];
        [_yChartLabels addObject:maxLabel];
    } else {
        NSInteger index = 0;
        NSInteger num = _yLabelNum + 1;
        while (num > 0) {
            PNChartLabel *label = [[PNChartLabel alloc] initWithFrame:CGRectMake(0.0, (NSInteger) (_chartCavanHeight - index * yStepHeight), (NSInteger) _chartMarginBottom, (NSInteger) _yLabelHeight)];
            [label setTextAlignment:NSTextAlignmentRight];
            label.text = [self formatYLabel:_yValueMin + (yStep * index)];
            [self setCustomStyleForYLabel:label];
            [self addSubview:label];
            [_yChartLabels addObject:label];
            index += 1;
            num -= 1;
        }
    }
}

- (void)setYLabels:(NSArray *)yLabels {
    _showGenYLabels = NO;
    _yLabelNum = yLabels.count - 1;
    
    CGFloat yLabelHeight;
    if (_showLabel) {
        yLabelHeight = _chartCavanHeight / [yLabels count];
    } else {
        yLabelHeight = (self.frame.size.height) / [yLabels count];
    }
    
    return [self setYLabels:yLabels withHeight:yLabelHeight];
}

- (void)setYLabels:(NSArray *)yLabels withHeight:(CGFloat)height {
    _yLabels = yLabels;
    _yLabelHeight = height;
    if (_yChartLabels) {
        for (PNChartLabel *label in _yChartLabels) {
            [label removeFromSuperview];
        }
    } else {
        _yChartLabels = [NSMutableArray new];
    }
    
    if (_showLabel) {
        for (NSString *yText in yLabels) {
            CGFloat width = [PNLineChart sizeOfString:yText withWidth:1000 font:_yLabelFont].width;
            if (width > maxYLabelWidth) {
                maxYLabelWidth = width;
            }
        }
        
        CGFloat yStepHeight = _chartCavanHeight / _yLabelNum;
        NSString *labelText;
        for (int index = 0; index < yLabels.count; index++) {
            labelText = yLabels[index];
            
            NSInteger y = (NSInteger) (_chartCavanHeight - index * yStepHeight);
            CGRect f = CGRectMake(0.0, y, maxYLabelWidth, (NSInteger) _yLabelHeight);
            PNChartLabel *label = [[PNChartLabel alloc] initWithFrame:f];
            [label setTextAlignment:NSTextAlignmentRight];
            label.text = labelText;
            [self setCustomStyleForYLabel:label];
            [self addSubview:label];
            [_yChartLabels addObject:label];
        }
        
        _chartCavanWidth = self.frame.size.width - maxYLabelWidth - yAxisOffset * 2.5;
        // 重新绘画X轴坐标
        if (_xLabels) {
            self.xLabels = _xLabels;
        }
    }
}

- (CGFloat)computeEqualWidthForXLabels:(NSArray *)xLabels {
    CGFloat xLabelWidth;
    
    if (_showLabel) {
        xLabelWidth = _chartCavanWidth / [xLabels count];
    } else {
        xLabelWidth = (self.frame.size.width) / [xLabels count];
    }
    
    return xLabelWidth;
}

- (void)setXLabels:(NSArray *)xLabels {
    CGFloat xLabelWidth;
    
    if (_showLabel) {
        xLabelWidth = _chartCavanWidth / ([xLabels count]-1);
    } else {
        xLabelWidth = (self.frame.size.width - maxYLabelWidth) / ([xLabels count]-1);
    }
    
    return [self setXLabels:xLabels withWidth:xLabelWidth];
}

- (void)setXLabels:(NSArray *)xLabels withWidth:(CGFloat)width {
    _xLabels = xLabels;
    _xLabelWidth = width;
    if (_xChartLabels) {
        for (PNChartLabel *label in _xChartLabels) {
            [label removeFromSuperview];
        }
    } else {
        _xChartLabels = [NSMutableArray new];
    }
    
    if (_showLabel) {
        NSString *labelText;
        for (int index = 0; index < xLabels.count; index++) {
            labelText = xLabels[index];
            
            NSInteger x = maxYLabelWidth + _xLabelWidth * index - _xLabelWidth / 2 + yAxisOffset;
            NSInteger y = _chartMarginBottom + _chartCavanHeight;
            
            CGRect f = CGRectMake(x, y, (NSInteger) _xLabelWidth, (NSInteger) _chartMarginBottom);
            PNChartLabel *label = [[PNChartLabel alloc] initWithFrame:f];
            [label setTextAlignment:NSTextAlignmentCenter];
            label.text = labelText;
            [self setCustomStyleForXLabel:label];
            [self addSubview:label];
            [_xChartLabels addObject:label];
        }
    }
}

- (void)setCustomStyleForXLabel:(UILabel *)label {
    if (_xLabelFont) {
        label.font = _xLabelFont;
    }
    
    if (_xLabelColor) {
        label.textColor = _xLabelColor;
    }
}

- (void)setCustomStyleForYLabel:(UILabel *)label {
    if (_yLabelFont) {
        label.font = _yLabelFont;
    }
    
    if (_yLabelColor) {
        label.textColor = _yLabelColor;
    }
}

#pragma mark - Update Chart Data

- (void)updateChartData:(NSArray *)data {
    _chartData = data;
    
    [self prepareYLabelsWithData:data];
    
    [self calculateChartPath:_chartPath andPointsPath:_pointPath andPathKeyPoints:_pathPoints andPathStartEndPoints:_endPointsOfPath];
    
    for (NSUInteger lineIndex = 0; lineIndex < self.chartData.count; lineIndex++) {
        CAShapeLayer *chartLine = (CAShapeLayer *) self.chartLineArray[lineIndex];
        CAShapeLayer *pointLayer = (CAShapeLayer *) self.chartPointArray[lineIndex];
        
        UIBezierPath *progressline = [_chartPath objectAtIndex:lineIndex];
        UIBezierPath *pointPath = [_pointPath objectAtIndex:lineIndex];
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnimation.fromValue = (id) chartLine.path;
        pathAnimation.toValue = (id) [progressline CGPath];
        pathAnimation.duration = 0.5f;
        pathAnimation.autoreverses = NO;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [chartLine addAnimation:pathAnimation forKey:@"animationKey"];
        
        CABasicAnimation *pointPathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pointPathAnimation.fromValue = (id) pointLayer.path;
        pointPathAnimation.toValue = (id) [pointPath CGPath];
        pointPathAnimation.duration = 0.5f;
        pointPathAnimation.autoreverses = NO;
        pointPathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [pointLayer addAnimation:pointPathAnimation forKey:@"animationKey"];
        
        chartLine.path = progressline.CGPath;
        pointLayer.path = pointPath.CGPath;
    }
}

#pragma mark - tools

+ (CGSize)sizeOfString:(NSString *)text withWidth:(float)width font:(UIFont *)font {
    CGSize size = CGSizeMake(width, MAXFLOAT);

    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        size = [text boundingRectWithSize:size
                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                               attributes:tdic
                                  context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
#pragma clang diagnostic pop
    }

    return size;
}

+ (CGPoint)midPointBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2 {
    return CGPointMake((point1.x + point2.x) / 2, (point1.y + point2.y) / 2);
}

+ (CGPoint)controlPointBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2 {
    CGPoint controlPoint = [self midPointBetweenPoint1:point1 andPoint2:point2];
    CGFloat diffY = abs((int) (point2.y - controlPoint.y));
    if (point1.y < point2.y)
        controlPoint.y += diffY;
    else if (point1.y > point2.y)
        controlPoint.y -= diffY;
    return controlPoint;
}

- (void)drawTextInContext:(CGContextRef)ctx text:(NSString *)text inRect:(CGRect)rect font:(UIFont *)font {
    if (IOS7_OR_LATER) {
        NSMutableParagraphStyle *priceParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        priceParagraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        priceParagraphStyle.alignment = NSTextAlignmentLeft;

        [text drawInRect:rect
          withAttributes:@{NSParagraphStyleAttributeName : priceParagraphStyle, NSFontAttributeName : font}];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [text drawInRect:rect
                withFont:font
           lineBreakMode:NSLineBreakByTruncatingTail
               alignment:NSTextAlignmentLeft];
#pragma clang diagnostic pop
    }
}

- (NSString *)formatYLabel:(double)value {
    if (self.yLabelBlockFormatter) {
        return self.yLabelBlockFormatter(value);
    } else {
        if (!self.thousandsSeparator) {
            NSString *format = self.yLabelFormat ?: @"%1.f";
            return [NSString stringWithFormat:format, value];
        }

        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:value]];
    }
}

- (UIView *)getLegendWithMaxWidth:(CGFloat)mWidth {
    if ([self.chartData count] < 1) {
        return nil;
    }

    /* This is a short line that refers to the chart data */
    CGFloat legendLineWidth = 40;

    /* x and y are the coordinates of the starting point of each legend item */
    CGFloat x = 0;
    CGFloat y = 0;

    /* accumulated height */
    CGFloat totalHeight = 0;
    CGFloat totalWidth = 0;

    NSMutableArray *legendViews = [[NSMutableArray alloc] init];

    /* Determine the max width of each legend item */
    CGFloat maxLabelWidth;
    if (self.legendStyle == PNLegendItemStyleStacked) {
        maxLabelWidth = mWidth - legendLineWidth;
    } else {
        maxLabelWidth = MAXFLOAT;
    }

    /* this is used when labels wrap text and the line
     * should be in the middle of the first row */
    CGFloat singleRowHeight = [PNLineChart sizeOfString:@"Test"
                                              withWidth:MAXFLOAT
                                                   font:self.legendFont ? self.legendFont : [UIFont systemFontOfSize:12.0f]].height;

    NSUInteger counter = 0;
    NSUInteger rowWidth = 0;
    NSUInteger rowMaxHeight = 0;

    for (PNLineChartData *pdata in self.chartData) {
        /* Expected label size*/
        CGSize labelsize = [PNLineChart sizeOfString:pdata.dataTitle
                                           withWidth:maxLabelWidth
                                                font:self.legendFont ? self.legendFont : [UIFont systemFontOfSize:12.0f]];

        /* draw lines */
        if ((rowWidth + labelsize.width + legendLineWidth > mWidth) && (self.legendStyle == PNLegendItemStyleSerial)) {
            rowWidth = 0;
            x = 0;
            y += rowMaxHeight;
            rowMaxHeight = 0;
        }
        rowWidth += labelsize.width + legendLineWidth;
        totalWidth = self.legendStyle == PNLegendItemStyleSerial ? fmaxf(rowWidth, totalWidth) : fmaxf(totalWidth, labelsize.width + legendLineWidth);

        /* If there is inflection decorator, the line is composed of two lines
         * and this is the space that separates two lines in order to put inflection
         * decorator */

        CGFloat inflexionWidthSpacer = pdata.inflexionPointStyle == PNLineChartPointStyleTriangle ? pdata.inflexionPointWidth / 2 : pdata.inflexionPointWidth;

        CGFloat halfLineLength;

        if (pdata.inflexionPointStyle != PNLineChartPointStyleNone) {
            halfLineLength = (legendLineWidth * 0.8 - inflexionWidthSpacer) / 2;
        } else {
            halfLineLength = legendLineWidth * 0.8;
        }

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x + legendLineWidth * 0.1, y + (singleRowHeight - pdata.lineWidth) / 2, halfLineLength, pdata.lineWidth)];

        line.backgroundColor = pdata.color;
        line.alpha = pdata.alpha;
        [legendViews addObject:line];

        if (pdata.inflexionPointStyle != PNLineChartPointStyleNone) {
            line = [[UIView alloc] initWithFrame:CGRectMake(x + legendLineWidth * 0.1 + halfLineLength + inflexionWidthSpacer, y + (singleRowHeight - pdata.lineWidth) / 2, halfLineLength, pdata.lineWidth)];
            line.backgroundColor = pdata.color;
            line.alpha = pdata.alpha;
            [legendViews addObject:line];
        }

        // Add inflexion type
        UIColor *inflexionPointColor = pdata.inflexionPointColor;
        if (!inflexionPointColor) {
            inflexionPointColor = pdata.color;
        }
        [legendViews addObject:[self drawInflexion:pdata.inflexionPointWidth
                                            center:CGPointMake(x + legendLineWidth / 2, y + singleRowHeight / 2)
                                       strokeWidth:pdata.lineWidth
                                    inflexionStyle:pdata.inflexionPointStyle
                                          andColor:inflexionPointColor
                                          andAlpha:pdata.alpha]];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x + legendLineWidth, y, labelsize.width, labelsize.height)];
        label.text = pdata.dataTitle;
        label.textColor = self.legendFontColor ? self.legendFontColor : [UIColor blackColor];
        label.font = self.legendFont ? self.legendFont : [UIFont systemFontOfSize:12.0f];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;

        rowMaxHeight = fmaxf(rowMaxHeight, labelsize.height);
        x += self.legendStyle == PNLegendItemStyleStacked ? 0 : labelsize.width + legendLineWidth;
        y += self.legendStyle == PNLegendItemStyleStacked ? labelsize.height : 0;


        totalHeight = self.legendStyle == PNLegendItemStyleSerial ? fmaxf(totalHeight, rowMaxHeight + y) : totalHeight + labelsize.height;

        [legendViews addObject:label];
        counter++;
    }

    UIView *legend = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mWidth, totalHeight)];

    for (UIView *v in legendViews) {
        [legend addSubview:v];
    }
    return legend;
}

- (UIImageView *)drawInflexion:(CGFloat)size center:(CGPoint)center strokeWidth:(CGFloat)sw inflexionStyle:(PNLineChartPointStyle)type andColor:(UIColor *)color andAlpha:(CGFloat)alfa {
    //Make the size a little bigger so it includes also border stroke
    CGSize aSize = CGSizeMake(size + sw, size + sw);

    UIGraphicsBeginImageContextWithOptions(aSize, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    if (type == PNLineChartPointStyleCircle) {
        CGContextAddArc(context, (size + sw) / 2, (size + sw) / 2, size / 2, 0, M_PI * 2, YES);
    } else if (type == PNLineChartPointStyleSquare) {
        CGContextAddRect(context, CGRectMake(sw / 2, sw / 2, size, size));
    } else if (type == PNLineChartPointStyleTriangle) {
        CGContextMoveToPoint(context, sw / 2, size + sw / 2);
        CGContextAddLineToPoint(context, size + sw / 2, size + sw / 2);
        CGContextAddLineToPoint(context, size / 2 + sw / 2, sw / 2);
        CGContextAddLineToPoint(context, sw / 2, size + sw / 2);
        CGContextClosePath(context);
    }

    //Set some stroke properties
    CGContextSetLineWidth(context, sw);
    CGContextSetAlpha(context, alfa);
    CGContextSetStrokeColorWithColor(context, color.CGColor);

    //Finally draw
    CGContextDrawPath(context, kCGPathStroke);

    //now get the image from the context
    UIImage *squareImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    //// Translate origin
    CGFloat originX = center.x - (size + sw) / 2.0;
    CGFloat originY = center.y - (size + sw) / 2.0;

    UIImageView *squareImageView = [[UIImageView alloc] initWithImage:squareImage];
    [squareImageView setFrame:CGRectMake(originX, originY, size + sw, size + sw)];
    return squareImageView;
}

#pragma mark - setter and getter

- (CATextLayer *)createPointLabelFor:(CGFloat)grade pointCenter:(CGPoint)pointCenter
                               width:(CGFloat)width withChartData:(PNLineChartData *)chartData
                               index:(NSString *) index {
    CATextLayer *textLayer = [[CATextLayer alloc] init];
    [textLayer setAlignmentMode:kCAAlignmentCenter];
    [textLayer setForegroundColor:[chartData.pointLabelColor CGColor]];
    [textLayer setBackgroundColor:[UIColor clearColor].CGColor];
    [textLayer setCornerRadius:textLayer.fontSize / 8.0];

    if (chartData.pointLabelFont != nil) {
        [textLayer setFont:(__bridge CFTypeRef) (chartData.pointLabelFont)];
        textLayer.fontSize = [chartData.pointLabelFont pointSize];
    }
    
    CGFloat textHeight = textLayer.fontSize * 1.1;
    CGFloat textWidth = width * 8;
    CGFloat textStartPosY;
    
    textStartPosY = pointCenter.y - textLayer.fontSize;

    [self.layer addSublayer:textLayer];

    if (chartData.pointLabelFormat != nil) {
        [textLayer setString:[[NSString alloc] initWithFormat:chartData.pointLabelFormat, grade]];
    } else {
        [textLayer setString:[[NSString alloc] initWithFormat:_yLabelFormat, grade]];
    }

    [textLayer setFrame:CGRectMake(0, 0, textWidth, textHeight)];
    
    if ([index isEqualToString:@"first"]) {
        [textLayer setPosition:CGPointMake(pointCenter.x + textWidth/2, textStartPosY)];
    } else if ([index isEqualToString:@"last"]) {
        [textLayer setPosition:CGPointMake(pointCenter.x - textWidth/2, textStartPosY)];
    } else {
        [textLayer setPosition:CGPointMake(pointCenter.x, textStartPosY)];
    }
    
    textLayer.contentsScale = [UIScreen mainScreen].scale;

    return textLayer;
}

- (CABasicAnimation *)fadeAnimation {
    CABasicAnimation *fadeAnimation = nil;
    if (self.displayAnimated) {
        fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        fadeAnimation.toValue = [NSNumber numberWithFloat:1.0];
        fadeAnimation.duration = 2.0;
    }
    return fadeAnimation;
}

- (CABasicAnimation *)pathAnimation {
    if (self.displayAnimated && !_pathAnimation) {
        _pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _pathAnimation.duration = 1.0;
        _pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        _pathAnimation.fromValue = @0.0f;
        _pathAnimation.toValue = @1.0f;
    }
    return _pathAnimation;
}

#pragma mark - Touch at point

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchPoint:touches withEvent:event];
    [self touchKeyPoint:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchPoint:touches withEvent:event];
    [self touchKeyPoint:touches withEvent:event];
}

- (void)touchPoint:(NSSet *)touches withEvent:(UIEvent *)event {
    // Get the point user touched
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    for (NSInteger p = _pathPoints.count - 1; p >= 0; p--) {
        NSArray *linePointsArray = _endPointsOfPath[p];
        
        for (int i = 0; i < (int) linePointsArray.count - 1; i += 2) {
            CGPoint p1 = [linePointsArray[i] CGPointValue];
            CGPoint p2 = [linePointsArray[i + 1] CGPointValue];
            
            // Closest distance from point to line
            float distance = fabs(((p2.x - p1.x) * (touchPoint.y - p1.y)) - ((p1.x - touchPoint.x) * (p1.y - p2.y)));
            distance /= hypot(p2.x - p1.x, p1.y - p2.y);
            
            if (distance <= 5.0) {
                // Conform to delegate parameters, figure out what bezier path this CGPoint belongs to.
                for (UIBezierPath *path in _chartPath) {
                    BOOL pointContainsPath = CGPathContainsPoint(path.CGPath, NULL, p1, NO);
                    
                    if (pointContainsPath) {
                        [_delegate userClickedOnLinePoint:touchPoint lineIndex:[_chartPath indexOfObject:path]];
                        return;
                    }
                }
            }
        }
    }
}

- (void)touchKeyPoint:(NSSet *)touches withEvent:(UIEvent *)event {
    // Get the point user touched
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    for (NSInteger p = _pathPoints.count - 1; p >= 0; p--) {
        NSArray *linePointsArray = _pathPoints[p];
        
        for (int i = 0; i < (int) linePointsArray.count - 1; i += 1) {
            CGPoint p1 = [linePointsArray[i] CGPointValue];
            CGPoint p2 = [linePointsArray[i + 1] CGPointValue];
            
            float distanceToP1 = fabs(hypot(touchPoint.x - p1.x, touchPoint.y - p1.y));
            float distanceToP2 = hypot(touchPoint.x - p2.x, touchPoint.y - p2.y);
            
            float distance = MIN(distanceToP1, distanceToP2);
            
            if (distance <= 10.0) {
                [_delegate userClickedOnLineKeyPoint:touchPoint
                                           lineIndex:p
                                          pointIndex:(distance == distanceToP2 ? i + 1 : i)];
                
                return;
            }
        }
    }
}

@end
