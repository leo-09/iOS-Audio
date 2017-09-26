//
//  CCarFriendInfoChangCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarFriendCardModel.h"

typedef void (^ClickGoodListener)(id result);

/**
 问小畅、随手拍详情View的 小畅说Cell
 */
@interface CCarFriendInfoChangCell : UITableViewCell

// 帖子详情
@property (nonatomic, retain) CarFriendCardModel *model;

@property (nonatomic, retain) UIView *lineView;     // 分隔线
@property (nonatomic, retain) UILabel *label;       // 小畅说
@property (nonatomic, retain) UILabel *replyLabel;  // 小畅说内容
@property (nonatomic, retain) UIButton *goodBtn;    // 点赞

@property (nonatomic, copy) ClickGoodListener clickGoodListener;

- (CGFloat)heightForModel:(CarFriendCardModel *)model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
