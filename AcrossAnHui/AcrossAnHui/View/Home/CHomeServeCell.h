//
//  CHomeServeTableViewCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServeModel.h"

typedef void (^SelectCellModelListener)(id result);

/**
 首页的 服务 第2个cell
 */
@interface CHomeServeCell : UITableViewCell

@property (nonatomic, retain) NSArray<ServeModel *> *serveModels;

@property (nonatomic, retain) UIView *bgView;

@property (nonatomic, copy) SelectCellModelListener selectServeListener;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
