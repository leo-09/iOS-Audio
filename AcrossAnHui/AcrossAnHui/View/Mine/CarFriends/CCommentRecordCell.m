//
//  CCommentRecordCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CCommentRecordCell.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "UILabel+lineSpace.h"
#import "Masonry.h"
#import "YYKit.h"

@implementation CCommentRecordCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CCommentRecordCell";
    // 1.缓存中
    CCommentRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CCommentRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        // 公告、问小畅、随手拍
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.backgroundColor = CTXColor(34, 172, 56);
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        CTXViewBorderRadius(_typeLabel, 3.0, 0, [UIColor clearColor]);
        [self.contentView addSubview:_typeLabel];
        [_typeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(@20);
            make.height.equalTo(@24);
            make.width.equalTo(@0);
        }];
        
        // 时间
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _timeLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_typeLabel.right).offset(10);
            make.centerY.equalTo(_typeLabel.centerY);
        }];
        
        // 删除
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setImage:[UIImage imageNamed:@"icon_sq"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteRecord) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:_deleteBtn];
        [_deleteBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_typeLabel.centerY);
            make.right.equalTo(@0);
            make.width.equalTo(@44);
            make.height.equalTo(@44);
        }];
        
        // 内容
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _infoLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _infoLabel.numberOfLines = 0;
        [self.contentView addSubview:_infoLabel];
        [_infoLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.right.equalTo(@(-12));
            make.top.equalTo(_deleteBtn.bottom).offset(12);
        }];
        
        // 回复内容
        _replyContentView = [[UIView alloc] init];
        _replyContentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_replyContentView];
        [_replyContentView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.right.equalTo(@(-12));
            make.top.equalTo(_infoLabel.bottom);
            make.height.equalTo(@0);
        }];
        
        // 分割线
        UIView *topLineView = [[UIView alloc] init];
        topLineView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self.contentView addSubview:topLineView];
        [topLineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@10);
        }];
    }
    
    return self;
}

- (void) setModel:(CarFriendCommentModel *)model {
    _model = model;
    
    // 公告、问小畅、随手拍
    _typeLabel.text = _model.cmsCard.classifyName;
    CGFloat typeWidth = [_typeLabel labelHeightWithLineSpace:0 WithWidth:CTXScreenWidth WithNumline:1].width;
    [_typeLabel updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(typeWidth + 15);
    }];
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    
    // 时间
    _timeLabel.text = _model.createTime;
    
    // 设置内容
    _infoLabel.text = (_model.contents ? _model.contents : @"");
    [UILabel changeLineSpaceForLabel:_infoLabel WithSpace:5];
    _infoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    // 设置回复内容
    [_replyContentView removeAllSubviews];
    if (_model.cmsCard.contents && ![_model.cmsCard.contents isEqualToString:@""]) {
        [_replyContentView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(5 + 80));
        }];
        
        [self addReplyContentView];
    } else {
        [_replyContentView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
}

- (CGFloat)heightForModel:(CarFriendCommentModel *)model {
    CGFloat height = 0;
    
    height += 10;   // 头部label的上边距
    height += 44;   // 删除按钮的高度
    
    height += 12;   // 内容的上边距
    _infoLabel.text = (model.contents ? model.contents : @"");
    CGFloat infoHeight = [_infoLabel labelHeightWithLineSpace:5 WithWidth:(CTXScreenWidth-24) WithNumline:0].height;
    height += infoHeight;       // 内容的高度
    
    // 回复内容
    if (model.cmsCard.contents && ![model.cmsCard.contents isEqualToString:@""]) {
        height += 5 + 80;       // 小畅回答的高度
    }
    
    height += 12;
    
    return height;
}

// 删除记录
- (void) deleteRecord {
    if (self.deleteRecordListener) {
        self.deleteRecordListener();
    }
}

- (void) addReplyContentView {
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"carFriend-dhk"]];
    [_replyContentView addSubview:iv];
    [iv makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(5);
        make.bottom.equalTo(@0);
    }];
    
    UILabel *replyLabel = [[UILabel alloc] init];
    replyLabel.text = _model.cmsCard.contents ? _model.cmsCard.contents : @"";
    replyLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    replyLabel.numberOfLines = 2;
    replyLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [UILabel changeLineSpaceForLabel:replyLabel WithSpace:6];
    [_replyContentView addSubview:replyLabel];
    [replyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iv.top).offset(15);
        make.left.equalTo(iv.left).offset(10);
        make.right.equalTo(iv.right).offset(-10);
        make.bottom.equalTo(iv.bottom).offset(-10);
    }];
    
    replyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
}

@end
