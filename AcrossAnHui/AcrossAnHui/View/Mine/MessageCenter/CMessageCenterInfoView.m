//
//  CMessageCenterInfoView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CMessageCenterInfoView.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "UILabel+lineSpace.h"
#import "PromptView.h"

@implementation CMessageCenterInfoView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    }
    
    return self;
}

- (void) setModel:(MessageContentModel *)model {
    _model = model;
    
    if (_model) {
        [self addModelView];
    } else {
        [self addNilDataView];
    }
}

#pragma mark - 有数据的UI

- (void) addModelView {
    [self removeAllSubviews];
    
    // scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:scrollView];
    [scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // contentView
    UIView *contentView = [[UIView alloc] init];
    [scrollView addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(CTXScreenWidth);
    }];
    
    // titleLabel
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    titleLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    titleLabel.text = (_model.title ? _model.title : @"");
    titleLabel.numberOfLines = 0;
    [UILabel changeLineSpaceForLabel:titleLabel WithSpace:8];
    [contentView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.equalTo(@12);
        make.right.equalTo(@(-12));
    }];
    
    // infoLabel
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    infoLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    infoLabel.numberOfLines = 0;
    infoLabel.text = (_model.content ? _model.content : @"");
    [UILabel changeLineSpaceForLabel:infoLabel WithSpace:10];
    [contentView addSubview:infoLabel];
    [infoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.bottom).offset(15);
        make.left.equalTo(titleLabel.left);
        make.right.equalTo(titleLabel.right);
    }];
    
    // imageView
    CGFloat ivHeight = 169;
    NSArray *imgs = @[];
    UIImageView *lastIV;
    if (_model.img && _model.img.length > 0) {
        imgs = [_model.img componentsSeparatedByString:@","];
        
        for (int i = 0; i < imgs.count; i++) {
            NSString *img = imgs[i];
            NSURL *url = [NSURL URLWithString:img];
            
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView setImageWithURL:url placeholder:[UIImage imageNamed:@"z_l"]];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            [contentView addSubview:imageView];
            [imageView makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(ivHeight);
                make.left.equalTo(@12);
                make.right.equalTo(@(-12));
                
                make.centerX.equalTo(contentView.centerX);
                
                if (lastIV) {
                    make.top.equalTo(lastIV.bottom).offset(@15);
                }  else {
                    make.top.equalTo(infoLabel.bottom).offset(15);
                }
            }];
            
            lastIV = imageView;
        }
    }
    
    // addressLabel
    UILabel *addressLabel;
    if (_model.address) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-sevenbabicon"]];
        [contentView addSubview:iv];
        [iv makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.width.equalTo(@12.5);
            
            if (lastIV) {
                make.top.equalTo(lastIV.bottom).offset(15);
            }  else {
                make.top.equalTo(infoLabel.bottom).offset(15);
            }
        }];
        
        addressLabel = [[UILabel alloc] init];
        addressLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        addressLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        addressLabel.text = (_model.address ? _model.address : @"");
        [contentView addSubview:addressLabel];
        [addressLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iv.right).offset(@5);
            make.right.equalTo(@(-12));
            make.centerY.equalTo(iv.centerY);
        }];
    }
    
    // timeLabel
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:14.0];
    timeLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
    timeLabel.text = [_model dataTime];
    [contentView addSubview:timeLabel];
    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-12));
        
        if (addressLabel) {
            make.top.equalTo(addressLabel.bottom).offset(20);
        } else if (lastIV) {
            make.top.equalTo(lastIV.bottom).offset(20);
        }  else {
            make.top.equalTo(infoLabel.bottom).offset(20);
        }
    }];
    
    // nameLabel
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:14.0];
    nameLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
    nameLabel.text = (_model.from ? _model.from : @"");
    [contentView addSubview:nameLabel];
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.bottom).offset(15);
        make.right.equalTo(@(-12));
    }];
    
    // 计算内容的高度
    CGFloat height = 0;
    
    height += (15 + [titleLabel getLabelHeightWithLineSpace:0 WithWidth:CTXScreenWidth-24 WithNumline:0].height);
    height += (15 + [infoLabel getLabelHeightWithLineSpace:0 WithWidth:CTXScreenWidth-24 WithNumline:0].height);
    height += imgs.count * (ivHeight + 15);
    if (_model.address) {
        height += (15 + 20);
    }
    
    height += (20 + 17);
    height += (15 + 17);
    
    // 更新ContentSize
    if (height > (CTXScreenHeight - 64)) {
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(nameLabel.bottom).offset(15);
        }];
    } else {
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(nameLabel.bottom).offset(CTXScreenHeight - 64 - height + 1);
        }];
    }
}

#pragma mark - 没有数据的UI

- (void) addNilDataView {
    PromptView *promptView = [[PromptView alloc] init];
    [promptView setNilDataWithImagePath:@"weizhaodao" tint:@"暂无消息内容" btnTitle:nil];
    
    [self addSubview:promptView];
    [promptView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
