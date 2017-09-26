//
//  CarFriendCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarFriendCell.h"
#import "Masonry.h"
#import "YYKit.h"
#import "UILabel+lineSpace.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "PicInfo.h"
#import "ShowPictureView.h"
#import "AppDelegate.h"

#define VertialSpace 15             // 竖直间距
#define CountPerLine 3              // 每行最多显示3张图片
#define LineSpacePerImage 10        // 每张图片的垂直间距
#define HorizontalSpacePerImage 10  // 每张图片的水平间距
// 每张图片的宽高
#define WidthPerImage (CTXScreenWidth - 24 - HorizontalSpacePerImage * 2) / CountPerLine
#define HeightPerImage WidthPerImage / 1.375

@implementation CarFriendCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CarFriendCell";
    CarFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CarFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

// 构造方法(在初始化对象的时候会调用) 一般在这个方法中添加需要显示的子控件
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 头像
        _headerImage = [[UIImageView alloc] init];
        CTXViewBorderRadius(_headerImage, 25, 0, [UIColor clearColor]);
        [self.contentView addSubview:_headerImage];
        [_headerImage makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(VertialSpace);
            make.size.equalTo(CGSizeMake(50, 50));
        }];
        
        // 名字
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _nameLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerImage.right).offset(15);
            make.top.equalTo(@20);
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
        
        // 是否推荐
        _recommendLabel = [[UILabel alloc] init];
        _recommendLabel.text = @"推荐";
        _recommendLabel.textColor = [UIColor whiteColor];
        _recommendLabel.font = [UIFont systemFontOfSize:14];
        _recommendLabel.backgroundColor = [UIColor redColor];
        _recommendLabel.textAlignment = NSTextAlignmentCenter;
        CTXViewBorderRadius(_recommendLabel, 3.0, 0, [UIColor clearColor]);
        [self.contentView addSubview:_recommendLabel];
        [_recommendLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-12));
            make.centerY.equalTo(_nameLabel.centerY);
            make.width.equalTo(@40);
            make.height.equalTo(@25);
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
            make.top.equalTo(_headerImage.bottom).offset(VertialSpace);
        }];
        
        // 图片
        _imageContentView = [[UIView alloc] init];
        _imageContentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_imageContentView];
        [_imageContentView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.right.equalTo(@(-12));
            make.top.equalTo(_infoLabel.bottom);
            make.height.equalTo(@0);
        }];
        
        // 小畅回答
        _replyContentView = [[UIView alloc] init];
        _replyContentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_replyContentView];
        [_replyContentView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.right.equalTo(@(-12));
            make.top.equalTo(_imageContentView.bottom);
            make.height.equalTo(@0);
        }];
        
        // 标签
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.backgroundColor = UIColorFromRGB(0xeeeeee);
        _tagLabel.textColor = CTXColor(118, 118, 118);
        _tagLabel.font = [UIFont systemFontOfSize:14.0];
        CTXViewBorderRadius(_tagLabel, 12.0, 0.8, UIColorFromRGB(CTXBLineViewColor));
        [self.contentView addSubview:_tagLabel];
        [_tagLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(_replyContentView.bottom).offset(VertialSpace);
            make.height.equalTo(@24);
            make.width.equalTo(@500);
        }];
        
        // 地址
        UIImageView *addressIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-sevenbabicon"]];
        [self.contentView addSubview:addressIV];
        addressIV.contentMode = UIViewContentModeScaleAspectFit;
        [addressIV makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(_tagLabel.bottom).offset(VertialSpace);
            make.width.equalTo(@10);
        }];
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.numberOfLines = 0;
        _addressLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _addressLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_addressLabel];
        [_addressLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(addressIV.right).offset(8);
            make.top.equalTo(addressIV.top);
            make.right.equalTo(@(-12));
        }];
        
        // 评论
        _commentBtn = [[UIButton alloc] init];
        _commentBtn.enabled = NO;
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
            make.right.equalTo(_commentBtn.left).offset(-20);
            make.width.equalTo(@0.8);
            make.height.equalTo(@20);
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
            make.right.equalTo(vertialView.left).offset(-20);
            make.centerY.equalTo(_commentBtn.centerY);
            make.height.equalTo(@40);
        }];
        
        // 分割线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self.contentView addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(@10);
        }];
    }
    
    return self;
}

