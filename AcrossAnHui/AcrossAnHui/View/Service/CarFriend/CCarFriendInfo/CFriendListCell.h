//
//  CFriendListCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/3.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarFriendHeadImageModel.h"

@interface CFriendListCell : UITableViewCell

@property (nonatomic, retain) CarFriendHeadImageModel *model;

@property (nonatomic, retain) UIImageView *headerImage;     // 头像
@property (nonatomic, retain) UILabel *nameLabel;           // 名字
@property (nonatomic, retain) UILabel *dateLabel;           // 时间
@property (nonatomic, retain) UIView *lineView;             // 分隔线

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void) setModel:(CarFriendHeadImageModel *)model isLastCell:(BOOL) isLastCell;

@end
