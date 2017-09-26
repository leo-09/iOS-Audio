//
//  CSignView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/10.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CSignView.h"

@implementation CSignView

- (instancetype) init {
    if (self = [super init]) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        [_scrollView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [_scrollView addSubview:_contentView];
        [_contentView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_scrollView);
            make.width.equalTo(_scrollView);
        }];
        
        [self addHeaderView];
        [self addSignCalendarView];
        [self addBottomView];
        
        [_contentView updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.textLabel.bottom);
        }];
    }
    
    return self;
}

- (void) addHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:headerView];
    [headerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@100);
    }];
    
    _signDayLabel = [[UILabel alloc] init];
    [self setSignDayLabelText:@"0"];
    [headerView addSubview:_signDayLabel];
    [_signDayLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@23);
        make.left.equalTo(@12);
    }];
    
    _signPersonLabel = [[UILabel alloc] init];
    [self setSignPersonLabelText:@"0"];
    [headerView addSubview:_signPersonLabel];
    [_signPersonLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@23);
        make.right.equalTo(@(-12));
    }];
}

- (void) addSignCalendarView {
    _calendarView = [[SignCalendarView alloc]initWithFrame:CGRectZero WithBlock:^(CGFloat height) {
        __block CGFloat blockHeight = height;
        
        [_calendarView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(blockHeight + 45 + 20);
        }];
    }];
    
    [_contentView addSubview:_calendarView];
    [_calendarView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@(-20));
        make.top.equalTo(55);
        make.height.equalTo(@385);
    }];
}

- (void) addBottomView {
    _signBtn = [[UIButton alloc] init];
    _signBtn.backgroundColor = UIColorFromRGB(CTXThemeColor);
    [_signBtn setTitle:@"签到" forState:UIControlStateNormal];
    [_signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _signBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [_signBtn addTarget:self action:@selector(sign) forControlEvents:UIControlEventTouchDown];
    CTXViewBorderRadius(_signBtn, 4.0, 0, [UIColor clearColor]);
    [_contentView addSubview:_signBtn];
    [_signBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@92);
        make.height.equalTo(@40);
        make.top.equalTo(_calendarView.bottom).offset(@20);
        make.right.equalTo(_contentView.centerX).offset(-20);
    }];
    
    _prideBtn = [[UIButton alloc] init];
    _prideBtn.backgroundColor = CTXColor(153, 153, 153);
    [_prideBtn setTitle:@"抽奖" forState:UIControlStateNormal];
    [_prideBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _prideBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [_prideBtn addTarget:self action:@selector(pride) forControlEvents:UIControlEventTouchDown];
    CTXViewBorderRadius(_prideBtn, 4.0, 0, [UIColor clearColor]);
    [_contentView addSubview:_prideBtn];
    [_prideBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@92);
        make.height.equalTo(@40);
        make.top.equalTo(_calendarView.bottom).offset(@20);
        make.left.equalTo(_contentView.centerX).offset(20);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
    [_contentView addSubview:_lineView];
    [_lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(_prideBtn.bottom).offset(20);
        make.height.equalTo(0.8);
    }];
    
    _textLabel = [[UILabel alloc]init];
    _textLabel.numberOfLines = 0;
    _textLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [_contentView addSubview:_textLabel];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.mas_bottom).offset(15);
        make.left.equalTo(@12);
        make.right.equalTo(@(-12));
    }];
}

#pragma mark - public method

- (void) setSignDayLabelText:(NSString *) day {
    if (!day) {
        day = @"0";
    }
    
    NSString *content = [NSString stringWithFormat:@"本月已累计签到 %@ 天", day];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:(content ? content : @"")];
    text.color = UIColorFromRGB(CTXTextBlackColor);
    [text setColor:[UIColor orangeColor] range:[content rangeOfString:day]];
    text.font = [UIFont systemFontOfSize:14.0];
    _signDayLabel.attributedText = text;
}

- (void) setSignPersonLabelText:(NSString *) day {
    if (!day) {
        day = @"0";
    }
    
    NSString *content = [NSString stringWithFormat:@"今日已有 %@人签到", day];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:(content ? content : @"")];
    text.color = UIColorFromRGB(CTXTextBlackColor);
    [text setColor:[UIColor orangeColor] range:[content rangeOfString:day]];
    text.font = [UIFont systemFontOfSize:14.0];
    _signPersonLabel.attributedText = text;
}

- (void) setModel:(SignModel *)model {
    _model = model;
    
    [self setSignDayLabelText:_model.curMonthSignNum];
    [self setSignPersonLabelText:_model.curMonthSignTotalNum];
    
    // 日历
    self.calendarView.monthLabel.text = [_model currentDate];
    [self.calendarView setNetDateWithNetTimeStep:_model.curDate];
    // 更新日历信息
    NSMutableArray *days = [[NSMutableArray alloc] init];
    for (SignList *signList in _model.signList) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[signList.signDate doubleValue] / 1000];
        [days addObject:[NSString stringWithFormat:@"%d", (int)date.day]];
    }
    [self.calendarView.calendarView updateWithSignDayArray:days];
    
    if (_model.isSign) {
        [_signBtn setTitle:@"今日已签到" forState:UIControlStateNormal];
        _signBtn.backgroundColor = CTXColor(153, 153, 153);
    } else {
        [_signBtn setTitle:@"签到" forState:UIControlStateNormal];
        _signBtn.backgroundColor = UIColorFromRGB(CTXThemeColor);
    }
    
    if (_model.content && _model.content.length > 0) {
        // 富文本
        NSData *finishData = [_model.content dataUsingEncoding:NSUnicodeStringEncoding];
        NSMutableParagraphStyle *muStyle = [[NSMutableParagraphStyle alloc]init];
        muStyle.lineSpacing = 10.0;
        
        NSDictionary *options = @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                   NSFontAttributeName: [UIFont systemFontOfSize:15] };
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithData:finishData
                                                                                             options:options
                                                                                  documentAttributes:nil
                                                                                               error:nil];
        [attributeString addAttribute:NSParagraphStyleAttributeName
                                value:muStyle
                                range:NSMakeRange(0, attributeString.length)];
        [attributeString addAttribute:NSFontAttributeName
                                value:[UIFont systemFontOfSize:CTXTextFont]
                                range:NSMakeRange(0, attributeString.length)];
        [attributeString addAttribute:NSForegroundColorAttributeName
                                value:UIColorFromRGB(CTXBaseFontColor)
                                range:NSMakeRange(0, attributeString.length)];
        
        _textLabel.attributedText = attributeString;
    } else {
        _lineView.hidden = YES;
        [_textLabel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
        }];
    }
}

- (void) sign {
    if (self.signListener) {
        self.signListener();
    }
}

- (void) pride {
    if (self.prideListener) {
        self.prideListener();
    }
}

@end
