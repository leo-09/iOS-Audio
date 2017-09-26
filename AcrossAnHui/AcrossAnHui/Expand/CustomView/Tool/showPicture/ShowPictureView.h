//
//  ShowPictureView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/4.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"

@interface ShowPictureView : CTXBaseView<UIScrollViewDelegate>

/**
 展现图片

 @param marr 保存图片模型的数组
 @param index 当前点击的图片
 */
- (void)createUIWithPicInfoArr:(NSMutableArray *)marr andIndex:(NSInteger)index;

@end
