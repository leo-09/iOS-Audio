//
//  ParkRecordDetailView.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkRecordModel.h"

@interface ParkRecordDetailView : UIView {
    void (^selectCellListener)();
}

@property (retain,nonatomic)ParkRecordModel * model;

- (void) setSelectCellListener:(void (^)())listener;
-(void) freshData:(NSArray *)dataArr;

@end
