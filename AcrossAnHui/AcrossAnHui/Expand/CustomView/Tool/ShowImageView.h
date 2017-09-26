//
//  ShowImageView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/15.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"

/**
  展现图片，如车架号
 */
@interface ShowImageView : CTXBaseView<CAAnimationDelegate>

@property (nonatomic, retain) UIImageView *imageView;

- (void) showViewWithImagePath:(NSString *)path;

@end
