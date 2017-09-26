//
//  HomeRightBarButtonItem.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "HomeRightBarButtonItem.h"

@interface HomeRightBarButtonItem()

@property (nonatomic, retain) UILabel *label;

@end

@implementation HomeRightBarButtonItem

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msgCenter"]];
        CGFloat wh = 20;
        iv.frame = CGRectMake((self.frame.size.width - wh) / 2, (self.frame.size.height - wh) / 2, wh, wh);
        [self addSubview:iv];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 20, 0, 20, 20)];
        _label.textColor = [UIColor whiteColor];
        _label.backgroundColor = [UIColor redColor];
        CTXViewBorderRadius(_label, 10, 0, [UIColor clearColor]);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:12.0];
        _label.hidden = YES;
        [self addSubview:_label];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:gesture];
    }
    
    return self;
}

- (void) tapGesture {
    if (self.clickListener) {
        self.clickListener();
    }
}

- (void) setMsgCount:(int)count {
    if (count > 0) {
        self.label.hidden = NO;
        self.label.text = [NSString stringWithFormat:@"%d", count];
    } else {
        self.label.hidden = YES;
    }
}

@end
