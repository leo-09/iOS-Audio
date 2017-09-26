//
//  DrivervaluateView.m
//  AcrossAnHui
//
//  Created by ztd on 2017/8/9.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "DrivervaluateView.h"
#import "TextViewContentTool.h"
#import "CWStarRateView.h"
#import "KLCDTextHelper.h"
#import "YYKit.h"

// 限制最大输入字符数
#define MAX_LIMIT_NUMS 200

@interface DrivervaluateView ()<UITextViewDelegate,CWStarRateViewDelegate>{
    UILabel * noteName;
    UILabel * numberLab;
    CWStarRateView *speedCommentView;
    CWStarRateView *serverCommentView;
    UITextView * _textView;
    
    CGFloat newSpeedScorePercent;
    CGFloat newserverScorePercent;
}

@property (nonatomic, retain) TPKeyboardAvoidingScrollView *scrollerView;
@property (nonatomic, retain) UIView *contentView;

@end

@implementation DrivervaluateView

-(instancetype)init {
    if (self = [super init]) {
        _scrollerView = [[TPKeyboardAvoidingScrollView alloc] init];
        _scrollerView.backgroundColor = [UIColor clearColor];
        _scrollerView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollerView];
        [_scrollerView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    return self;
}

-(void)addItemUI {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor clearColor];
    [_scrollerView addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollerView);
        make.width.equalTo(CTXScreenWidth);
    }];

    // 司机头像
    UIImageView * headImg = [[UIImageView alloc]init];
    [headImg setImageWithURL:[NSURL URLWithString:@""] placeholder:[UIImage imageNamed:@"db_head"]];
    [contentView addSubview:headImg];
    
    // 司机姓名
    UILabel * nameLab = [[UILabel alloc]init];
    nameLab.font = [UIFont systemFontOfSize:15];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.text = self.agencyOrderModel.name;
    [contentView addSubview:nameLab];
    
    // 司机身份证
    UILabel *identifyCardLab = [[UILabel alloc] init];
    [contentView addSubview:identifyCardLab];
    identifyCardLab.font = [UIFont systemFontOfSize:15];
    if (!self.agencyOrderModel.idCard){
        identifyCardLab.text = [NSString stringWithFormat:@"身份证号码：%@", @"暂无，不支持评价"];
    } else {
        identifyCardLab.text = [NSString stringWithFormat:@"身份证号码：%@", self.agencyOrderModel.idCard];
    }
    
    // 速度❤️评价 + //态度❤️评价
    UILabel*  speendcommentLab = [[UILabel alloc]init];
    [contentView addSubview:speendcommentLab];
    speendcommentLab.font = [UIFont systemFontOfSize:15];
    speendcommentLab.text = @"接送车速度：";
    
    UILabel*  serverCommentLab = [[UILabel alloc]init];
    [contentView addSubview:serverCommentLab];
    serverCommentLab.font = [UIFont systemFontOfSize:15];
    serverCommentLab.text = @"服务态度：";
    
    CGFloat speenWidth = [KLCDTextHelper WidthForText:@"接送车速度：" withFontSize:15 withTextHeight:15]+5;
    speedCommentView = [[CWStarRateView alloc]initWithFrame:CGRectMake(45+speenWidth+5,64+ 25+66+15+15+15+15+15+15, 100, 15) numberOfStars:5  photostr:@"hong"];;
    speedCommentView.delegate = self;
    speedCommentView.allowIncompleteStar = NO;
    speedCommentView.hasAnimation = YES;
    speedCommentView.tag = 11;
    speedCommentView.scorePercent = 1.0;
    [speedCommentView addGesture];
    [contentView addSubview:speedCommentView];
    
    serverCommentView = [[CWStarRateView alloc]initWithFrame:CGRectMake(45+speenWidth+5, 64+25+66+15+15+15+15+15+30, 100, 15) numberOfStars:5  photostr:@"hong"];
    serverCommentView.delegate = self;
    serverCommentView.allowIncompleteStar = NO;
    serverCommentView.hasAnimation = YES;
    serverCommentView.scorePercent = 1.0;
    [serverCommentView addGesture];
    serverCommentView.tag = 12;
    [contentView addSubview:serverCommentView];
    
    // 评价内容
    UIView *valuateView = [[UIView alloc] init];
    valuateView.backgroundColor = [UIColor whiteColor];
    CTXViewBorderRadius(valuateView, 4.0, 1.0, CTXColor(201, 201, 201));
    [contentView addSubview:valuateView];
    
    _textView = [[UITextView alloc] init];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.delegate = self;
    [valuateView addSubview:_textView];
    
    noteName = [[UILabel alloc]init];
    noteName.font = [UIFont systemFontOfSize:15];
    noteName.text = @"输入想说的话";
    noteName.textColor = CTXColor(108, 108, 108);
    [valuateView addSubview:noteName];
    
    numberLab = [[UILabel alloc]init];
    numberLab.font = [UIFont systemFontOfSize:15];
    numberLab.text = @"0/200";
    numberLab.textColor = CTXColor(108, 108, 108);
    numberLab.textAlignment = NSTextAlignmentRight;
    [valuateView addSubview:numberLab];
    
    // 提交按钮
    UIButton * submitBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    submitBtn.layer.borderColor = CTXColor(3, 163, 214).CGColor;
    submitBtn.layer.borderWidth = 1;
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:CTXColor(3, 163, 214) forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.layer.cornerRadius = 5;
    submitBtn.layer.masksToBounds = YES;
    [contentView addSubview:submitBtn];
    
    // 布局
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@((CTXScreenWidth-66)/2));
        make.width.equalTo(@(66));
        make.top.equalTo(@(25));
        make.height.equalTo(@(66));
    }];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@((CTXScreenWidth-300)/2));
        make.width.equalTo(@(300));
        make.top.equalTo(headImg.mas_bottom).offset(15);
        make.height.equalTo(@(15));
    }];
    
    CGFloat identifyCard_width = [KLCDTextHelper WidthForText:identifyCardLab.text withFontSize:15 withTextHeight:15]+5;
    [identifyCardLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@((CTXScreenWidth-identifyCard_width)/2));
        make.width.equalTo(@(identifyCard_width));
        make.top.equalTo(nameLab.mas_bottom).offset(15);
        make.height.equalTo(@(15));
    }];
    
    [speendcommentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(identifyCardLab.mas_left).offset(0);
        make.width.equalTo(@(speenWidth));
        make.top.equalTo(identifyCardLab.mas_bottom).offset(15);
        make.height.equalTo(@(15));
    }];
    [speedCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(speendcommentLab.mas_right).offset(5);
        make.width.equalTo(@(100));
        make.top.equalTo(identifyCardLab.mas_bottom).offset(15);
        make.height.equalTo(@(15));
    }];
    
    [serverCommentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(identifyCardLab.mas_left).offset(0);
        make.width.equalTo(@(speenWidth));
        make.top.equalTo(speendcommentLab.mas_bottom).offset(15);
        make.height.equalTo(@(15));
    }];
    [serverCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(speendcommentLab.mas_right).offset(5);
        make.width.equalTo(@(100));
        make.top.equalTo(speendcommentLab.mas_bottom).offset(15);
        make.height.equalTo(@(15));
    }];
    
    [valuateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.top.equalTo(serverCommentLab.mas_bottom).offset(15);
        make.height.equalTo(@(150));
    }];
    
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@(130));
    }];
    [noteName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@3);
        make.top.equalTo(@6);
    }];
    
    [numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-4));
        make.bottom.equalTo(@(-2));
    }];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CTXScreenWidth-18-100));
        make.width.equalTo(@(100));
        make.top.equalTo(valuateView.mas_bottom).offset(15);
        make.height.equalTo(@(40));
    }];
    
    // 更新contentView的高---》设置scrollView的ContentSize
    [contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(submitBtn.bottom).offset(CTXScreenHeight - 64 - 431 + 1);
    }];
}

