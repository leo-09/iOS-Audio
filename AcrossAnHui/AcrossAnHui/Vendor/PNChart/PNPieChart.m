//
//  PNPieChart.m
//  PNChartDemo
//
//  Created by Hang Zhang on 14-5-5.
//  Copyright (c) 2014年 kevinzhow. All rights reserved.
//

#import "PNPieChart.h"
//needed for the expected label size
#import "PNLineChart.h"

@interface PNPieChart()

@property (nonatomic) NSArray *items;
@property (nonatomic) NSArray *endPercentages;

@property (nonatomic) UIView         *contentView;
@property (nonatomic) CAShapeLayer   *pieLayer;
@property (nonatomic) NSMutableArray *descriptionLabels;
@property (strong, nonatomic) CAShapeLayer *sectorHighlight;

@property (nonatomic, strong) NSMutableDictionary *selectedItems;

- (void)loadDefault;

- (UILabel *)descriptionLabelForItemAtIndex:(NSUInteger)index;
- (PNPieChartDataItem *)dataItemForIndex:(NSUInteger)index;
- (CGFloat)startPercentageForItemAtIndex:(NSUInteger)index;
- (CGFloat)endPercentageForItemAtIndex:(NSUInteger)index;
- (CGFloat)ratioForItemAtIndex:(NSUInteger)index;

- (CAShapeLayer *)newCircleLayerWithRadius:(CGFloat)radius
                               borderWidth:(CGFloat)borderWidth
                                 fillColor:(UIColor *)fillColor
                               borderColor:(UIColor *)borderColor
                           startPercentage:(CGFloat)startPercentage
                             endPercentage:(CGFloat)endPercentage;

@end

@implementation PNPieChart

-(id)initWithFrame:(CGRect)frame items:(NSArray *)items {
    if(self = [self initWithFrame:frame]) {
        _items = [NSArray arrayWithArray:items];
        [self baseInit];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self baseInit];
}

- (void)baseInit {
    _selectedItems = [NSMutableDictionary dictionary];
    _outerCircleRadius  = CGRectGetWidth(self.bounds) / 2;
    _innerCircleRadius  = 0;
    _descriptionTextColor = [UIColor whiteColor];
    _descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _descriptionTextShadowColor  = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    _descriptionTextShadowOffset =  CGSizeMake(0, 1);
    _duration = 1.0;
    _shouldHighlightSectorOnTouch = YES;
    _enableMultipleSelection = NO;
    _hideValues = NO;
    _hideValuesAndNames = NO;
    _isShowHalo = YES;
    
    [super setupDefaultValues];
    [self loadDefault];
}

- (void)loadDefault {
    __block CGFloat currentTotal = 0;
    CGFloat total = [[self.items valueForKeyPath:@"@sum.value"] floatValue];
    NSMutableArray *endPercentages = [NSMutableArray new];
    [_items enumerateObjectsUsingBlock:^(PNPieChartDataItem *item, NSUInteger idx, BOOL *stop) {
        if (total == 0) {
            [endPercentages addObject:@(1.0 / _items.count * (idx + 1))];
        } else {
            currentTotal += item.value;
            [endPercentages addObject:@(currentTotal / total)];
        }
    }];
    self.endPercentages = [endPercentages copy];
    
    [_contentView removeFromSuperview];
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_contentView];
    _descriptionLabels = [NSMutableArray new];
    
    _pieLayer = [CAShapeLayer layer];
    [_contentView.layer addSublayer:_pieLayer];

}

/** Override this to change how inner attributes are computed. **/
- (void)recompute {
    self.outerCircleRadius = CGRectGetWidth(self.bounds) / 2;
    
    if (self.innerCircleRadius == 0) {
        self.innerCircleRadius = CGRectGetWidth(self.bounds) / 6;
    }
}

#pragma mark -

