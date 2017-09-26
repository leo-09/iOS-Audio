//
//  CIllegalInfoView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CIllegalInfoView.h"

@implementation CIllegalInfoView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_scrollView];
        [_scrollView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_contentView];
        [_contentView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_scrollView);
            make.width.equalTo(CTXScreenWidth);
            make.height.equalTo(CTXScreenHeight - CTXBarHeight - CTXNavigationBarHeight + 1);
        }];
        
        UIImageView *bgIV = [[UIImageView alloc] init];
        bgIV.image = [UIImage imageNamed:@"bj"];
        [_contentView addSubview:bgIV];
        [bgIV makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.width.equalTo(CTXScreenWidth);
            make.height.equalTo(CTXScreenHeight - CTXBarHeight - CTXNavigationBarHeight);
        }];
        
        // iv
        _iv = [[UIImageView alloc] init];
        [_contentView addSubview:_iv];
        [_iv makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@25);
            make.right.equalTo(@(-10));
            make.width.equalTo(61);
            make.height.equalTo(40.5);
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        nameLabel.font = [UIFont systemFontOfSize:18.0];
        nameLabel.text = @"我的罚单";
        [_contentView addSubview:nameLabel];
        [nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_contentView.centerX);
            make.centerY.equalTo(_iv.centerY);
        }];
        
        // 车牌号
        UILabel *plateLabel = [[UILabel alloc] init];
        plateLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        plateLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        plateLabel.text = @"车牌号：";
        [_contentView addSubview:plateLabel];
        [plateLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@25);
            make.width.equalTo(@62);
            make.top.equalTo(nameLabel.bottom).offset(@15);
        }];
        
        _plateNumberLabel = [[UILabel alloc] init];
        _plateNumberLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _plateNumberLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [_contentView addSubview:_plateNumberLabel];
        [_plateNumberLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(plateLabel.centerY);
            make.left.equalTo(plateLabel.right);
            make.right.equalTo(@(-25));
        }];
        
        // 违章时间
        UILabel *illegalTimeLabel = [[UILabel alloc] init];
        illegalTimeLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        illegalTimeLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        illegalTimeLabel.text = @"违章时间：";
        [_contentView addSubview:illegalTimeLabel];
        [illegalTimeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(plateLabel.left);
            make.width.equalTo(@77);
            make.top.equalTo(plateLabel.bottom).offset(@50);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _timeLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [_contentView addSubview:_timeLabel];
        [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(illegalTimeLabel.centerY);
            make.left.equalTo(illegalTimeLabel.right);
            make.right.equalTo(_plateNumberLabel.right);
        }];
        
        // 违章地点
        UILabel *illegalAddrLabel = [[UILabel alloc] init];
        illegalAddrLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        illegalAddrLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        illegalAddrLabel.text = @"违章地点：";
        [_contentView addSubview:illegalAddrLabel];
        [illegalAddrLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(plateLabel.left);
            make.width.equalTo(@77);
            make.top.equalTo(illegalTimeLabel.bottom).offset(@20);
        }];
        
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _addressLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _addressLabel.numberOfLines = 0;
        [_contentView addSubview:_addressLabel];
        [_addressLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(illegalAddrLabel.top);
            make.left.equalTo(illegalAddrLabel.right);
            make.right.equalTo(_plateNumberLabel.right);
        }];
        
        // 违章行为
        UILabel *illegalActionLabel = [[UILabel alloc] init];
        illegalActionLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        illegalActionLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        illegalActionLabel.text = @"违章行为：";
        [_contentView addSubview:illegalActionLabel];
        [illegalActionLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(plateLabel.left);
            make.width.equalTo(@77);
            make.top.equalTo(_addressLabel.bottom).offset(@20);
        }];
        
        _actionLabel = [[UILabel alloc] init];
        _actionLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _actionLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _actionLabel.numberOfLines = 0;
        [_contentView addSubview:_actionLabel];
        [_actionLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(illegalActionLabel.top);
            make.left.equalTo(illegalActionLabel.right);
            make.right.equalTo(_plateNumberLabel.right);
        }];
        
        // 违章扣分
        UILabel *illegalScoreLabel = [[UILabel alloc] init];
        illegalScoreLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        illegalScoreLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        illegalScoreLabel.text = @"违章扣分：";
        [_contentView addSubview:illegalScoreLabel];
        [illegalScoreLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(plateLabel.left);
            make.width.equalTo(@77);
            make.top.equalTo(_actionLabel.bottom).offset(@20);
        }];
        
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _scoreLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [_contentView addSubview:_scoreLabel];
        [_scoreLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(illegalScoreLabel.centerY);
            make.left.equalTo(illegalScoreLabel.right);
            make.right.equalTo(_plateNumberLabel.right);
        }];
        
        // 违章罚款
        UILabel *illegalMoneyLabel = [[UILabel alloc] init];
        illegalMoneyLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        illegalMoneyLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        illegalMoneyLabel.text = @"违章罚款：";
        [_contentView addSubview:illegalMoneyLabel];
        [illegalMoneyLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(plateLabel.left);
            make.width.equalTo(@77);
            make.top.equalTo(illegalScoreLabel.bottom).offset(@20);
        }];
        
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _moneyLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [_contentView addSubview:_moneyLabel];
        [_moneyLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(illegalMoneyLabel.centerY);
            make.left.equalTo(illegalMoneyLabel.right);
            make.right.equalTo(_plateNumberLabel.right);
        }];
        
        _showIllegalDisposalSiteBtn = [[UIButton alloc] init];
        _showIllegalDisposalSiteBtn.backgroundColor = UIColorFromRGB(CTXThemeColor);
        [_showIllegalDisposalSiteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_showIllegalDisposalSiteBtn setTitle:@"查看附近违章处理点" forState:UIControlStateNormal];
        _showIllegalDisposalSiteBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        CTXViewBorderRadius(_showIllegalDisposalSiteBtn, 5.0, 0, [UIColor clearColor]);
        [_showIllegalDisposalSiteBtn addTarget:self action:@selector(showIllegalDisposalSite) forControlEvents:UIControlEventTouchDown];
        [_contentView addSubview:_showIllegalDisposalSiteBtn];
        [_showIllegalDisposalSiteBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(plateLabel.left);
            make.right.equalTo(_plateNumberLabel.right);
            make.top.equalTo(illegalMoneyLabel.bottom).offset(@20);
            make.height.equalTo(@44);
        }];
    }
    
    return self;
}

