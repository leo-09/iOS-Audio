//
//  CarInspectAgencyCommentView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectAgencyCommentView.h"
#import "CTX-Prefix.pch"
#import "CWStarRateView.h"
#import "UILabel+lineSpace.h"

@implementation CarInspectAgencyCommentView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void) setOrderModel:(CarInspectAgencyOrderModel *)orderModel {
    _orderModel = orderModel;
    
    [self addCommentView];
}

#pragma mark - commentView

- (void) addCommentView {
    UILabel *commentTitleLabel = [[UILabel alloc] init];
    commentTitleLabel.font = [UIFont systemFontOfSize:15.0f];
    commentTitleLabel.textColor = UIColorFromRGB(0x333333);
    commentTitleLabel.text = @"我的评价";
    [self addSubview:commentTitleLabel];
    [commentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12.5);
        make.top.equalTo(@15);
    }];
    
    _commentStarView = [[CWStarRateView alloc]initWithFrame:CGRectMake(0, 0, 100, 15) numberOfStars:5 photostr:@"hong"];
    _commentStarView.allowIncompleteStar = YES;
    _commentStarView.hasAnimation = NO;
    CGFloat scorePercent = [(_orderModel.comment.attitude ? _orderModel.comment.attitude : @"50") floatValue];
    if (scorePercent / 50.0 <= 0) {
        _commentStarView.scorePercent = 0;
    } else if (scorePercent / 50.0 < 0.2) {
        _commentStarView.scorePercent = 0.2;
    } else if (scorePercent / 50.0 < 0.4) {
        _commentStarView.scorePercent = 0.4;
    } else if (scorePercent / 50.0 < 0.6) {
        _commentStarView.scorePercent = 0.6;
    } else if (scorePercent / 50.0 < 0.8) {
        _commentStarView.scorePercent = 0.8;
    } else if (scorePercent / 50.0 < 1.0) {
        _commentStarView.scorePercent = 1.0;
    }
    
    [self addSubview:_commentStarView];
    [_commentStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12.5);
        make.top.equalTo(commentTitleLabel.mas_bottom).offset(15);
        make.height.equalTo(15);
        make.width.equalTo(@100);
    }];
    
    _commentResultLabel = [[UILabel alloc] init];
    _commentResultLabel.font = [UIFont systemFontOfSize:15.0f];
    _commentResultLabel.textColor = UIColorFromRGB(0x333333);
    _commentResultLabel.text = (_orderModel.comment.content ? _orderModel.comment.content : @"");
    _commentResultLabel.numberOfLines = 0;
    CGFloat height = [_commentResultLabel getLabelHeightWithLineSpace:8 WithWidth:(CTXScreenWidth-25) WithNumline:0].height;
    
    [self addSubview:_commentResultLabel];
    [_commentResultLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12.5);
        make.right.equalTo(@(-12.5));
        make.top.equalTo(_commentStarView.mas_bottom).offset(15);
        make.height.equalTo(@(height));
    }];
    
    
    self.viewHeight = 85 + height + 10;
}

@end
