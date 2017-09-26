//
//  CarInspectStationCommentView.h
//  AcrossAnHui
//
//  Created by ztd on 2017/8/9.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "SubscribeModel.h"
#import "CarInspectStationModel.h"

@interface CarInspectStationCommentView : CTXBaseView{
    void (^submitListener)(NSString *  assessStar,NSString * textViewStr,NSString * businessid);
}

@property (nonatomic, retain) SubscribeModel *model;
@property (nonatomic ,strong) UIButton * onePhotoBtn;
@property (nonatomic ,strong) UIButton * twoPhotoBtn;
@property (nonatomic ,strong) UIButton * threePhotoBtn;

@property (nonatomic, copy) SelectCellListener submitPhotoListener;

- (instancetype)initWithFrame:(CGRect)frame model:(SubscribeModel *)model ;
-(void)getChangeBtnImage:(int)tag data:(NSData *)data;
-(void)setSubmitListener:(void (^)(NSString *  assessStar,NSString * textViewStr,NSString * businessid))listener;
-(void)refreshData:(CarInspectStationModel *)stationModel;

@end
