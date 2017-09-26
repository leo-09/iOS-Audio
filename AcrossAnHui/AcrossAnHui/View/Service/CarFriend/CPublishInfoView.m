//
//  CPublishInfoView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CPublishInfoView.h"
#import "KLCDTextHelper.h"

@implementation CPublishInfoView

- (instancetype) init {
    if (self = [super init]) {
        
        distance = 12;
        widthHieght = (CTXScreenWidth - 4 * distance) / 3;
        _images = [[NSMutableArray alloc] init];
        
        self.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        
        _scrollView = [[TPKeyboardAvoidingScrollView alloc] init];
        [self addSubview:_scrollView];
        [_scrollView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [_scrollView addSubview:_contentView];
        [_contentView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_scrollView);
            make.width.equalTo(CTXScreenWidth);
        }];
        
        [self addItemView];
        
        [_contentView updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_recordImageView.bottom);
        }];
        
        // 默认显示添加图片按钮
        [self photo];
    }
    
    return self;
}

// 添加view的内容
- (void) addItemView {
    // textView
    _textView = [[UITextView alloc] init];
    _textView.delegate = self;
    _textView.textColor = UIColorFromRGB(CTXTextBlackColor);
    _textView.font = [UIFont systemFontOfSize:CTXTextFont];
    _textView.backgroundColor = [UIColor whiteColor];
    CTXViewBorderRadius(_textView, 3.0, 0.8, UIColorFromRGB(CTXBLineViewColor));
    [_contentView addSubview:_textView];
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.left.equalTo(@12);
        make.right.equalTo(@(-12));
        make.height.equalTo(CTXScreenHeight * 200.0 / 640.0);
    }];
    
    // hintLabel
    _hintLabel = [[UILabel alloc] init];
    _hintLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    _hintLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
    [_contentView addSubview:_hintLabel];
    [_hintLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_textView.left).offset(@6);
        make.right.equalTo(_textView.right).offset(@(-5));
        make.top.equalTo(_textView.top).offset(@8);
    }];
    
    // countLabel
    _countLabel = [[UILabel alloc] init];
    _countLabel.text = @"0 / 200";
    _countLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    _countLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
    [_contentView addSubview:_countLabel];
    [_countLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-12));
        make.top.equalTo(_textView.bottom).offset(12);
    }];
    
    // 当前位置
    _addrView = [[UIView alloc] init];
    _addrView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_addrView];
    [_addrView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_countLabel.bottom).offset(12);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@50);
    }];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more"]];
    [_addrView addSubview:iv];
    [iv makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_addrView.centerY);
        make.right.equalTo(@(-12));
        make.width.equalTo(@6);
    }];
    
    // addressBtn
    _addressBtn = [[UIButton alloc] init];
    _addressBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [_addressBtn setImage:[UIImage imageNamed:@"drawable_dw"] forState:UIControlStateNormal];
    [_addressBtn setTitle:@" 定位中..." forState:UIControlStateNormal];
    [_addressBtn setTitleColor:UIColorFromRGB(CTXThemeColor) forState:UIControlStateNormal];
    _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_addressBtn addTarget:self action:@selector(selectAddress) forControlEvents:UIControlEventTouchDown];
    [_addrView addSubview:_addressBtn];
    [_addressBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.right.equalTo(iv.left).offset(-4);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    // 标签
    _labelBtn = [[UIButton alloc] init];
    _labelBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [_labelBtn setTitle:@"添加标签+" forState:UIControlStateNormal];
    [_labelBtn setTitleColor:UIColorFromRGB(CTXTextBlackColor) forState:UIControlStateNormal];
    CTXViewBorderRadius(_labelBtn, 18, 0.8, UIColorFromRGB(CTXBLineViewColor));
    [_labelBtn addTarget:self action:@selector(addLabel) forControlEvents:UIControlEventTouchDown];
    
    CGFloat width = [KLCDTextHelper WidthForText:@"添加标签+" withFontSize:15.0 withTextHeight:50] + 30;
    [_contentView addSubview:_labelBtn];
    [_labelBtn makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@36);
        make.width.equalTo(width);
        make.left.equalTo(@12);
        make.top.equalTo(_addrView.bottom).offset(12);
    }];
    
    // 录音／图片
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:view];
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(_labelBtn.bottom).offset(12);
        make.height.equalTo(@55);
    }];
    
    // 录音
    _recordBtn = [[UIButton alloc] init];
    [_recordBtn setImage:[UIImage imageNamed:@"drawable_yy"] forState:UIControlStateNormal];
    [_recordBtn setImage:[UIImage imageNamed:@"iconfont_djly"] forState:UIControlStateSelected];
    [_recordBtn addTarget:self action:@selector(record) forControlEvents:UIControlEventTouchDown];
    [view addSubview:_recordBtn];
    [_recordBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.right.equalTo(view.centerX).offset(-20);
    }];
    
    // 选择图片
    _imageBtn = [[UIButton alloc] init];
    [_imageBtn setImage:[UIImage imageNamed:@"drawable_tp"] forState:UIControlStateNormal];
    [_imageBtn setImage:[UIImage imageNamed:@"drawable_xc"] forState:UIControlStateSelected];
    [_imageBtn addTarget:self action:@selector(photo) forControlEvents:UIControlEventTouchDown];
    _imageBtn.selected = NO;
    [view addSubview:_imageBtn];
    [_imageBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.left.equalTo(view.centerX).offset(20);
    }];
    
    // recordImageView
    topViewHeigh = 12 + CTXScreenHeight * 200.0 / 640.0 + 8 + 18 + 12 + 50 + 12 + 36 + 12;
    recordImageViewHeight = CTXScreenHeight - CTXNavigationBarHeight - CTXBarHeight - topViewHeigh - 55 + 1;
    _recordImageView = [[UIView alloc] init];
    _recordImageView.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:_recordImageView];
    [_recordImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.right.equalTo(@(-12));
        make.top.equalTo(view.bottom).offset(12);
        make.height.equalTo(recordImageViewHeight);
    }];
}