- (void) setModel:(CarFriendCardModel *)model {
    _model = model;
    
    // 设置头像
    NSURL *url = [NSURL URLWithString:_model.userPhoto];
    [_headerImage setImageWithURL:url placeholder:[UIImage imageNamed:@"touxiang_85x85"]];
    // 设置名称
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@", model.nikeName, model.carName];
    // 时间
    _dateLabel.text = _model.createTime;
    
    // 是否推荐
    if (_model.isRecommend) {
        [_recommendLabel updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@35);
        }];
        [_nameLabel updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-59));
        }];
    } else {
        [_recommendLabel updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
        [_nameLabel updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-12));
        }];
    }
    
    // 设置内容
    _infoLabel.text = (_model.contents ? _model.contents : @"");
    [UILabel changeLineSpaceForLabel:_infoLabel WithSpace:5];
    _infoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    // 设置图片
    [_imageContentView removeAllSubviews];
    
    NSArray *images = [self imageListWithModel:model];
    if (images.count > 0) {
        // 图片的行数
        int line = (int)images.count / CountPerLine + (((int)images.count % CountPerLine) == 0 ? 0 : 1);
        // 更新_imageContentView的高度
        [_imageContentView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(VertialSpace + line * (HeightPerImage + LineSpacePerImage)));
        }];
        
        // 添加图片
        [self addImageContentView];
    } else {
        [_imageContentView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
    
    // 设置小畅回答
    [_replyContentView removeAllSubviews];
    if (_model.replyContents && ![_model.replyContents isEqualToString:@""]) {
        [_replyContentView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(5 + 80));
        }];
        
        [self addReplyContentView];
    } else {
        [_replyContentView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
    
    // 设置标签
    if (_model.tagName && ![_model.tagName isEqualToString:@""]) {
        _tagLabel.text = _model.tagName;
        CGFloat width = [_tagLabel labelHeightWithLineSpace:0 WithWidth:CTXScreenWidth WithNumline:1].width;
        [_tagLabel updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(width + 20);
            make.top.equalTo(_replyContentView.bottom).offset(VertialSpace);
            make.height.equalTo(24);
        }];
    } else {
        [_tagLabel updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_replyContentView.bottom);
            make.width.equalTo(@0);
            make.height.equalTo(@0);
        }];
    }
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置地址
    _addressLabel.text = _model.address;
    [UILabel changeLineSpaceForLabel:_addressLabel WithSpace:4];
    
    // 点赞
    NSString *goodTitle = [NSString stringWithFormat:@" %@", (_model.laudCount ? _model.laudCount : @"0")];
    [_goodBtn setTitle:goodTitle forState:UIControlStateNormal];
    if (_model.isLaud) {
        [_goodBtn setImage:[UIImage imageNamed:@"carFrienddianz_q_h"] forState:UIControlStateNormal];
    } else {
        [_goodBtn setImage:[UIImage imageNamed:@"carFrienddianz_q"] forState:UIControlStateNormal];
    }
    
    // 评论
    NSString *commentTitle = [NSString stringWithFormat:@" %@", (_model.commandCount ? _model.commandCount : @"0")];
    [_commentBtn setTitle:commentTitle forState:UIControlStateNormal];
}

