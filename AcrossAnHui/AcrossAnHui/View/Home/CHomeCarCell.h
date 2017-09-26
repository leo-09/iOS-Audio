//
//  CHomeCarCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarIllegalInfoModel.h"

typedef void (^SelectCellModelListener)(id result);

/**
 首页的 车辆信息 第1个cell
 */
@interface CHomeCarCell : UITableViewCell<UIScrollViewDelegate>

@property (nonatomic, retain) NSArray<CarIllegalInfoModel *> *carIllegals;

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIView *scrollContentView;
@property (nonatomic, retain) UIPageControl *pageControl;

@property (nonatomic, copy) SelectCellModelListener selectCarListener;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
