//
//  CTrafficRecordCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarFriendTrafficRecordModel.h"

@interface CTrafficRecordCell : UITableViewCell {
    NSMutableArray *imageViewArray;     // 帖子的所有ImageView
}

@property (nonatomic, retain) CarFriendTrafficRecordModel *model;

@property (nonatomic, retain) UIImageView *statusIV;    // 审核状态背景图
@property (nonatomic, retain) UILabel *statusLabel;     // 审核状态
@property (nonatomic, retain) UIImageView *timeIV;      // 时间背景图
@property (nonatomic, retain) UILabel *timeLabel;       // 时间
@property (nonatomic, retain) UILabel *infoLabel;       // 事件的说明
@property (nonatomic, retain) UIView *imageContentView; // 图片
@property (nonatomic, retain) UIView *replyContentView; // 小畅回答
@property (nonatomic, retain) UILabel *tagLabel;        // 事件的状态
@property (nonatomic, retain) UIImageView *addressIV;   // 定位图片
@property (nonatomic, retain) UILabel *addressLabel;    // 定位的地址

@property (nonatomic, copy) ClickListener deleteRecordListener;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (CGFloat)heightForModel:(CarFriendTrafficRecordModel *)model;

@end
