//
//  CSubmitRecordTCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSubmitRecordTCell : UITableViewCell

@property (nonatomic, retain) NSMutableArray<UILabel *> *labels;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end