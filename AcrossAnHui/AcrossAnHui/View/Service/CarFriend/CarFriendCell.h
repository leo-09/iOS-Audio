//
//  CarFriendCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarFriendCardModel.h"

typedef void (^SelectCellModelListener)(id result);

@interface CarFriendCell : UITableViewCell {
    NSMutableArray *imageViewArray;     // 帖子的所有ImageView
}

@property (nonatomic, retain) UIImageView *headerImage;     // 头像
@property (nonatomic, retain) UILabel *nameLabel;           // 名字
@property (nonatomic, retain) UILabel *dateLabel;           // 时间
@property (nonatomic, retain) UILabel *recommendLabel;      // 是否推荐
@property (nonatomic, retain) UILabel *infoLabel;           // 内容
@property (nonatomic, retain) UIView *imageContentView;     // 图片
@property (nonatomic, retain) UIView *replyContentView;     // 小畅回答
@property (nonatomic, retain) UILabel *tagLabel;            // 标签
@property (nonatomic, retain) UILabel *addressLabel;        // 地址
@property (nonatomic, retain) UIButton *goodBtn;            // 点赞
@property (nonatomic, retain) UIButton *commentBtn;         // 评论

@property (nonatomic, retain) CarFriendCardModel *model;

@property (nonatomic, copy) SelectCellModelListener clickGoodListener;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (CGFloat)heightForModel:(CarFriendCardModel *)model;

@end
