//
//  PublishRecordView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/8.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"

/**
 发表 问小畅、随手拍 和报路况View的录音
 */
@interface PublishRecordView : CTXBaseView<CAAnimationDelegate> {
    CGFloat contentViewHeight;
}

@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *label;

@property (nonatomic, copy) ClickListener hideViewListener;

- (void) showViewWithTopHeight:(CGFloat)height;
- (void) hideView;

@end
