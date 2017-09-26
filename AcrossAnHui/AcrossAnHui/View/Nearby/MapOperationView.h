//
//  MapOperationView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/1.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"

/**
 地图上的按钮
 */
@interface MapOperationView : CTXBaseView {
    UIButton *currentBtn;
    NSMutableArray *btnArray;
}

//@property (nonatomic, retain) NSArray *normalImages;
//@property (nonatomic, retain) NSArray *selectedImages;

@property (nonatomic, copy) SelectCellListener clickButtonListener;

- (void) setNormalImages:(NSArray *)normalImages selectedImages:(NSArray *)selectedImages;
- (void) deSelectedCurrentBtn;
- (void) clickButtonWithIndex:(int)index;

@end
