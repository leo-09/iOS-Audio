//
//  CCarFriendCommentView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/3.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "TPKeyboardAvoidingScrollView.h"

/**
 问小畅、随手拍详情的评论 View
 */
@interface CCarFriendCommentView : CTXBaseView<CAAnimationDelegate, UITextViewDelegate>

@property (nonatomic, retain) TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, retain) UIView *bgView;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UILabel *hintLabel;

@property (nonatomic, copy) SelectCellModelListener submitCommentListener;

// 显示View
- (void) showView;
// 清空 输入的评论内容
- (void) clearCommentContent;

@end