-(void)submitClick {
    if (!self.agencyOrderModel.idCard || !self.agencyOrderModel.driverPhone){
        [self showTextHubWithContent:@"司机信息缺失，不支持评价"];
        return;
    }
    
    NSString *content = [TextViewContentTool isContaintContent:_textView.text];
    if (!content) {
        [self showTextHubWithContent:@"请填写评价内容"];
        
        return ;
    }
    
    if (submitListener) {
        submitListener(self.agencyOrderModel, content, newSpeedScorePercent, newserverScorePercent);
    }
}

-(void)setSubmitListener:(void (^)(DBCarInfoModel *, NSString *, CGFloat, CGFloat))listener{
    submitListener = listener;
}

- (void) setAgencyOrderModel:(DBCarInfoModel *)agencyOrderModel {
    _agencyOrderModel = agencyOrderModel;
    
    
    
    [self addItemUI];
}

#pragma mark - CWStarRateViewDelegate

- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent {
    if (starRateView.tag == 11) {
        newSpeedScorePercent = newScorePercent * 5 * 10;
    } else if (starRateView.tag == 12) {
        newserverScorePercent = newScorePercent * 5 * 10;
    }
}

#pragma mark - UITextViewDelegate

// 有输入时触但对于中文键盘出示的联想字选择时不会触发
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0]; //获取高亮部分
    
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
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0) {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            
            // 既然是超出部分截取了，哪一定是最大限制了
            numberLab.text = [NSString stringWithFormat:@"%d／%d", MAX_LIMIT_NUMS, MAX_LIMIT_NUMS];
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
        noteName.hidden = YES;
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
        noteName.hidden = YES;
    } else {
        noteName.hidden = NO;
    }
    
    numberLab.text = [NSString stringWithFormat:@"%ld／%d", (long)existTextNum, MAX_LIMIT_NUMS];
}

@end
