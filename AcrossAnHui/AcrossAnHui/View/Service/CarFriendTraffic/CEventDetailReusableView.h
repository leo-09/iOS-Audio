//
//  CEventDetailReusableView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CEventDetailReusableView : UICollectionReusableView

//标题
@property(strong, nonatomic) UILabel *nameLabel;
@property(strong, nonatomic) UIView *lineView;

// 隐藏线
- (void) hideLineView;

@end
