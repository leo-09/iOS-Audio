//
//  CAddressForPublishcell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarFriendMAPointAnnotation.h"

/**
 发表 问小畅、随手拍 和报路况 选择当前位置 cell
 */
@interface CAddressForPublishcell : UITableViewCell

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *addressLabel;

@property (nonatomic, retain) CarFriendMAPointAnnotation *anno;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
