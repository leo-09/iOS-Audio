//
//  FeedBackViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/9.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import "CTXSegmentedPageViewControllerDelegate.h"
#import "MineNetData.h"

/**
 意见反馈
 */
@interface FeedBackViewController : CTXBaseViewController<UITextViewDelegate, CTXSegmentedPageViewControllerDelegate>

@property (nonatomic, retain) MineNetData *mineNetData;

@property(nonatomic,strong) NSString *viewTitle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *tintLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

- (instancetype) initWithStoryboard;

@end