- (void) showIllegalDisposalSite {
    if (self.showIllegalDisposalSiteListener) {
        self.showIllegalDisposalSiteListener();
    }
}

- (void) setViolationInfoModel:(ViolationInfoModel *)violationInfoModel {
    _violationInfoModel = violationInfoModel;
    
    if ([_violationInfoModel.jkbj isEqualToString:@"已交款"]) {
        _iv.image = [UIImage imageNamed:@"yijiaofei"];
        _showIllegalDisposalSiteBtn.hidden = YES;
    } else {
        _iv.image = [UIImage imageNamed:@"weichuli"];
        _showIllegalDisposalSiteBtn.hidden = NO;
    }
    
    _plateNumberLabel.text = _violationInfoModel.hphm;    // 车牌号
    _timeLabel.text = _violationInfoModel.wfsj;           // 违章时间
    _addressLabel.text = _violationInfoModel.wfdz;        // 违章地点
    _actionLabel.text = _violationInfoModel.wfnr;         // 违章行为
    _scoreLabel.text = [NSString stringWithFormat:@"%@分", (_violationInfoModel.wfjfs ? _violationInfoModel.wfjfs : @"0")];// 违章扣分
    _moneyLabel.text = [NSString stringWithFormat:@"%@元", (_violationInfoModel.fkje_dut ? _violationInfoModel.fkje_dut : @"0")];// 违章罚款
}

@end
