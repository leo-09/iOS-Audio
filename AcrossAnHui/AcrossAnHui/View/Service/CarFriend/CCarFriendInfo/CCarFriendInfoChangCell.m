//
//  CCarFriendInfoChangCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CCarFriendInfoChangCell.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "UILabel+lineSpace.h"
#import "Masonry.h"

@implementation CCarFriendInfoChangCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CCarFriendInfoChangCell";
    // 1.缓存中
    CCarFriendInfoChangCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CCarFriendInfoChangCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        // 分割线
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self.contentView addSubview:_lineView];
        [_lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.top.equalTo(@0);
            make.height.equalTo(@10);
        }];
        
        // 小畅说
        _label = [[UILabel alloc] init];
        _label.text = @"小畅说";
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = UIColorFromRGB(0xFFFFFF);
        _label.font = [UIFont systemFontOfSize:CTXTextFont];
        _label.backgroundColor = CTXColor(4, 142, 38);
        CTXViewBorderRadius(_label, 3.0, 0, [UIColor clearColor]);
        [self.contentView addSubview:_label];
        [_label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(_lineView.bottom).offset(10);
            make.width.equalTo(@65);
            make.height.equalTo(@30);
        }];
        
        // 小畅说内容
        _replyLabel = [[UILabel alloc] init];
        _replyLabel.numberOfLines = 0;
        _replyLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _replyLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [self.contentView addSubview:_replyLabel];
        [_replyLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label.bottom).offset(10);
            make.left.equalTo(@12);
            make.right.equalTo(@(-12));
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
            make.top.equalTo(_replyLabel.bottom).offset(10);
            make.height.equalTo(@40);
        }];
    }
    
    return self;
}

- (void) setModel:(CarFriendCardModel *)model {
    _model = model;
    
    // 小畅说内容
    _replyLabel.text = _model.replyContents ? _model.replyContents : @"";
    [UILabel changeLineSpaceForLabel:_replyLabel WithSpace:6];
    _replyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    // 点赞
    NSString *goodTitle = [NSString stringWithFormat:@" %@", (_model.replyCount ? _model.replyCount : @"0")];
    [_goodBtn setTitle:goodTitle forState:UIControlStateNormal];
    if (_model.isReplyLaud) {
        [_goodBtn setImage:[UIImage imageNamed:@"carFrienddianz_q_h"] forState:UIControlStateNormal];
    } else {
        [_goodBtn setImage:[UIImage imageNamed:@"carFrienddianz_q"] forState:UIControlStateNormal];
    }
}

- (CGFloat)heightForModel:(CarFriendCardModel *)model {
    CGFloat height = 0;
    
    // 有小畅说，才有高度
    if (model.replyContents && ![model.replyContents isEqualToString:@""]) {
        height += 10;   // 分隔线高度
        height += 10;   // 小畅说上边距
        height += 30;   // 小畅说高度
        height += 10;   // 小畅说内容的上边距
        
        // 小畅说内容的高度
        _replyLabel.text = (model.replyContents ? model.replyContents : @"");
        CGFloat infoHeight = [_replyLabel labelHeightWithLineSpace:6 WithWidth:(CTXScreenWidth-24) WithNumline:0].height;
        height += infoHeight;
        
        height += 10;   // 点赞的上边距
        height += 40;   // 点赞的高度
        height += 5;
    }
    
    return height;
}

#pragma mark - private method

// 点赞
- (void) goodClick {
    //  此处必须先带着原model回调,不可在下面修改之后回调
    if (self.clickGoodListener) {
        self.clickGoodListener([self.model copy]);
    }
    
    int laudCount = [_model.replyCount intValue];
    
    if (_model.isReplyLaud) {
        // 原来点赞，则取消点赞
        _model.isReplyLaud = NO;
        
        laudCount--;
        [_goodBtn setImage:[UIImage imageNamed:@"carFrienddianz_q"] forState:UIControlStateNormal];
    } else {
        // 原来没有点赞，则添加点赞
        _model.isReplyLaud = YES;
        
        laudCount++;
        [_goodBtn setImage:[UIImage imageNamed:@"carFrienddianz_q_h"] forState:UIControlStateNormal];
    }
    
    NSString *goodTitle = [NSString stringWithFormat:@" %d", laudCount];
    _model.replyCount = goodTitle;
    [_goodBtn setTitle:goodTitle forState:UIControlStateNormal];
}

@end
