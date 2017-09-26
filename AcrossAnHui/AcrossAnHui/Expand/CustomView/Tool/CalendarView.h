//
//  CalendarView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "BSLCalendar.h"

/**
 日期选择器
 */
@interface CalendarView : CTXBaseView<CAAnimationDelegate>

@property (nonatomic, retain) BSLCalendar *calendar;

@property (nonatomic, assign) BOOL isLater;// 是否大于当前日期

@property (nonatomic, copy) SelectCellModelListener selectDateListener;

- (void) showView;

@end
