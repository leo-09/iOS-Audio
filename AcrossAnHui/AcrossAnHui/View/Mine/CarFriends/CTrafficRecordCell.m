//
//  CTrafficRecordCell.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTrafficRecordCell.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "UILabel+lineSpace.h"
#import "Masonry.h"
#import "YYKit.h"
#import "PicInfo.h"
#import "ShowPictureView.h"
#import "AppDelegate.h"

#define CountPerLine 3              // 每行最多显示3张图片
#define LineSpacePerImage 10        // 每张图片的垂直间距
#define HorizontalSpacePerImage 10  // 每张图片的水平间距
// 每张图片的宽高
#define WidthPerImage (CTXScreenWidth - 24 - HorizontalSpacePerImage * 2) / CountPerLine
#define HeightPerImage WidthPerImage / 1.375

@implementation CTrafficRecordCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CTrafficRecordCell";
    // 1.缓存中
    CTrafficRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CTrafficRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        UIView *topLineView = [[UIView alloc] init];
        topLineView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self.contentView addSubview:topLineView];
        [topLineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@10);
        }];
        
        // 审核状态背景图
        _statusIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sh_1"]];
        [self.contentView addSubview:_statusIV];
        [_statusIV makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.left.equalTo(@12);
        }];
        
        // 审核状态
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        [self.contentView addSubview:_statusLabel];
        [_statusLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_statusIV.left).offset(4);
            make.right.equalTo(_statusIV.right).offset(-6);
            make.top.equalTo(_statusIV.top);
            make.bottom.equalTo(_statusIV.bottom);
        }];;
        
        // 时间
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _timeLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@16);
            make.right.equalTo(@(-12));
        }];
        
        // 时间背景图
        _timeIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"date"]];
        [self.contentView addSubview:_timeIV];
        [_timeIV makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_timeLabel.centerY);
            make.right.equalTo(_timeLabel.left).offset(-6);
        }];

        // 事件的说明
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
        _infoLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _infoLabel.numberOfLines = 0;
        [self.contentView addSubview:_infoLabel];
        [_infoLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.right.equalTo(@(-12));
            make.top.equalTo(_statusIV.bottom).offset(12);
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
        
        // 事件的状态
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.backgroundColor = UIColorFromRGB(0xeeeeee);
        _tagLabel.textColor = CTXColor(118, 118, 118);
        _tagLabel.font = [UIFont systemFontOfSize:14.0];
        CTXViewBorderRadius(_tagLabel, 12.0, 0.8, UIColorFromRGB(CTXBLineViewColor));
        [self.contentView addSubview:_tagLabel];
        [_tagLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(_replyContentView.bottom).offset(12);
            make.height.equalTo(@24);
            make.width.equalTo(@500);
        }];
        
        // 地址
        UIImageView *addressIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-sevenbabicon"]];
        [self.contentView addSubview:addressIV];
        addressIV.contentMode = UIViewContentModeScaleAspectFit;
        [addressIV makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(_tagLabel.bottom).offset(12);
            make.width.equalTo(@10);
        }];
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.numberOfLines = 0;
        _addressLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        _addressLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_addressLabel];
        [_addressLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(addressIV.right).offset(8);
            make.top.equalTo(addressIV.top).offset(-1);
            make.right.equalTo(@(-12));
        }];
    }
    
    return self;
}

- (void) setModel:(CarFriendTrafficRecordModel *)model {
    _model = model;
    
    // 审核状态背景图
    _statusIV.image = [UIImage imageNamed:[_model statusImagePath]];
    // 审核状态
    _statusLabel.text = [_model statusDesc];
    
    // 时间
    _timeLabel.text = _model.createTime;
    
    // 事件的说明
    _infoLabel.text = (_model.desc ? _model.desc : @"");
    [UILabel changeLineSpaceForLabel:_infoLabel WithSpace:5];
    _infoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    // 设置图片
    [_imageContentView removeAllSubviews];
    NSArray *photos = [_model photos];
    if (photos && photos.count > 0) {
        // 图片的行数
        int line = (int)photos.count / CountPerLine + (((int)photos.count % CountPerLine) == 0 ? 0 : 1);
        // 更新_imageContentView的高度
        [_imageContentView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(12 + line * (HeightPerImage + LineSpacePerImage)));
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
    if (_model.resp && ![_model.resp isEqualToString:@""]) {
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
    if (_model.type && ![_model.type isEqualToString:@""]) {
        _tagLabel.text = _model.type;
        CGFloat width = [_tagLabel getLabelHeightWithLineSpace:0 WithWidth:CTXScreenWidth WithNumline:0].width;
        [_tagLabel updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(width + 20);
            make.top.equalTo(_replyContentView.bottom).offset(12);
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
    _addressLabel.text = _model.addr;
    [UILabel changeLineSpaceForLabel:_addressLabel WithSpace:4];
}

- (CGFloat)heightForModel:(CarFriendTrafficRecordModel *)model {
    CGFloat height = 0;
    
    height += 10;               // 分割线高度
    height += 21;               // 审核状态的高度
    
    height += 12;               // 内容的上边距
    _infoLabel.text = (model.desc ? model.desc : @"");
    CGFloat infoHeight = [_infoLabel getLabelHeightWithLineSpace:5 WithWidth:(CTXScreenWidth-24) WithNumline:0].height;
    height += infoHeight;       // 内容的高度
    
    NSArray *photos = [model photos];
    if (photos && photos.count > 0) {
        int line = (int)photos.count / CountPerLine + (((int)photos.count % CountPerLine) == 0 ? 0 : 1);
        height += 12 + line * (HeightPerImage + LineSpacePerImage);   // 图片的高度
    }
    
    // 小畅回答
    if (model.resp && ![model.resp isEqualToString:@""]) {
        height += 5 + 80;       // 小畅回答的高度
    }
    
    // 标签
    if (model.type && ![model.type isEqualToString:@""]) {
        height += 12;   // 标签的上边距
        height += 24;   // 标签的高度
    }
    
    height += 12;     // 地址的上边距
    _addressLabel.text = (model.addr ? model.addr : @"");     // 地址的高度
    height += [_addressLabel getLabelHeightWithLineSpace:4 WithWidth:(CTXScreenWidth-42) WithNumline:0].height;
    
    height += 12;               // 下边距
    
    return height;
}

// 删除记录
- (void) deleteRecord {
    if (self.deleteRecordListener) {
        self.deleteRecordListener();
    }
}

#pragma mark - private method

- (void) addImageContentView {
    if (!imageViewArray) {
        imageViewArray = [[NSMutableArray alloc] init];
    } else {
        [imageViewArray removeAllObjects];
    }
    
    NSArray *photos = [_model photos];
    for (int i = 0; i < photos.count; i++) {
        UIImageView *iv = [[UIImageView alloc] init];
        iv.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
        
        // 设置image
        NSURL *url = [NSURL URLWithString:photos[i]];
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
    replyLabel.text = _model.resp ? _model.resp : @"";
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
    
    NSArray *photos = [_model photos];
    for (int i = 0; i < photos.count; i++) {
        // 图片的对象
        PicInfo* pic = [[PicInfo alloc] init];
        // 设置图片的url路径
        [pic setImageURL:photos[i]];
        
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

@end
