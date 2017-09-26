//
//  CarInspetAppointmentViewController.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/10.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"
#import "CarInspectStationModel.h"
#import "BoundCarModel.h"

/**
 车检预约（生成订单界面）
 */
@interface CarInspetAppointmentViewController : CTXBaseTableViewController
@property (weak, nonatomic) IBOutlet UIImageView *timeImg;
@property (weak, nonatomic) IBOutlet UIImageView *dateImg;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *stationNoteLab;//不支持在线吃饭
@property (weak, nonatomic) IBOutlet UILabel *stationLab;
@property (weak, nonatomic) IBOutlet UIImageView *sevenImage;
@property (weak, nonatomic) IBOutlet UIImageView *sixImage;
@property (weak, nonatomic) IBOutlet UILabel *onlineNoteLab;
@property (weak, nonatomic) IBOutlet UILabel *onLineLab;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *timeTF;
@property (weak, nonatomic) IBOutlet UITextField *dateTF;
@property (weak, nonatomic) IBOutlet UIImageView *stationImage;
@property (weak, nonatomic) IBOutlet UIImageView *onLineImage;

@property (nonatomic, retain) CarInspectStationModel * model;
@property (nonatomic, retain) BoundCarModel *carModel;

- (instancetype) initWithStoryboard;

@end
