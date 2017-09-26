//
//  CCarFriendInfoCardCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CCarFriendInfoCardCell.h"
#import "Masonry.h"
#import "YYKit.h"
#import "UILabel+lineSpace.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "PicInfo.h"
#import "ShowPictureView.h"
#import "AppDelegate.h"

#define VertialSpace 15         // 竖直间距
#define ImageViewHeight ((CTXScreenWidth-24) * 2 / 3)

@implementation CCarFriendInfoCardCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CCarFriendInfoCardCell";
    CCarFriendInfoCardCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CCarFriendInfoCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        _infoLabel.numberOfLines = 0;
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
        
        // 标签
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.backgroundColor = UIColorFromRGB(0xeeeeee);
        _tagLabel.textColor = CTXColor(118, 118, 118);
        _tagLabel.font = [UIFont systemFontOfSize:14.0];
        CTXViewBorderRadius(_tagLabel, 12.0, 0.8, UIColorFromRGB(CTXBLineViewColor));
        [self.contentView addSubview:_tagLabel];
        [_tagLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(_imageContentView.bottom).offset(VertialSpace);
            make.height.equalTo(@24);
            make.width.equalTo(@0);
        }];
        
        // 地址
        _addressIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-sevenbabicon"]];
        [self.contentView addSubview:_addressIV];
        [_addressIV makeConstraints:^(MASConstraintMaker *make) {
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
            make.left.equalTo(_addressIV.right).offset(8);
            make.top.equalTo(_addressIV.top).offset(-2);
            make.right.equalTo(@(-12));
        }];
        
        // 评论
        _commentBtn = [[UIButton alloc] init];
        [_commentBtn setTitleColor:UIColorFromRGB(CTXBaseFontColor) forState:UIControlStateNormal];
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_commentBtn setTitle:@" 0" forState:UIControlStateNormal];
        [_commentBtn setImage:[UIImage imageNamed:@"carFriendpingl_1"] forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchDown];
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
        _goodBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_goodBtn setTitle:@" 0" forState:UIControlStateNormal];
        [_goodBtn setImage:[UIImage imageNamed:@"carFrienddianz_q"] forState:UIControlStateNormal];
        [_goodBtn addTarget:self action:@selector(goodClick) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:_goodBtn];
        [_goodBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(vertialView.left).offset(-20);
            make.centerY.equalTo(_commentBtn.centerY);
            make.height.equalTo(@40);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"点赞, 助ta上头条";
        label.textColor = UIColorFromRGB(CTXBaseFontColor);
        label.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_goodBtn.centerY).offset(2);
            make.right.equalTo(_goodBtn.left).offset(-10);
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
    NSString *nikeName = _model.nikeName ? _model.nikeName : @"--";
    NSString *carName = _model.carName ? _model.carName : @"--";
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@", nikeName, carName];
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
    _infoLabel.text = _model.contents ? _model.contents : @"";
    [UILabel changeLineSpaceForLabel:_infoLabel WithSpace:6];
    _infoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    // 设置图片
    [_imageContentView removeAllSubviews];
    if (_model.imageList && _model.imageList.count > 0) {
        // 添加图片
        [self addImageContentView];
    } else {
        [_imageContentView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
    
    // 设置标签
    if (_model.tagName && ![_model.tagName isEqualToString:@""]) {
        _tagLabel.text = _model.tagName;
        CGFloat width = [_tagLabel labelHeightWithLineSpace:0 WithWidth:CTXScreenWidth WithNumline:1].width;
        [_tagLabel updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(width + 20);
            make.top.equalTo(_imageContentView.bottom).offset(VertialSpace);
            make.height.equalTo(24);
        }];
    } else {
        [_tagLabel updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imageContentView.bottom);
            make.width.equalTo(@0);
            make.height.equalTo(@0);
        }];
    }
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置地址
    if (_model.address && ![_model.address isEqualToString:@""]) {
        _addressLabel.text = _model.address;
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
    CGFloat infoHeight = [_infoLabel labelHeightWithLineSpace:6 WithWidth:(CTXScreenWidth-24) WithNumline:0].height;
    height += infoHeight;       // 内容的高度
    
    if (model.imageList && model.imageList.count > 0) {
        height += model.imageList.count * (ImageViewHeight + VertialSpace);    // 图片的高度
    }
    
    // 标签
    if (model.tagName && ![model.tagName isEqualToString:@""]) {
        height += VertialSpace; // 标签的上边距
        height += 24;           // 标签的高度
    }
    
    height += VertialSpace; // 地址的上边距
    if (model.address && ![model.address isEqualToString:@""]) {
        _addressLabel.text = model.address;
        // 地址的高度
        height += [_addressLabel labelHeightWithLineSpace:4 WithWidth:(CTXScreenWidth-42) WithNumline:0].height;
    }
    
    height += 40;       // 点赞 评论
    height += 10;       // 点赞 评论的下边距
    
    return height;
}

