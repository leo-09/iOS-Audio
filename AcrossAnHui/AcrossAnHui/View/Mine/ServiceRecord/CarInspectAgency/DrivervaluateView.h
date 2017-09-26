//
//  DrivervaluateView.h
//  AcrossAnHui
//
//  Created by ztd on 2017/8/9.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "CarInspectAgencyOrderModel.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface DrivervaluateView : CTXBaseView{
    void (^submitListener)(DBCarInfoModel *  AgencyOrderModel,NSString * textViewStr,CGFloat speed,CGFloat server);
}

@property (nonatomic ,copy) DBCarInfoModel * agencyOrderModel;
@property (nonatomic, copy) LoadDataListener submitReasonListener;

-(void)setSubmitListener:(void (^)(DBCarInfoModel *  AgencyOrderModel,NSString * textViewStr,CGFloat speed,CGFloat server))listener;

@end
