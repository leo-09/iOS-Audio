//
//  CCarFriendInfoGoodCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarFriendCardModel.h"

/**
 问小畅、随手拍详情View的 显示点赞信息Cell
 */
@interface CCarFriendInfoGoodCell : UITableViewCell {
    NSMutableArray *imageViews;
}

// 帖子详情
@property (nonatomic, retain) CarFriendCardModel *model;

@property (nonatomic, retain) UILabel *descLabel;       // 多少人点赞
@property (nonatomic, retain) UILabel *ellipsisLabel;   // 省略号

- (CGFloat)heightForModel:(CarFriendCardModel *)model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