#pragma mark - private method

- (void) addImageContentView {
    if (!imageViewArray) {
        imageViewArray = [[NSMutableArray alloc] init];
    } else {
        [imageViewArray removeAllObjects];
    }
    
    UIImageView *lastIV;
    for (int i = 0; i < _model.imageList.count; i++) {
        CarFriendUserCommentModel *model = _model.imageList[i];
        
        UIImageView *iv = [[UIImageView alloc] init];
        // 设置image
        NSURL *url = [NSURL URLWithString:model.image];
        [iv setImageWithURL:url placeholder:[UIImage imageNamed:@"z_l"]];
        [_imageContentView addSubview:iv];
        [iv makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            if (lastIV) {
                make.top.equalTo(lastIV.bottom).offset(VertialSpace);
            } else {
                make.top.equalTo(VertialSpace);
            }
            make.height.equalTo(ImageViewHeight);
        }];
        
        iv.contentMode = UIViewContentModeScaleAspectFit;
        lastIV = iv;
        [imageViewArray addObject:iv];
        
        // 添加单击手势
        iv.tag = i;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageInWindow:)];
        iv.userInteractionEnabled = YES;
        [iv addGestureRecognizer:gesture];
    }
    
    [_imageContentView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(_model.imageList.count * (ImageViewHeight + VertialSpace));
    }];
}

// 点赞
- (void) goodClick {
    //  此处必须先带着原model回调,不可在下面修改之后回调
    CarFriendCardModel *copyModel = [self.model ctxCopy];
    
    int laudCount = [_model.laudCount intValue];
    if (_model.isLaud) {
        // 原来点赞，则取消点赞
        _model.isLaud = NO;
        
        // 在列表中 删除当前用户头像
        CarFriendHeadImageModel *deleteItem;
        for (CarFriendHeadImageModel *item in _model.headImageList) {
            if ([item.headImage isEqualToString:self.userPhoto]) {
                deleteItem = item;
                break;
            }
        }
        
        if (deleteItem && [_model.headImageList containsObject:deleteItem]) {
            [_model.headImageList removeObject:deleteItem];
        }
        
        laudCount--;
        [_goodBtn setImage:[UIImage imageNamed:@"carFrienddianz_q"] forState:UIControlStateNormal];
    } else {
        // 原来没有点赞，则添加点赞
        _model.isLaud = YES;
        
        // 将当前用户头像加到列表中
        CarFriendHeadImageModel *ivModel = [[CarFriendHeadImageModel alloc] init];
        ivModel.headImage = self.userPhoto;
        [_model.headImageList addObject:ivModel];
        
        laudCount++;
        [_goodBtn setImage:[UIImage imageNamed:@"carFrienddianz_q_h"] forState:UIControlStateNormal];
    }
    
    NSString *goodTitle = [NSString stringWithFormat:@" %d", laudCount];
    _model.laudCount = goodTitle;
    [_goodBtn setTitle:goodTitle forState:UIControlStateNormal];
    
    if (self.clickGoodListener) {
        self.clickGoodListener(self.model, copyModel);
    }
}

// 评论
- (void) commentClick {
    if (self.clickCommentListener) {
        self.clickCommentListener(self.model, nil);
    }
}

// 显示大图
- (void) showImageInWindow:(UITapGestureRecognizer*) gesture {
    UIImageView *iv = (UIImageView *) gesture.view;
    int index = (int) iv.tag;   // 当前选中图片的下标
    
    NSMutableArray* pics = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _model.imageList.count; i++) {
        CarFriendUserCommentModel *model = _model.imageList[i];
        
        // 图片的对象
        PicInfo* pic = [[PicInfo alloc] init];
        // 设置图片的url路径
        [pic setImageURL:model.image];
        
        // 设置图片的image
        UIImageView *iv = imageViewArray[i];
        [pic setImage:iv.image];
        
        if ([imageViewArray count] > index) {
            // 设置图片在列表中的frame.因为这里有的图不在屏幕内，所以只保存当前选中图的frame
            UIImageView *imageView = imageViewArray[index];
            pic.picOldFrame = [imageView convertRect:imageView.bounds toView:[AppDelegate sharedDelegate].window];
        }
        
        [pics addObject:pic];
    }
    
    ShowPictureView* picShowView = [[ShowPictureView alloc] init];
    [picShowView createUIWithPicInfoArr:pics andIndex:index];
}

@end
