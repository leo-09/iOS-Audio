//
//  OneListSelectorViewCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneListSelectorModel : NSObject

@property (nonatomic, copy) NSString *modelID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isMultiSelect;// 是否多选

@end

@interface OneListSelectorViewCell : UITableViewCell

@property (nonatomic, retain) OneListSelectorModel *model;

@property (nonatomic, retain) UIImageView *iv;
@property (nonatomic, retain) UILabel *label;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
