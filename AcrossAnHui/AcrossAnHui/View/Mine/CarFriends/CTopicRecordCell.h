//
//  CTopicRecordCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarFriendTopicModel.h"

@interface CTopicRecordCell : UITableViewCell {
//    NSMutableArray *imageViewArray;     // 帖子的所有ImageView
}

@property (nonatomic, retain) CarFriendTopicModel *model;

@property (nonatomic, retain) UILabel *typeLabel;           // 公告、问小畅、随手拍
@property (nonatomic, retain) UILabel *examineLabel;        // 审核
@property (nonatomic, retain) UILabel *recommendLabel;      // 推荐
@property (nonatomic, retain) UIButton *deleteBtn;
@property (nonatomic, retain) UILabel *infoLabel;
//@property (nonatomic, retain) UIView *imageContentView;     // 图片
@property (nonatomic, retain) UILabel *addressLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UIButton *goodBtn;            // 点赞
@property (nonatomic, retain) UIButton *commentBtn;         // 评论

@property (nonatomic, copy) ClickListener deleteRecordListener;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (CGFloat)heightForModel:(CarFriendTopicModel *)model;

@end
