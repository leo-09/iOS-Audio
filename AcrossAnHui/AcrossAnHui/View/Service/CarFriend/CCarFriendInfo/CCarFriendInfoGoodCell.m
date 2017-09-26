//
//  CCarFriendInfoGoodCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CCarFriendInfoGoodCell.h"
#import "Masonry.h"
#import "YYKit.h"

// 最多显示6个头像，每个头像间距7, 省略号宽13,两边边距12, 24是上下边距
#define HeaderIVHeight (CTXScreenWidth - 7 * 6 - 24 - 13) / 6

@implementation CCarFriendInfoGoodCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CCarFriendInfoGoodCell";
    // 1.缓存中
    CCarFriendInfoGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CCarFriendInfoGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self.contentView addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.top.equalTo(@0);
            make.height.equalTo(@10);
        }];
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"carFrienddianz_q"]];
        [self.contentView addSubview:iv];
        [iv makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(view.bottom).offset(15);
        }];
        
        _descLabel = [[UILabel alloc] init];
        _descLabel.text = @"已有0位车友为ta助力";
        _descLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _descLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_descLabel];
        [_descLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(iv.centerY);
            make.left.equalTo(iv.right).offset(5);
        }];
    }
    
    return self;
}

- (void) setModel:(CarFriendCardModel *)model {
    _model = model;
    
    _descLabel.text = [NSString stringWithFormat:@"已有%@位车友为ta助力", (_model.laudCount ? _model.laudCount : @" ")];
    
    if (imageViews) {
        for (UIImageView *iv in imageViews) {
            [iv removeFromSuperview];
        }
        [imageViews removeAllObjects];
    } else {
        imageViews = [[NSMutableArray alloc] init];
    }
    
    if (_ellipsisLabel) {
        [_ellipsisLabel removeFromSuperview];
        _ellipsisLabel = nil;
    }
    
    if (_model.headImageList.count > 0) {
        [self addImageView];
    }
}

- (CGFloat)heightForModel:(CarFriendCardModel *)model {
    if (model.headImageList && model.headImageList.count > 0) {
        return 10 + 37 + HeaderIVHeight + 24;
    } else {
        return 10 + 47;
    }
}

#pragma mark - private method

// 点赞的头像
- (void) addImageView {
    UIImageView *lastIV;
    for (int i = 0; i < _model.headImageList.count; i++) {
        CarFriendHeadImageModel *model = _model.headImageList[i];
        UIImageView *iv = [[UIImageView alloc] init];
        CTXViewBorderRadius(iv, HeaderIVHeight / 2, 0, [UIColor clearColor]);
        NSURL *url = [NSURL URLWithString:model.headImage];
        [iv setImageWithURL:url placeholder:[UIImage imageNamed:@"touxiang_85x85"]];
        
        [self.contentView addSubview:iv];
        [iv makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_descLabel.bottom).offset(12);
            make.size.equalTo(CGSizeMake(HeaderIVHeight, HeaderIVHeight));
            
            if (lastIV) {
                make.left.equalTo(lastIV.right).offset(7);
            } else {
                make.left.equalTo(12);
            }
        }];
        
        lastIV = iv;
        [imageViews addObject:iv];
        
        // 最多显示6个
        if (i == 5) {
            break;
        }
    }
    
    // 超过6个点赞的人，则显示省略号
    if ([_model.laudCount intValue] > 6) {
        _ellipsisLabel = [[UILabel alloc] init];
        _ellipsisLabel.text = @"...";
        _ellipsisLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _ellipsisLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_ellipsisLabel];
        [_ellipsisLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lastIV.centerY);
            make.right.equalTo(@(-12));
        }];
    }
}

@end
