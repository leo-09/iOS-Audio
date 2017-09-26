//
//  CHomeHeadlinesCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 今日头条 第3个cell
 */
@interface CHomeHeadlinesCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, copy) ClickListener moreNewsInfoClickListener;

@end
