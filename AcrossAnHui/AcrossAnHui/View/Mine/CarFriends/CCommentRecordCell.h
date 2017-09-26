//
//  CCommentRecordCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarFriendCommentModel.h"

@interface CCommentRecordCell : UITableViewCell

@property (nonatomic, retain) CarFriendCommentModel *model;

@property (nonatomic, retain) UILabel *typeLabel;           // 公告、问小畅、随手拍
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UIButton *deleteBtn;
@property (nonatomic, retain) UILabel *infoLabel;           // 帖子内容
@property (nonatomic, retain) UIView *replyContentView;     // 评论内容

@property (nonatomic, copy) ClickListener deleteRecordListener;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (CGFloat)heightForModel:(CarFriendCommentModel *)model;

@end
