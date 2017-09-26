//
//  CInvoiceRecordCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvoiceRecordModel.h"

@interface CInvoiceRecordCell : UITableViewCell

@property (nonatomic, retain) UIButton *selectBtn;              // 多选按钮
@property (nonatomic, retain) UILabel *petitionerLabel;         // 申请人
@property (nonatomic, retain) UILabel *petitionermoneyLabel;    // 申请金额
@property (nonatomic, retain) UILabel *addeddateLabel;          // 申请时间
@property (nonatomic, retain) UILabel *addressLabel;            // 邮寄地址

@property (nonatomic, retain) InvoiceRecordModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (CGFloat)heightForModel:(InvoiceRecordModel *)model;

@end
