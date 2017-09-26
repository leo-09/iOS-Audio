//
//  CHotCarTypeCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/14.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectButtonModelListener)(NSString *result);

@interface CHotCarTypeCell : UITableViewCell

@property (nonatomic, strong) SelectButtonModelListener selectButtonModelListener;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
