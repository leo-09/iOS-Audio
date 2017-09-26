//
//  PromptView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/24.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "PromptView.h"

@interface PromptView()

@property (nonatomic, retain) UIButton *imageBtn;// weizhaodao,car_mytt,load_failure
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIButton *operationBtn;

@end

@implementation PromptView

- (instancetype) init {
    if (self = [super init]) {
        [self setItemView];
    }
    
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setItemView];
    }
    
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setItemView];
    }
    
    return self;
}

- (void) setItemView {
    self.backgroundColor = [UIColor whiteColor];
    
    if (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
    
    // 图标
    _imageBtn = [[UIButton alloc] init];
    [self addSubview:_imageBtn];
    [_imageBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-30);
    }];
    
    // 描述
    _label = [[UILabel alloc] init];
    _label.font = [UIFont systemFontOfSize:15];
    _label.textColor = CTXColor(108, 108, 108);
    [self addSubview:_label];
    [_label makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_imageBtn.bottom).offset(@20);
    }];
    
    // 按钮
    _operationBtn = [[UIButton alloc] init];
    _operationBtn.backgroundColor = UIColorFromRGB(CTXThemeColor);
    [_operationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _operationBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    CTXViewBorderRadius(_operationBtn, 5, 0, [UIColor clearColor]);
    [_operationBtn addTarget:self action:@selector(operation) forControlEvents:UIControlEventTouchDown];
    _operationBtn.hidden = YES;
    [self addSubview:_operationBtn];
    [_operationBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_label.bottom).offset(@15);
        make.width.equalTo(CTXScreenWidth - 100);
        make.height.equalTo(@40);
    }];
}

#pragma mark - public method

- (void) setNilDataWithImagePath:(NSString *) path tint:(NSString *)tint btnTitle:(NSString *)title isNeedAddData:(BOOL) isAdd {
    if (isAdd) {
        [_imageBtn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchDown];
    } else {
        // 数据为空，则不需要点击图标
        [_imageBtn removeTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchDown];
    }
    
    if (!path || [path isEqualToString:@""]) {
        // 默认值
        [_imageBtn setImage:[UIImage imageNamed:@"car_mytt"] forState:UIControlStateNormal];
    } else {
        [_imageBtn setImage:[UIImage imageNamed:path] forState:UIControlStateNormal];
    }
    
    // 提示信息
    if (tint && ![tint isEqualToString:@""]) {
        _label.text = tint;
        [_label updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
        }];
    } else {
        [_label updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
    
    // nil／@"" 则表示不显示按钮；否则则显示按钮
    if (title && ![title isEqualToString:@""]) {
        _operationBtn.hidden = NO;
        [_operationBtn setTitle:title forState:UIControlStateNormal];
        [_operationBtn addTarget:self action:@selector(operation) forControlEvents:UIControlEventTouchDown];
    } else {
        _operationBtn.hidden = YES;
        [_operationBtn removeTarget:self action:@selector(operation) forControlEvents:UIControlEventTouchDown];
    }
}

- (void) setNilDataWithImagePath:(NSString *) path tint:(NSString *)tint btnTitle:(NSString *)title {
    [self setNilDataWithImagePath:path tint:tint btnTitle:title isNeedAddData:NO];
}

- (void) setRequestFailureWithImagePath:(NSString *) path tint:(NSString *)tint {
    // 提示信息
    if (tint) {
        _label.text = tint;
    }
    
    if (!path || [path isEqualToString:@""]) {
        [_imageBtn setImage:[UIImage imageNamed:@"load_failure"] forState:UIControlStateNormal];
    } else {
        [_imageBtn setImage:[UIImage imageNamed:path] forState:UIControlStateNormal];
    }
    
    // 网络出错，需要点击图标刷新
    [_imageBtn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchDown];
}

- (void) setRequestFailureImageView {
    [self setRequestFailureWithImagePath:@"load_failure" tint:@"网络开小差, 请点击重试"];
}

- (NSString *) getLabelName {
    return self.label.text;
}

#pragma mark - click listener

- (void) refresh {
    if (self.promptRefreshListener) {
        self.promptRefreshListener();
    }
}

- (void) operation {
    if (self.promptOperationListener) {
        self.promptOperationListener();
    }
}

@end
