//
//  PickerSelectorView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "PickerSelectorView.h"
#import "AppDelegate.h"

@implementation PickerSelectorView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
        
        [self addItemView];
    }
    
    return self;
}

- (void) addItemView {
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 6.0;
    [self addSubview:_bgView];
    [_bgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@50);
        make.right.equalTo(-50);
        make.height.equalTo(@320);
        make.centerY.equalTo(self.centerY);
    }];
    
    _cancleBtn = [[UIButton alloc] init];
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [_cancleBtn setTitleColor:UIColorFromRGB(CTXTextBlackColor) forState:UIControlStateNormal];
    [_cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchDown];
    [_bgView addSubview:_cancleBtn];
    [_cancleBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.width.equalTo(@80);
        make.height.equalTo(@50);
    }];
    
    _submitBtn = [[UIButton alloc] init];
    [_submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    _submitBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [_submitBtn setTitleColor:UIColorFromRGB(CTXTextBlackColor) forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchDown];
    [_bgView addSubview:_submitBtn];
    [_submitBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.width.equalTo(@80);
        make.height.equalTo(@50);
    }];
    
    // 线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
    [_bgView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.bottom.equalTo(_submitBtn.bottom);
        make.height.equalTo(@1);
    }];
    
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.showsSelectionIndicator=YES;
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [_bgView addSubview:_pickerView];
    [_pickerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(lineView.bottom);
        make.bottom.equalTo(-10);
        make.right.equalTo(@0);
    }];
}

#pragma mark - event response

- (void) cancle {
    [self hideAnimation];
}

- (void) submit {
    // 返回的参数是一个数组
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (int i = 0; i < _dataSource.count; i++) {
        NSArray *rowArray = _dataSource[i];
        int selectedRow = (int)[_pickerView selectedRowInComponent:i];
        
        [results addObject:rowArray[selectedRow]];
    }
    
    if (self.selectorResultListener) {
        self.selectorResultListener(results);
    }
    
    [self hideAnimation];
}

#pragma mark - getter/setter

- (void) setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.pickerView reloadAllComponents];
}

// 设置默认的值
- (void) setCurrentValue:(NSArray *)currentValue {
    _currentValue = currentValue;
    
    if (!_currentValue || _currentValue.count == 0) {
        // 默认跳转到中间位置
        for (int i = 0; i < _dataSource.count; i++) {
            NSArray *arr = _dataSource[i];
            [_pickerView selectRow:(arr.count / 2) inComponent:i animated:NO];
        }
        
        return;
    }
    
    for (int i = 0; i < _currentValue.count; i++) {
        NSString *value = _currentValue[i];
        
        // 数组不能越界
        if (_dataSource.count > i) {
            NSArray *arr = _dataSource[i];
            
            // 找出选择的值
            for (int row = 0; row < arr.count; row++) {
                NSString *rowValue = arr[row];
                if ([rowValue containsString:value]) {
                    [_pickerView selectRow:row inComponent:i animated:NO];
                    break;
                }
            }
        }
    }
}

- (void) setCancleBtnTitle:(NSString *)cancleBtnTitle {
    [self.cancleBtn setTitle:cancleBtnTitle forState:UIControlStateNormal];
}

- (void) setSubmitBtnTitle:(NSString *)submitBtnTitle {
    [self.submitBtn setTitle:submitBtnTitle forState:UIControlStateNormal];
}

#pragma mark - UIPickerViewDataSource

// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _dataSource.count;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_dataSource[component] count];
}

#pragma mark - UIPickerViewDelegate

// 返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *rowArray = _dataSource[component];
    return rowArray[row];
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return (CTXScreenWidth - 100) / _dataSource.count;
}

#pragma mark - public method

- (void) showView {
    UIWindow *window = [AppDelegate sharedDelegate].window;
    [window addSubview:self];
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    [self showAnimation];
}

#pragma mark - 动画

- (void) hideAnimation {
    if (self.bgView.isHidden) {
        return;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    animation.duration = 0.2; // 持续时间
    animation.delegate = self;
    // 起始帧和终了帧的设定
    animation.fromValue = [NSValue valueWithCGPoint:self.bgView.center];
    
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bgView.center.x, self.bgView.center.y + CTXScreenHeight)];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.bgView.layer removeAllAnimations];
    [self.bgView.layer addAnimation:animation forKey:@"hide-layer"];
}

- (void) showAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    animation.duration = 0.3;
    animation.delegate = self;
    // 起始帧和终了帧的设定
    CGPoint center = [AppDelegate sharedDelegate].window.center;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(center.x, center.y + CTXScreenHeight / 2)];
    animation.toValue = [NSValue valueWithCGPoint:center];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.bgView.layer removeAllAnimations];
    [self.bgView.layer addAnimation:animation forKey:@"show-layer"];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim.duration == 0.2) {
        [self removeFromSuperview];
    }
}

@end
