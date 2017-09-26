//
//  CCarFriendInfoCommentCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarFriendUserCommentModel.h"

typedef void (^ClickGoodListener)(id result);

/**
 问小畅、随手拍详情View的 车友评论Cell
 */
@interface CCarFriendInfoCommentCell : UITableViewCell

@property (nonatomic, retain) CarFriendUserCommentModel *model;

@property (nonatomic, retain) UILabel *noCommentLabel;      // 暂无评论
@property (nonatomic, retain) UIImageView *headerImage;     // 头像
@property (nonatomic, retain) UILabel *nameLabel;           // 名字
@property (nonatomic, retain) UILabel *dateLabel;           // 时间
@property (nonatomic, retain) UILabel *infoLabel;           // 内容
@property (nonatomic, retain) UIButton *goodBtn;            // 点赞
@property (nonatomic, retain) UIView *lineView;             // 分隔线

@property (nonatomic, copy) ClickGoodListener clickGoodListener;

- (void) setModel:(CarFriendUserCommentModel *)model isLastCell:(BOOL)isLastCell;
- (CGFloat)heightForModel:(CarFriendUserCommentModel *)model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
