//
//  CCollectionRecordCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CCollectionRecordCell.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "UILabel+lineSpace.h"
#import "Masonry.h"

@implementation CCollectionRecordCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CCollectionRecordCell";
    // 1.缓存中
    CCollectionRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CCollectionRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        // 推荐
        _recommendLabel = [[UILabel alloc] init];
        _recommendLabel.backgroundColor = CTXColor(230, 0, 18);
        _recommendLabel.text = @"推荐";
        _recommendLabel.textColor = [UIColor whiteColor];
        _recommendLabel.textAlignment = NSTextAlignmentCenter;
        _recommendLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        CTXViewBorderRadius(_recommendLabel, 3.0, 0, [UIColor clearColor]);
        [self.contentView addSubview:_recommendLabel];
        [_recommendLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_typeLabel.right).offset(12);
            make.centerY.equalTo(_typeLabel.centerY);
            make.height.equalTo(@24);
            make.width.equalTo(@35);
        }];
        
        // 删除
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setImage:[UIImage imageNamed:@"icon_sc1"] forState:UIControlStateNormal];
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
        _infoLabel.numberOfLines = 2;
        [self.contentView addSubview:_infoLabel];
        [_infoLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.right.equalTo(@(-12));
            make.top.equalTo(_deleteBtn.bottom).offset(12);
        }];
        
        // 地址
        _addressIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-sevenbabicon"]];
        [self.contentView addSubview:_addressIV];
        [_addressIV makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(_infoLabel.bottom).offset(12);
            make.width.equalTo(@10);
        }];
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.numberOfLines = 0;
        _addressLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _addressLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_addressLabel];
        [_addressLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_addressIV.right).offset(8);
            make.top.equalTo(_addressIV.top).offset(-2);
            make.right.equalTo(@(-12));
        }];
        
        // 评论
        _commentBtn = [[UIButton alloc] init];
        [_commentBtn setTitleColor:UIColorFromRGB(CTXBaseFontColor) forState:UIControlStateNormal];
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_commentBtn setTitle:@" 0" forState:UIControlStateNormal];
        [_commentBtn setImage:[UIImage imageNamed:@"carFriendpingl_1"] forState:UIControlStateNormal];
        [self.contentView addSubview:_commentBtn];
        [_commentBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-12));
            make.top.equalTo(_addressLabel.bottom);
            make.height.equalTo(@40);
        }];
        
        UIView *vertialView = [[UIView alloc] init];
        vertialView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        [self.contentView addSubview:vertialView];
        [vertialView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_commentBtn.centerY);
            make.right.equalTo(_commentBtn.left).offset(-12);
            make.width.equalTo(@0.8);
            make.height.equalTo(@20);
        }];
        
        // 点赞
        _goodBtn = [[UIButton alloc] init];
        [_goodBtn setTitleColor:UIColorFromRGB(CTXBaseFontColor) forState:UIControlStateNormal];
        _goodBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_goodBtn setTitle:@" 0" forState:UIControlStateNormal];
        [_goodBtn setImage:[UIImage imageNamed:@"carFrienddianz_q"] forState:UIControlStateNormal];
        [self.contentView addSubview:_goodBtn];
        [_goodBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(vertialView.left).offset(-12);
            make.centerY.equalTo(_commentBtn.centerY);
            make.height.equalTo(@40);
        }];
        
        // 时间
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _timeLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.centerY.equalTo(_goodBtn.centerY);
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
    
    // 推荐
    if (_model.cmsCard.isRecommend) {
        _recommendLabel.hidden = NO;
    } else {
        _recommendLabel.hidden = YES;
    }
    
    // 设置内容
    _infoLabel.text = (_model.cmsCard.contents ? _model.cmsCard.contents : @"");
    [UILabel changeLineSpaceForLabel:_infoLabel WithSpace:5];
    _infoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    // 设置地址
    if (_model.cmsCard.address && ![_model.cmsCard.address isEqualToString:@""]) {
        _addressLabel.text = _model.cmsCard.address;
        [UILabel changeLineSpaceForLabel:_addressLabel WithSpace:4];
        
        CGFloat height = [_addressLabel labelHeightWithLineSpace:4 WithWidth:(CTXScreenWidth-42) WithNumline:0].height;
        
        [_addressIV updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@12);
        }];
        [_addressLabel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    } else {
        [_addressIV updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [_addressLabel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
    
    // 时间
    _timeLabel.text = _model.createTime;
    
    // 点赞
    NSString *goodTitle = [NSString stringWithFormat:@" %@", (_model.cmsCard.laudCount ? _model.cmsCard.laudCount : @"0")];
    [_goodBtn setTitle:goodTitle forState:UIControlStateNormal];
    if (_model.isLaud) {
        [_goodBtn setImage:[UIImage imageNamed:@"carFrienddianz_q_h"] forState:UIControlStateNormal];
    } else {
        [_goodBtn setImage:[UIImage imageNamed:@"carFrienddianz_q"] forState:UIControlStateNormal];
    }
    
    // 评论
    NSString *commentTitle = [NSString stringWithFormat:@" %@", (_model.cmsCard.commandCount ? _model.cmsCard.commandCount : @"0")];
    [_commentBtn setTitle:commentTitle forState:UIControlStateNormal];
}

- (CGFloat)heightForModel:(CarFriendCommentModel *)model {
    CGFloat height = 0;
    
    height += 10;   // 头部label的上边距
    height += 44;   // 删除按钮的高度
    
    height += 12;   // 内容的上边距
    _infoLabel.text = (model.cmsCard.contents ? model.cmsCard.contents : @"");
    CGFloat infoHeight = [_infoLabel labelHeightWithLineSpace:5 WithWidth:(CTXScreenWidth-24) WithNumline:2].height;
    height += infoHeight;       // 内容的高度
    
    height += 12; // 地址的上边距
    if (model.cmsCard.address && ![model.cmsCard.address isEqualToString:@""]) {
        _addressLabel.text = model.cmsCard.address;
        // 地址的高度
        height += [_addressLabel labelHeightWithLineSpace:4 WithWidth:(CTXScreenWidth-42) WithNumline:0].height;
    }
    
    height += 40;       // 点赞 评论
    height += 6;        // 点赞 评论的下边距
    
    return height;
}

// 删除记录
- (void) deleteRecord {
    if (self.deleteRecordListener) {
        self.deleteRecordListener();
    }
}

@end
