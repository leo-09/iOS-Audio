//
//  CCarFriendInfoCommentCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CCarFriendInfoCommentCell.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "UILabel+lineSpace.h"
#import "Masonry.h"
#import "YYKit.h"

@implementation CCarFriendInfoCommentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CCarFriendInfoCommentCell";
    // 1.缓存中
    CCarFriendInfoCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CCarFriendInfoCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 暂无评论
        _noCommentLabel = [[UILabel alloc] init];
        _noCommentLabel.text = @"暂无评论";
        _noCommentLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _noCommentLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _noCommentLabel.numberOfLines = 0;
        [self.contentView addSubview:_noCommentLabel];
        [_noCommentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.centerX);
            make.centerY.equalTo(self.contentView.centerY);
        }];
        
        // 头像
        _headerImage = [[UIImageView alloc] init];
        CTXViewBorderRadius(_headerImage, 25, 0, [UIColor clearColor]);
        [self.contentView addSubview:_headerImage];
        [_headerImage makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(12);
            make.size.equalTo(CGSizeMake(50, 50));
        }];
        
        // 名字
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _nameLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerImage.right).offset(12);
            make.top.equalTo(@15);
            make.right.equalTo(@(-59));
        }];
        
        // 时间
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _dateLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_dateLabel];
        [_dateLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel.left);
            make.top.equalTo(_nameLabel.bottom).offset(10);
        }];
        
        // 内容
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _infoLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _infoLabel.numberOfLines = 0;
        [self.contentView addSubview:_infoLabel];
        [_infoLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@74);
            make.right.equalTo(@(-12));
            make.top.equalTo(_headerImage.bottom).offset(10);
        }];
        
        // 点赞
        _goodBtn = [[UIButton alloc] init];
        [_goodBtn setTitleColor:UIColorFromRGB(CTXBaseFontColor) forState:UIControlStateNormal];
        _goodBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_goodBtn setTitle:@" 0" forState:UIControlStateNormal];
        [_goodBtn setImage:[UIImage imageNamed:@"carFrienddianz_q"] forState:UIControlStateNormal];
        [_goodBtn addTarget:self action:@selector(goodClick) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:_goodBtn];
        [_goodBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-12));
            make.top.equalTo(_infoLabel.bottom).offset(12);
            make.height.equalTo(@40);
        }];
        
        // 分割线
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [self.contentView addSubview:_lineView];
        [_lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
    }
    
    return self;
}

- (void) setModel:(CarFriendUserCommentModel *)model isLastCell:(BOOL)isLastCell {
    _model = model;
    
    if (model.commontID) {
        _noCommentLabel.hidden = YES;
        _nameLabel.hidden = NO;
        _dateLabel.hidden = NO;
        _infoLabel.hidden = NO;
        _goodBtn.hidden = NO;
        
        // 设置头像
        NSURL *url = [NSURL URLWithString:_model.userPhoto];
        [_headerImage setImageWithURL:url placeholder:[UIImage imageNamed:@"touxiang_85x85"]];
        // 设置名称
        NSString *nikeName = model.nikeName ? model.nikeName : @"";
        NSString *carName = model.carName ? model.carName : @"";
        _nameLabel.text = [NSString stringWithFormat:@"%@ %@", nikeName, carName];
        // 时间
        _dateLabel.text = _model.createTime;
        
        // 设置内容
        _infoLabel.text = _model.contents ? _model.contents : @"";
        [UILabel changeLineSpaceForLabel:_infoLabel WithSpace:6];
        _infoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        // 点赞
        NSString *goodTitle = [NSString stringWithFormat:@" %@", (_model.laudCount ? _model.laudCount : @"0")];
        [_goodBtn setTitle:goodTitle forState:UIControlStateNormal];
        if (_model.isLaud) {
            [_goodBtn setImage:[UIImage imageNamed:@"carFrienddianz_q_h"] forState:UIControlStateNormal];
        } else {
            [_goodBtn setImage:[UIImage imageNamed:@"carFrienddianz_q"] forState:UIControlStateNormal];
        }
        
    } else {
        _noCommentLabel.hidden = NO;
        _nameLabel.hidden = YES;
        _dateLabel.hidden = YES;
        _infoLabel.hidden = YES;
        _goodBtn.hidden = YES;
    }
    
    if (isLastCell) {
        _lineView.hidden = YES;
    } else {
        _lineView.hidden = NO;
    }
}

- (CGFloat)heightForModel:(CarFriendUserCommentModel *)model {
    
    if (model.commontID) {
        CGFloat height = 0;
        
        height += 12;   // 头像上边距
        height += 50;   // 头像高度
        
        height += 10;   // 内容的上边距
        _infoLabel.text = (model.contents ? model.contents : @"");
        CGFloat infoHeight = [_infoLabel labelHeightWithLineSpace:6 WithWidth:(CTXScreenWidth-74-12) WithNumline:0].height;
        height += infoHeight;       // 内容的高度
        
        height += 12;   // 点赞 评论的上边距
        height += 40;   // 点赞 评论
        height += 12;   // 点赞 评论的下边距
        
        return height;
    } else {
        // 暂无评论
        return 50;
    }
}

#pragma mark - private method

// 点赞
- (void) goodClick {
    //  此处必须先带着原model回调,不可在下面修改之后回调
    if (self.clickGoodListener) {
        self.clickGoodListener([self.model copy]);
    }
    
    int laudCount = [_model.laudCount intValue];
    
    if (_model.isLaud) {
        // 原来点赞，则取消点赞
        _model.isLaud = NO;
        
        laudCount--;
        [_goodBtn setImage:[UIImage imageNamed:@"carFrienddianz_q"] forState:UIControlStateNormal];
    } else {
        // 原来没有点赞，则添加点赞
        _model.isLaud = YES;
        
        laudCount++;
        [_goodBtn setImage:[UIImage imageNamed:@"carFrienddianz_q_h"] forState:UIControlStateNormal];
    }
    
    NSString *goodTitle = [NSString stringWithFormat:@" %d", laudCount];
    _model.laudCount = goodTitle;
    [_goodBtn setTitle:goodTitle forState:UIControlStateNormal];
}

@end
