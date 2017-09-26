//
//  ParkRecordHeadView.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParkRecordHeadView : UIView{
    void (^selectCarListener)(NSString *plateNumber,NSString * value);
   
    NSString * plateNumber;
    NSString * value;
    CGFloat hight;
}
@property(nonatomic,retain)NSMutableArray * dataArr;
- (void) setSelectCarListener:(void (^)(NSString *plateNumber,NSString * value))listener;

-(void)freshData:(NSMutableArray *)dataArr;
- (instancetype)initWithFrame:(CGRect)frame dataArr:(NSMutableArray *)dataArr;
@end
