//
//  PrideGainerInfoCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/10.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GainPrideListener)(NSString *name, NSString *phone);

@interface PrideGainerInfoCell : UITableViewCell

@property (nonatomic, retain) UITextField *nameTextField;
@property (nonatomic, retain) UITextField *phoneTextField;

@property (nonatomic, strong) ClickListener closeListener;
@property (nonatomic, strong) GainPrideListener gainPrideListener;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
