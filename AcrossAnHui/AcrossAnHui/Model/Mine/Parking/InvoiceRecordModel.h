//
//  InvoiceRecordModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/24.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"
#import <UIKit/UIKit.h>

/**
 发票申请记录Model
 */
@interface InvoiceRecordModel : CTXBaseModel

@property (nonatomic, copy) NSString *addeddate;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *flag;
@property (nonatomic, copy) NSString *petitioner;
@property (nonatomic, copy) NSString *petitionermoney;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *userid;

@property (nonatomic, assign) int currentPage;

@property (nonatomic, assign) BOOL isShowSelected;  // 是否显示列表
@property (nonatomic, assign) BOOL isSelected;      // 列表中的是否选中
@property (nonatomic, assign) CGFloat cellHeight;   // cell高度

@end
