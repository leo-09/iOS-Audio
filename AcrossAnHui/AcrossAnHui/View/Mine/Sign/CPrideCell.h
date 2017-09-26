//
//  CPrideCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPrideCell : UITableViewCell

@property (nonatomic, retain) UILabel *prideLabel;          // 奖品名称
@property (nonatomic, retain) UILabel *receivedTimeLabel;   // 领取时间
@property (nonatomic, retain) UILabel *receivedLabel;       // 已领取
@property (nonatomic, retain) UILabel *expiredLabel;        // 未领取
@property (nonatomic, retain) UILabel *gainLabel;            // 领取

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void) updateIamgeViewBottom;
- (void) updateLastIamgeViewBottom;

@end
