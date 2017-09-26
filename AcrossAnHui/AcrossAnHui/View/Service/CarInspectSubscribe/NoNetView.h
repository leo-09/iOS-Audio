//
//  NoNetView.h
//  AcrossAnHui
//
//  Created by ztd on 17/6/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoNetView : UIView{
    void (^refreshListener)();
}

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIButton *btn;

- (void) setTintLabel:(NSString *)content;
- (void) setRequestFailureImageView;

- (void) setRefreshListener:(void (^)())listener;


@end
