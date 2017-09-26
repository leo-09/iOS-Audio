//
//  CPublishInfoView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "PublishRecordView.h"

/**
 发表 问小畅、随手拍 和报路况View
 */
@interface CPublishInfoView : CTXBaseView<UITextViewDelegate> {
    CGFloat recordImageViewHeight;
    CGFloat distance;
    CGFloat widthHieght;
    
    CGFloat topViewHeigh;   // “语音”按钮与“图片”按钮上部的高度
}

@property (nonatomic, retain) NSMutableArray *images;// 选择的图片

@property (nonatomic, assign) int textCount;    // 最多输入字数

@property (nonatomic, retain) TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UITextView *textView;         // 输入内容
@property (nonatomic, retain) UILabel *hintLabel;           // 提示信息
@property (nonatomic, retain) UILabel *countLabel;          // 计数器
@property (nonatomic, retain) UIView *addrView;             // 当前位置
@property (nonatomic, retain) UIButton *addressBtn;         // 当前地址
@property (nonatomic, retain) UIButton *labelBtn;           // 标签
@property (nonatomic, retain) UIButton *recordBtn;          // 录音
@property (nonatomic, retain) UIButton *imageBtn;           // 选择图片
@property (nonatomic, retain) UIView *recordImageView;      // 存放录音/图片的view

@property (nonatomic, retain) UIImage *defaultImage;        // 默认添加的图片

@property (nonatomic, retain) PublishRecordView *recordView;    // 语音识别View

@property (nonatomic, copy) ClickListener addLabelListener;
@property (nonatomic, copy) ClickListener addAddressListener;
@property (nonatomic, copy) ClickListener addImageListener;     // 添加图片
@property (nonatomic, copy) ClickListener addRecordListener;    // 语音识别
@property (nonatomic, copy) ClickListener cancelRecordListener; // 取消语音识别
@property (nonatomic, copy) SelectCellModelListener previewImageListener;   // 图片预览

// 设置内容
- (void) setTextViewContent:(NSString *)text;

// 设置提示
- (void) setTextViewPlaceholder:(NSString *) hint;

// 设置当前位置
- (void) setCurrentAddress:(NSString *) address;

// 设置标签
- (void) setLabelText:(NSString *)text;

// 问小畅 没有标签
- (void) setLabelHide;

// 添加选择的图片
- (void) addRecordImage:(NSArray *)images;
// 删除选择的图片
- (void) deleteRecordImage:(UIImage *)image;

// 取消录音
- (void) cancelRecord;

@end
