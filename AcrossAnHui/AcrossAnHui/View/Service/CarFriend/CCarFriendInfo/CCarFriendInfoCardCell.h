//
//  CCarFriendInfoCardCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarFriendCardModel.h"

typedef void (^ClickCarFriendInfoListener)(id oldResult, id copyResult);

/**
 问小畅、随手拍详情View的 话题内容Cell
 */
@interface CCarFriendInfoCardCell : UITableViewCell {
    NSMutableArray *imageViewArray;     // 帖子的所有ImageView
}

// 帖子详情
@property (nonatomic, retain) CarFriendCardModel *model;
@property (nonatomic, copy) NSString *userPhoto;  // 当前用户的头像

@property (nonatomic, retain) UIImageView *headerImage;     // 头像
@property (nonatomic, retain) UILabel *nameLabel;           // 名字
@property (nonatomic, retain) UILabel *dateLabel;           // 时间
@property (nonatomic, retain) UILabel *recommendLabel;      // 是否推荐
@property (nonatomic, retain) UILabel *infoLabel;           // 内容
@property (nonatomic, retain) UIView *imageContentView;     // 图片
@property (nonatomic, retain) UILabel *tagLabel;            // 标签
@property (nonatomic, retain) UIImageView *addressIV;       // 地址图标
@property (nonatomic, retain) UILabel *addressLabel;        // 地址
@property (nonatomic, retain) UIButton *goodBtn;            // 点赞
@property (nonatomic, retain) UIButton *commentBtn;         // 评论

@property (nonatomic, copy) ClickCarFriendInfoListener clickGoodListener;
@property (nonatomic, copy) ClickCarFriendInfoListener clickCommentListener;

- (CGFloat)heightForModel:(CarFriendCardModel *)model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