// 显示语音识别的View
- (void) addRecordView {
    if (!_recordView) {
        _recordView = [[PublishRecordView alloc] init];
        
        @weakify(self)
        [_recordView setHideViewListener:^ {
            @strongify(self)
            
            self.recordBtn.selected = NO;
            
            if (self.cancelRecordListener) {
                self.cancelRecordListener();
            }
        }];
    }
    
    [_recordView showViewWithTopHeight:topViewHeigh];
    
    if (self.addRecordListener) {
        self.addRecordListener();
    }
}

#pragma mark - getter/setter

- (UIImage *) defaultImage {
    if (!_defaultImage) {
        _defaultImage = [UIImage imageNamed:@"default_add"];
    }
    
    return _defaultImage;
}

#pragma mark - event response

// 选择地址
- (void) selectAddress {
    [self.textView resignFirstResponder];
    
    if (self.addAddressListener) {
        self.addAddressListener();
    }
}

// 添加标签
- (void) addLabel {
    [self.textView resignFirstResponder];
    if (self.addLabelListener) {
        self.addLabelListener();
    }
}

// 语音识别
- (void) record {
    [self.textView resignFirstResponder];
    
    _recordBtn.selected = !_recordBtn.selected;
    if (_recordBtn.selected) {
        [self addRecordView];
    }
}

// 选择照片
- (void) photo {
    [self.textView resignFirstResponder];
    
    // 已经选择图片了，则不允许隐藏
    if (_images.count > 0) {
        _imageBtn.selected = YES;
        
        return;
    }
    
    _imageBtn.selected = !_imageBtn.selected;
    
    if (_imageBtn.isSelected) {
        [self addRecordImage:@[]];
        [self addRecordImage];
    } else {
        [_recordImageView removeAllSubviews];
    }
}

// 图片预览
- (void) previewImage:(UIButton *)btn {
    [self.textView resignFirstResponder];
    
    int i = (int)btn.tag;
    if (i < _images.count) {
        UIImage *image = _images[(int)btn.tag];
        if (self.previewImageListener) {
            self.previewImageListener(image);
        }
    } else {
        if (self.addImageListener) {
            self.addImageListener();
        }
    }
}

#pragma mark - public method

- (void) setTextCount:(int)textCount {
    _textCount = textCount;
    
    _countLabel.text = [NSString stringWithFormat:@"0 / %d", _textCount];
}

// 设置内容
- (void) setTextViewContent:(NSString *)text {
    NSString *content = self.textView.text;
    NSString *newContent = [NSString stringWithFormat:@"%@%@", content, text];
    self.textView.text = newContent;
    
    [self textViewDidChange:self.textView];
}

// 设置提示
- (void) setTextViewPlaceholder:(NSString *) hint {
    _hintLabel.text = (hint ? hint : @"");
}

// 设置当前位置
- (void) setCurrentAddress:(NSString *) address {
    NSString *title = [NSString stringWithFormat:@" %@", (address ? address : @"")];
    [_addressBtn setTitle:title forState:UIControlStateNormal];
}