- (void)strokeChart {
    [self loadDefault];
    [self recompute];
    
    PNPieChartDataItem *currentItem;
    for (int i = 0; i < _items.count; i++) {
        currentItem = [self dataItemForIndex:i];
        
        CGFloat startPercentage = [self startPercentageForItemAtIndex:i];
        CGFloat endPercentage   = [self endPercentageForItemAtIndex:i];
        
        CGFloat radius = _innerCircleRadius + (_outerCircleRadius - _innerCircleRadius) / 2;
        CGFloat borderWidth = _outerCircleRadius - _innerCircleRadius;
        
        CAShapeLayer *currentPieLayer =	[self newCircleLayerWithRadius:radius
                                                           borderWidth:borderWidth
                                                             fillColor:[UIColor clearColor]
                                                           borderColor:currentItem.color
                                                       startPercentage:startPercentage
                                                         endPercentage:endPercentage];
        [_pieLayer addSublayer:currentPieLayer];
    }
    
    [self maskChart];
    
    for (int i = 0; i < _items.count; i++) {
        UILabel *descriptionLabel =  [self descriptionLabelForItemAtIndex:i];
        [_contentView addSubview:descriptionLabel];
        [_descriptionLabels addObject:descriptionLabel];
    }
    
    [self addShowHaloView];
    
    [self addAnimationIfNeeded];
}

// 内圈的光晕
- (void) addShowHaloView {
    if (_isShowHalo) {
        CAShapeLayer *showHaloCircle = [CAShapeLayer layer];
        CGPoint center = CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds));
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                            radius:_innerCircleRadius
                                                        startAngle:0
                                                          endAngle:M_PI * 2
                                                         clockwise:YES];
        showHaloCircle.strokeColor = UIColorFromRGBA(0xFFFFFF, 0.5).CGColor;
        showHaloCircle.strokeStart = 0;
        showHaloCircle.strokeEnd   = 1;
        showHaloCircle.lineWidth   = 8;
        showHaloCircle.path        = path.CGPath;
        
        [_pieLayer addSublayer:showHaloCircle];
    }
}

- (UIView *) getInnerContentView {
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds));
    CGFloat ivHeight = 30;
    CGFloat ivWidth = sqrt(_innerCircleRadius * _innerCircleRadius - (ivHeight/2) * (ivHeight/2)) * 2 + 6;
    CGFloat icX = center.x - ivWidth / 2;
    CGFloat icY = center.y - ivHeight / 2;
    
    CGRect frame = CGRectMake(icX, icY, ivWidth, ivHeight);
    UIView *innerView = [[UIView alloc] initWithFrame:frame];
    innerView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:innerView];
    
    return innerView;
}

- (UILabel *)descriptionLabelForItemAtIndex:(NSUInteger)index{
    PNPieChartDataItem *currentDataItem = [self dataItemForIndex:index];
    CGFloat distance = _innerCircleRadius + (_outerCircleRadius - _innerCircleRadius) / 2;
    CGFloat centerPercentage = ([self startPercentageForItemAtIndex:index] + [self endPercentageForItemAtIndex:index])/ 2;
    CGFloat rad = centerPercentage * 2 * M_PI;
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
    NSString *titleText = currentDataItem.textDescription;
    
    NSString *titleValue;
    
    if (self.showAbsoluteValues) {
        titleValue = [NSString stringWithFormat:@"%.1f",currentDataItem.value];
    }else{
        titleValue = [NSString stringWithFormat:@"%.1f%%",[self ratioForItemAtIndex:index] * 100];
    }
    
    if (self.hideValuesAndNames) {
        descriptionLabel.text = @"";
    } else {
        if (self.hideValues) {
            descriptionLabel.text = titleText;
        } else if(!titleText || self.showOnlyValues) {
            CGFloat total = [[self.items valueForKeyPath:@"@sum.value"] floatValue];
            if (total == 0) {
                descriptionLabel.text = @"0%";
            } else {
                descriptionLabel.text = titleValue;
            }
        } else {
            NSString* str = [titleValue stringByAppendingString:[NSString stringWithFormat:@"\n%@",titleText]];
            descriptionLabel.text = str ;
        }
    }
    
    //If value is less than cutoff, show no label
    if ([self ratioForItemAtIndex:index] < self.labelPercentageCutoff) {
        descriptionLabel.text = nil;
    }
    
    CGPoint center = CGPointMake(_outerCircleRadius + distance * sin(rad),
                                 _outerCircleRadius - distance * cos(rad));
    
    descriptionLabel.font = _descriptionTextFont;
    CGSize labelSize = [descriptionLabel.text sizeWithAttributes:@{NSFontAttributeName:descriptionLabel.font}];
    descriptionLabel.frame = CGRectMake(descriptionLabel.frame.origin.x, descriptionLabel.frame.origin.y,
                                        descriptionLabel.frame.size.width, labelSize.height);
    descriptionLabel.numberOfLines   = 0;
    descriptionLabel.textColor       = _descriptionTextColor;
    descriptionLabel.shadowColor     = _descriptionTextShadowColor;
    descriptionLabel.shadowOffset    = _descriptionTextShadowOffset;
    descriptionLabel.textAlignment   = NSTextAlignmentCenter;
    descriptionLabel.center          = center;
    descriptionLabel.alpha           = 0;
    descriptionLabel.backgroundColor = [UIColor clearColor];
    return descriptionLabel;
}

