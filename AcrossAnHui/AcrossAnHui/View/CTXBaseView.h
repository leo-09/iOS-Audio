//
//  CTXBaseView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "YYKit.h"

// 选中cell
typedef void (^SelectCellListener)(int index);
typedef void (^SelectCellModelListener)(id result);

// 刷新
typedef void (^RefreshDataListener)(BOOL isRequestFailure);

// 加载
typedef void (^LoadDataListener)();

/**
 View的基类
 */
@interface CTXBaseView : UIView

- (void) showTextHubWithContent:(NSString *) content;

@end