// 设置标签
- (void) setLabelText:(NSString *)text {
    _labelBtn.backgroundColor = UIColorFromRGB(CTXThemeColor);
    [_labelBtn setTitle:text forState:UIControlStateNormal];
    [_labelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CTXViewBorderRadius(_labelBtn, 18, 0, [UIColor clearColor]);
    
    CGFloat width = [KLCDTextHelper WidthForText:text withFontSize:15.0 withTextHeight:50] + 30;
    [_labelBtn updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(width);
    }];
}

- (void) setLabelHide {
    [_labelBtn updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addrView.bottom);
        make.height.equalTo(@0);
    }];
    
    // 没有标签，则更新topViewHeigh
    topViewHeigh = 12 + CTXScreenHeight * 200.0 / 640.0 + 8 + 18 + 12 + 50 + 12;
    recordImageViewHeight = CTXScreenHeight - CTXNavigationBarHeight - CTXBarHeight - topViewHeigh - 55 + 1;
    
    [_recordImageView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(recordImageViewHeight);
    }];
    
    [self setNeedsLayout];
}

- (void) cancelRecord {
    _recordBtn.selected = NO;
    if (_recordView) {
        [_recordView hideView];
    }
}

- (void) deleteRecordImage:(UIImage *)image {
    // 删除image
    [_images removeObject:image];
    
    [self updateHeight];
    
    // 显示图片
    [self addRecordImage];
}

- (void) addRecordImage:(NSArray *)images {
    [_images addObjectsFromArray:images];
    
    // 最多支持9张图片
    while (_images.count > 9) {
        [_images removeLastObject];
    }
    
    [self updateHeight];
    
    // 显示图片
    [self addRecordImage];
}

// 更新高度
- (void) updateHeight {
    // 计算最新高度
    int lineNum = (int)(_images.count / 3 + ((_images.count % 3) == 0 ? 0 : 1));   // 行数
    
    // 只有1行／2行时，还要显示添加图片的按钮
    if ((_images.count == 3) || (_images.count == 6)) {
        lineNum++;
    }
    
    CGFloat height = lineNum * (widthHieght + distance);                    // 高度
    if (height < recordImageViewHeight) {                                   // 高度至少recordImageViewHeight
        height = recordImageViewHeight;
    }
    
    // 更新高度
    [_recordImageView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
    [_contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_recordImageView.bottom);
    }];
}

- (void) addRecordImage {
    [_recordImageView removeAllSubviews];
    
    NSMutableArray *tempImages = [[NSMutableArray alloc] init];
    [tempImages addObjectsFromArray:_images];
    
    if (tempImages.count < 9) {
        [tempImages addObject:self.defaultImage];
    }
    
    for (int i = 0; i < tempImages.count; i++) {
        UIImage *image = tempImages[i];
        
        int line = i / 3;
        int column = i % 3;
        
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        [btn setImage:image forState:UIControlStateNormal];
        [btn setTarget:self action:@selector(previewImage:) forControlEvents:UIControlEventTouchDown];
        [_recordImageView addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(column * (widthHieght + distance));
            make.top.equalTo(line * (widthHieght + distance));
            make.width.equalTo(widthHieght);
            make.height.equalTo(widthHieght);
        }];
        
        if (i == (tempImages.count - 1)) {
            // 没有9张图片，则标志最后一张图
            if (i == _images.count) {
                CTXViewBorderRadius(btn, 0, 0.8, UIColorFromRGB(CTXBLineViewColor));
            }
        }
    }
}

#pragma mark - UITextViewDelegate

// 有输入时触但对于中文键盘出示的联想字选择时不会触发
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0]; //获取高亮部分
//    NSString * selectedtext = [textView textInRange:selectedRange];//获取高亮部分内容
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < self.textCount) {
            return YES;
        } else {
            return NO;
        }
    }
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = self.textCount - comcatstr.length;
    
    if (caninputlen >= 0) {
        return YES;
    } else {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0) {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            // 既然是超出部分截取了，哪一定是最大限制了。
            _countLabel.text = [NSString stringWithFormat:@"%d / %d", self.textCount, self.textCount];
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
        self.hintLabel.hidden = YES;
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > self.textCount) {
        existTextNum = self.textCount;
        //截取到最大位置的字符
        NSString *content = [nsTextContent substringToIndex:self.textCount];
        
        [textView setText:content];
    }
    
    if (existTextNum > 0) {
        self.hintLabel.hidden = YES;
    } else {
        self.hintLabel.hidden = NO;
    }
    
    _countLabel.text = [NSString stringWithFormat:@"%ld / %d", (long)existTextNum, self.textCount];
}

@end