- (void)updateChartData:(NSArray *)items {
    self.items = items;
}

- (PNPieChartDataItem *)dataItemForIndex:(NSUInteger)index{
    return self.items[index];
}

- (CGFloat)startPercentageForItemAtIndex:(NSUInteger)index{
    if(index == 0){
        return 0;
    }
    
    return [_endPercentages[index - 1] floatValue];
}

- (CGFloat)endPercentageForItemAtIndex:(NSUInteger)index {
    return [_endPercentages[index] floatValue];
}

- (CGFloat)ratioForItemAtIndex:(NSUInteger)index{
    return [self endPercentageForItemAtIndex:index] - [self startPercentageForItemAtIndex:index];
}

#pragma mark private methods

- (CAShapeLayer *)newCircleLayerWithRadius:(CGFloat)radius
                               borderWidth:(CGFloat)borderWidth
                                 fillColor:(UIColor *)fillColor
                               borderColor:(UIColor *)borderColor
                           startPercentage:(CGFloat)startPercentage
                             endPercentage:(CGFloat)endPercentage {
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:-M_PI_2
                                                      endAngle:M_PI_2 * 3
                                                     clockwise:YES];
    
    circle.fillColor   = fillColor.CGColor;
    circle.strokeColor = borderColor.CGColor;
    circle.strokeStart = startPercentage;
    circle.strokeEnd   = endPercentage-0.008;
    circle.lineWidth   = borderWidth;
    circle.path        = path.CGPath;
    
    return circle;
}

- (void)maskChart{
    CGFloat radius = _innerCircleRadius + (_outerCircleRadius - _innerCircleRadius) / 2;
    CGFloat borderWidth = _outerCircleRadius - _innerCircleRadius;
    CAShapeLayer *maskLayer = [self newCircleLayerWithRadius:radius
                                                 borderWidth:borderWidth
                                                   fillColor:[UIColor clearColor]
                                                 borderColor:[UIColor blackColor]
                                             startPercentage:0
                                               endPercentage:1];
    
    _pieLayer.mask = maskLayer;
}

- (void)addAnimationIfNeeded {
    if (self.displayAnimated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration  = _duration;
        animation.fromValue = @0;
        animation.toValue   = @1;
        animation.delegate  = self;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.removedOnCompletion = YES;
        [_pieLayer.mask addAnimation:animation forKey:@"circleAnimation"];
    } else {
        // Add description labels since no animation is required
        [_descriptionLabels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj setAlpha:1];
        }];
    }
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [_descriptionLabels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [UIView animateWithDuration:0.2 animations:^(){
            [obj setAlpha:1];
        }];
    }];
}

