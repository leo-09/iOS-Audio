//
//  MapOperationView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/1.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "MapOperationView.h"

@implementation MapOperationView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        btnArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) setNormalImages:(NSArray *)normalImages selectedImages:(NSArray *)selectedImages {
    UIButton *lastBtn;
    
    for (int i = 0; i < normalImages.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        [btn setImage:[UIImage imageNamed:normalImages[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectedImages[i]] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(dealEvent:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@42);
            make.height.equalTo(@42);
            make.left.equalTo(@0);
            if (lastBtn) {
                make.top.equalTo(lastBtn.bottom).offset(@15);
            } else {
                make.top.equalTo(@15);
            }
        }];
        
        [btnArray addObject:btn];
        lastBtn = btn;
    }
}

#pragma mark - event response

- (void) dealEvent:(UIButton *)btn {
    if (currentBtn && currentBtn == btn && currentBtn.selected) {
        return;
    }
    
    if (currentBtn) {
        currentBtn.selected = NO;
    }
    currentBtn = btn;
    currentBtn.selected = YES;
    
    if (self.clickButtonListener) {
        self.clickButtonListener((int)btn.tag);
    }
}

- (void) clickButtonWithIndex:(int)index {
    if (currentBtn != btnArray[index]) {
        [self dealEvent:btnArray[index]];
    }
}

- (void) deSelectedCurrentBtn {
    if (currentBtn) {
        currentBtn.selected = !currentBtn.selected;
    }
}

@end
