//
//  FeedBackViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/9.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "FeedBackViewController.h"
#import "TextViewContentTool.h"

// 限制最大输入字符数
#define MAX_LIMIT_NUMS 100

@implementation FeedBackViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"FeedBackViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"意见反馈";
    CTXViewBorderRadius(_submitBtn, 5.0, 0, [UIColor clearColor]);
    self.textView.delegate = self;
    self.contentViewHeightConstraint.constant = CTXScreenHeight - 64 + 1;
    
    self.mineNetData = [[MineNetData alloc] init];
    self.mineNetData.delegate = self;
}

- (IBAction)submit:(id)sender {
    [self.textView resignFirstResponder];
    
    NSString *content = [TextViewContentTool isContaintContent:_textView.text];
    if (!content) {
        [self showTextHubWithContent:@"请输入意见内容"];
        return;
    }
    
    [self showHubWithLoadText:@"正在提交反馈意见"];
    [self.mineNetData addFeedBackWithToken:self.loginModel.token content:content tag:@"addFeedBackTag"];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"addFeedBackTag"]) {
        [self showTextHubWithContent:(NSString *)result];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self hideHub];
    [self showTextHubWithContent:tint];
}

#pragma mark - UITextViewDelegate

// 有输入时触但对于中文键盘出示的联想字选择时不会触发
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0]; //获取高亮部分
//    NSString * selectedtext = [textView textInRange:selectedRange];//获取高亮部分内容
    
    // 如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        } else {
            return NO;
        }
    }
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0) {
        return YES;
    } else {
        NSInteger len = text.length + caninputlen;
        // 防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = { 0, MAX(len, 0) };
        
        if (rg.length > 0) {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            
            // 既然是超出部分截取了，哪一定是最大限制了
            self.countLabel.text = [NSString stringWithFormat:@"%ld／", (unsigned long)textView.text.length];
        }
        
        return NO;
    }
}

// 当输入且上面的代码返回YES时触发。或当选择键盘上的联想字时触发
- (void)textViewDidChange:(UITextView *)textView {
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];//获取高亮部分
    
    // 如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        self.tintLabel.hidden = YES;
        return;
    }
    
    NSString *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS) {
        existTextNum = MAX_LIMIT_NUMS;
        //截取到最大位置的字符
        NSString *content = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:content];
    }
    
    if (existTextNum > 0) {
        self.tintLabel.hidden = YES;
    } else {
        self.tintLabel.hidden = NO;
    }
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld／", (long)existTextNum];
}

#pragma mark - CTXSegmentedPageViewControllerDelegate

- (NSString *)viewControllerTitle {
    return self.viewTitle ? self.viewTitle : self.title;
}

@end