- (void)didTouchAt:(CGPoint)touchLocation {
    CGPoint circleCenter = CGPointMake(_contentView.bounds.size.width/2, _contentView.bounds.size.height/2);
    
    CGFloat distanceFromCenter = sqrtf(powf((touchLocation.y - circleCenter.y),2) + powf((touchLocation.x - circleCenter.x),2));
    
    if (distanceFromCenter < _innerCircleRadius) {
        if ([self.delegate respondsToSelector:@selector(didUnselectPieItem)]) {
            [self.delegate didUnselectPieItem];
        }
        [self.sectorHighlight removeFromSuperlayer];
        return;
    }
    
    CGFloat percentage = [self findPercentageOfAngleInCircle:circleCenter fromPoint:touchLocation];
    int index = 0;
    while (percentage > [self endPercentageForItemAtIndex:index]) {
        index ++;
    }
    
    if ([self.delegate respondsToSelector:@selector(userClickedOnPieIndexItem:)]) {
        [self.delegate userClickedOnPieIndexItem:index];
    }
    
    if (self.shouldHighlightSectorOnTouch) {
        if (!self.enableMultipleSelection)
        {
            if (self.sectorHighlight)
                [self.sectorHighlight removeFromSuperlayer];
        }
        
        PNPieChartDataItem *currentItem = [self dataItemForIndex:index];
        
        CGFloat red,green,blue,alpha;
        UIColor *old = currentItem.color;
        [old getRed:&red green:&green blue:&blue alpha:&alpha];
        alpha /= 2;
        UIColor *newColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        
        CGFloat startPercentage = [self startPercentageForItemAtIndex:index];
        CGFloat endPercentage   = [self endPercentageForItemAtIndex:index];
        
        self.sectorHighlight = [self newCircleLayerWithRadius:_outerCircleRadius + 5
                                                  borderWidth:10
                                                    fillColor:[UIColor clearColor]
                                                  borderColor:newColor
                                              startPercentage:startPercentage
                                                endPercentage:endPercentage];
        
        if (self.enableMultipleSelection)
        {
            NSString *dictIndex = [NSString stringWithFormat:@"%d", index];
            CAShapeLayer *indexShape = [self.selectedItems valueForKey:dictIndex];
            if (indexShape)
            {
                [indexShape removeFromSuperlayer];
                [self.selectedItems removeObjectForKey:dictIndex];
            }
            else
            {
                [self.selectedItems setObject:self.sectorHighlight forKey:dictIndex];
                [_contentView.layer addSublayer:self.sectorHighlight];
            }
        }
        else
        {
            [_contentView.layer addSublayer:self.sectorHighlight];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInView:_contentView];
        [self didTouchAt:touchLocation];
    }
}

- (CGFloat) findPercentageOfAngleInCircle:(CGPoint)center fromPoint:(CGPoint)reference{
    //Find angle of line Passing In Reference And Center
    CGFloat angleOfLine = atanf((reference.y - center.y) / (reference.x - center.x));
    CGFloat percentage = (angleOfLine + M_PI/2)/(2 * M_PI);
    return (reference.x - center.x) > 0 ? percentage : percentage + .5;
}