// 根绝数据计算cell的高度
- (CGFloat)heightForModel:(CarFriendCardModel *)model {
    CGFloat height = 0;
    
    height += VertialSpace;     // 头像层上边距
    height += 50;               // 头像层的高度
    
    height += VertialSpace;     // 内容的上边距
    _infoLabel.text = (model.contents ? model.contents : @"");
    CGFloat infoHeight = [_infoLabel labelHeightWithLineSpace:5 WithWidth:(CTXScreenWidth-24) WithNumline:2].height;
    height += infoHeight;       // 内容的高度
    
    NSArray *images = [self imageListWithModel:model];
    if (images.count > 0) {
        int line = (int)(images.count / CountPerLine + ((images.count % CountPerLine) == 0 ? 0 : 1));
        height += VertialSpace + line * (HeightPerImage + LineSpacePerImage);   // 图片的高度
    }
    
    // 小畅回答
    if (model.replyContents && ![model.replyContents isEqualToString:@""]) {
        height += 5 + 80;       // 小畅回答的高度
    }
    
    // 标签
    if (model.tagName && ![model.tagName isEqualToString:@""]) {
        height += VertialSpace; // 标签的上边距
        height += 24;           // 标签的高度
    }
    
    height += VertialSpace;     // 地址的上边距
    _addressLabel.text = model.address;     // 地址的高度
    height += [_addressLabel labelHeightWithLineSpace:4 WithWidth:(CTXScreenWidth-42) WithNumline:0].height - 2;
    
    // 点赞 评论
    height += 40;
    
    height += 10;               // 分割线高度的上边距
    height += 10;               // 分割线高度
    
    return height;
}

#pragma mark - private method

- (void) addImageContentView {
    if (!imageViewArray) {
        imageViewArray = [[NSMutableArray alloc] init];
    } else {
        [imageViewArray removeAllObjects];
    }
    
    NSArray *images = [self imageListWithModel:_model];
    for (int i = 0; i < images.count; i++) {
        CarFriendUserCommentModel *model = images[i];
        
        UIImageView *iv = [[UIImageView alloc] init];
        iv.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        
        // 设置image
        NSURL *url = [NSURL URLWithString:model.image];
        [iv setImageWithURL:url placeholder:[UIImage imageNamed:@"z_l"]];
        
        [_imageContentView addSubview:iv];
        [iv makeConstraints:^(MASConstraintMaker *make) {
            // 距左
            CGFloat left = (i % CountPerLine) * (WidthPerImage + HorizontalSpacePerImage);
            make.left.equalTo(left);
            // 距上
            CGFloat top = 15 + (i / CountPerLine) * (HeightPerImage + LineSpacePerImage);
            make.top.equalTo(top);
            
            make.width.equalTo(WidthPerImage);
            make.height.equalTo(HeightPerImage);
        }];
        
        // 图片的模式
        iv.contentMode = UIViewContentModeScaleAspectFit;
        [imageViewArray addObject:iv];
        
        // 添加单击手势
        iv.tag = i;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageInWindow:)];
        iv.userInteractionEnabled = YES;
        [iv addGestureRecognizer:gesture];
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
    replyLabel.text = [NSString stringWithFormat:@"小畅：%@", _model.replyContents];
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

#pragma mark - event response

// 显示大图
- (void) showImageInWindow:(UITapGestureRecognizer*) gesture {
    UIImageView *iv = (UIImageView *) gesture.view;
    int index = (int) iv.tag;   // 当前选中图片的下标
    
    NSMutableArray* pics = [[NSMutableArray alloc] init];
    
    NSArray *images = [self imageListWithModel:_model];
    for (int i = 0; i < images.count; i++) {
        CarFriendUserCommentModel *model = images[i];
        
        // 图片的对象
        PicInfo* pic = [[PicInfo alloc] init];
        // 设置图片的url路径
        [pic setImageURL:model.image];
        
        if ([imageViewArray count] > i) {
            UIImageView *imageView = imageViewArray[i];
            // 设置图片的image
            [pic setImage:imageView.image];
            // 设置图片在列表中的frame
            pic.picOldFrame = [imageView convertRect:imageView.bounds toView:[AppDelegate sharedDelegate].window];
        }
        
        [pics addObject:pic];
    }
    
    ShowPictureView* picShowView = [[ShowPictureView alloc] init];
    [picShowView createUIWithPicInfoArr:pics andIndex:index];
}

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

// 截取前3张图片
- (NSArray *) imageListWithModel:(CarFriendCardModel *)model {
    if (model.imageList) {
        if (model.imageList.count > 3) {
            return [model.imageList subarrayWithRange:NSMakeRange(0, 3)];
        } else {
            return model.imageList;
        }
    } else {
        return @[];
    }
}

@end
