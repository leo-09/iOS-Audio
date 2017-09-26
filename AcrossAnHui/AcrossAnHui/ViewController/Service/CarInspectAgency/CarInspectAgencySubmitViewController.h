//
//  CarInspectAgencySubmitViewController.h
//  AcrossAnHui
//
//  Created by ztd on 2017/8/2.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"
#import "CarInspectStationModel.h"
#import "BoundCarModel.h"

/**
 车检代办  提交申请
 */
@interface CarInspectAgencySubmitViewController : CTXBaseTableViewController

@property (weak, nonatomic) IBOutlet UITextField *goodTF;//优惠码
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UILabel *plateLab;//车牌号码
@property (weak, nonatomic) IBOutlet UILabel *addressLab;//取车地址
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;//预约时间
@property (weak, nonatomic) IBOutlet UITextField *nameTF;//联系人

@property (nonatomic, strong)CarInspectStationModel * stationModel;
@property (nonatomic, retain)BoundCarModel * carModel;
@property (nonatomic, assign)double latStr;
@property (nonatomic, assign)double lngStr;
@property (nonatomic, copy) NSString *addressStr;

- (instancetype) initWithStoryboard;

@end