- (UIView*) getLegendWithMaxWidth:(CGFloat)mWidth{
    if ([self.items count] < 1) {
        return nil;
    }
    
    /* This is a small circle that refers to the chart data */
    CGFloat legendCircle = 16;
    
    CGFloat hSpacing = 3;
    
    CGFloat beforeLabel = legendCircle + hSpacing;
    
    /* x and y are the coordinates of the starting point of each legend item */
    CGFloat x = 0;
    CGFloat y = 0;
    
    /* accumulated width and height */
    CGFloat totalWidth = 0;
    CGFloat totalHeight = 0;
    
    NSMutableArray *legendViews = [[NSMutableArray alloc] init];
    
    /* Determine the max width of each legend item */
    CGFloat maxLabelWidth;
    if (self.legendStyle == PNLegendItemStyleStacked) {
        maxLabelWidth = mWidth - beforeLabel;
    }else{
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
    
    // 横排时  计算每个label的间距
    CGFloat intervalDistance = 0;
    if (self.legendStyle == PNLegendItemStyleSerial) {
        CGFloat actualLegendWidth = 0;
        for (PNPieChartDataItem *pdata in self.items) {
            /* Expected label size*/
            CGSize labelsize = [PNLineChart sizeOfString:pdata.textDescription
                                               withWidth:maxLabelWidth
                                                    font:self.legendFont ? self.legendFont : [UIFont systemFontOfSize:12.0f]];
            
            actualLegendWidth += (beforeLabel + labelsize.width);
        }
        
        if (self.items.count == 1) {
            intervalDistance = (mWidth - actualLegendWidth) / 2;
            x = intervalDistance;
        } else if (self.items.count == 2) {
            intervalDistance = (mWidth - actualLegendWidth) / 3;
            x = intervalDistance + (intervalDistance-20)/2;
            intervalDistance = 20;
        } else {
            intervalDistance = (mWidth - actualLegendWidth) / (self.items.count+1);
        }
    }
    
    for (PNPieChartDataItem *pdata in self.items) {
        /* Expected label size*/
        CGSize labelsize = [PNLineChart sizeOfString:pdata.textDescription
                                           withWidth:maxLabelWidth
                                                font:self.legendFont ? self.legendFont : [UIFont systemFontOfSize:12.0f]];
        
        if ((rowWidth + labelsize.width + beforeLabel > mWidth) &&
                    (self.legendStyle == PNLegendItemStyleSerial)) {
            rowWidth = 0;
            x = 0;
            y += rowMaxHeight;
            rowMaxHeight = 0;
        }
        
        rowWidth += labelsize.width + beforeLabel;
        totalWidth = self.legendStyle == PNLegendItemStyleSerial ? fmaxf(rowWidth, totalWidth) : fmaxf(totalWidth, labelsize.width + beforeLabel);
        
        if (![pdata.textDescription isEqualToString:@""]) {
            // Add inflexion type
            [legendViews addObject:[self drawInflexion:legendCircle * .6
                                                center:CGPointMake(x + legendCircle / 2, y + singleRowHeight / 2)
                                              andColor:pdata.color]];
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x + beforeLabel, y, labelsize.width, labelsize.height)];
        label.text = pdata.textDescription;
        label.textColor = self.legendFontColor ? self.legendFontColor : [UIColor blackColor];
        label.font = self.legendFont ? self.legendFont : [UIFont systemFontOfSize:12.0f];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        
        rowMaxHeight = fmaxf(rowMaxHeight, labelsize.height);
        x += (self.legendStyle == PNLegendItemStyleStacked ? 0 : labelsize.width + beforeLabel + intervalDistance);
        y += (self.legendStyle == PNLegendItemStyleStacked ? labelsize.height + 5 : 0);
        
        totalHeight = self.legendStyle == PNLegendItemStyleSerial ? fmaxf(totalHeight, rowMaxHeight + y) : totalHeight + labelsize.height;
        [legendViews addObject:label];
        counter ++;
    }
    
    UIView *legend = [[UIView alloc] initWithFrame:CGRectMake(0, 0, totalWidth, totalHeight)];
    
    for (UIView* v in legendViews) {
        [legend addSubview:v];
    }
    return legend;
}


- (UIImageView*)drawInflexion:(CGFloat)size center:(CGPoint)center andColor:(UIColor*)color
{
    //Make the size a little bigger so it includes also border stroke
    CGSize aSize = CGSizeMake(size, size);
    
    UIGraphicsBeginImageContextWithOptions(aSize, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGRect rect = CGRectMake(0, 0, size, size);
    CGContextFillRect(context, rect);
    
    //Finally draw
    CGContextDrawPath(context, kCGPathFill);
    
    //now get the image from the context
    UIImage *squareImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //// Translate origin
    CGFloat originX = center.x - (size) / 2.0;
    CGFloat originY = center.y - (size) / 2.0;
    
    UIImageView *squareImageView = [[UIImageView alloc]initWithImage:squareImage];
    [squareImageView setFrame:CGRectMake(originX, originY, size, size)];
    return squareImageView;
}

/* Redraw the chart on autolayout */
-(void)layoutSubviews {
    [super layoutSubviews];
    [self strokeChart];
}

@end
