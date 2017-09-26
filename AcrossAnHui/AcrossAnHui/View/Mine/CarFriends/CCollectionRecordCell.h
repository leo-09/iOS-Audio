//
//  CCollectionRecordCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarFriendCommentModel.h"

@interface CCollectionRecordCell : UITableViewCell

@property (nonatomic, retain) CarFriendCommentModel *model;

@property (nonatomic, retain) UILabel *typeLabel;           // 公告、问小畅、随手拍
@property (nonatomic, retain) UILabel *recommendLabel;      // 推荐
@property (nonatomic, retain) UIButton *deleteBtn;
@property (nonatomic, retain) UILabel *infoLabel;
@property (nonatomic, retain) UIImageView *addressIV;       // 地址图标
@property (nonatomic, retain) UILabel *addressLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UIButton *goodBtn;            // 点赞
@property (nonatomic, retain) UIButton *commentBtn;         // 评论

@property (nonatomic, copy) ClickListener deleteRecordListener;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (CGFloat)heightForModel:(CarFriendCommentModel *)model;


@end
