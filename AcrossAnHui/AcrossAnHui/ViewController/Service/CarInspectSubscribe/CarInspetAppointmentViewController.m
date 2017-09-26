//
//  CarInspetAppointmentViewController.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/10.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspetAppointmentViewController.h"
#import "KLCDTextHelper.h"
#import "CalendarView.h"
#import "CarInspectNetData.h"
#import "StationOrderTime.h"
#import "CarInspectTimeView.h"
#import "DES3Util.h"
#import "SaveSubscribeModel.h"
#import "SubscribeModel.h"
#import "PayResultViewController.h"
#import "CarInspectOnlinePayViewController.h"

@interface CarInspetAppointmentViewController ()<UITextFieldDelegate>{
    
    NSString * payStatus;// 0 在线支付 1 车检站支付
}
@property (nonatomic, retain) CarInspectNetData *carInspectNetData;
@property (nonatomic ,retain) StationOrderTime * timeModel;

@end

@implementation CarInspetAppointmentViewController

- (instancetype) initWithStoryboard {
    
    return [[UIStoryboard storyboardWithName:@"CarInspectSubscribeView" bundle:nil] instantiateViewControllerWithIdentifier:@"CarInspetAppointmentViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"车检预约";
    _carInspectNetData = [[CarInspectNetData alloc] init];
    _carInspectNetData.delegate = self;
    [self createUI];
}

-(void)createUI{

    _dateTF.userInteractionEnabled = NO;
    _timeTF.userInteractionEnabled = NO;
    _nameTF.delegate = self;
    
    _nameTF.tag = 3;
    [self.nameTF addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.phoneTF.tag=4;
    self.phoneTF.delegate = self;
    [self.phoneTF addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    
    _submitBtn.layer.cornerRadius = 5;
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.userInteractionEnabled  = NO;
    
    //对支付状态进行处理
    _dateImg.image = [UIImage imageNamed:@""];
    _timeImg.image = [UIImage imageNamed:@""];
    if ([self.model.isCanOnlinePay isEqualToString:@"1"]) {
        //支付在线支付
        if ([_model.personyh isEqualToString:@"0"]) {
            _onLineLab.text = @"在线支付";
            _onlineNoteLab.text = @"";
            _onLineImage.image = [UIImage imageNamed:@"zaixianzhifu"];
        } else {
            _onLineImage.image = [UIImage imageNamed:@"zaixianzhifu"];
            _onLineLab.text = @"在线支付";
            _onlineNoteLab.text = [NSString stringWithFormat:@"在线支付可享受优惠%@元",_model.personyh];
            CGFloat noteWidth = [KLCDTextHelper WidthForText:_onlineNoteLab.text withFontSize:15 withTextHeight:15];
            _onlineNoteLab.frame = CGRectMake(52, 25, noteWidth+15, 15);
            _onlineNoteLab.textAlignment = NSTextAlignmentCenter;
            _onlineNoteLab.backgroundColor = [UIColor redColor];
            _onlineNoteLab.textColor = [UIColor whiteColor];
        }
        payStatus = @"0";
        _stationLab.text = @"到车检站支付";
        _stationNoteLab.text = @"";
        _stationImage.image = [UIImage imageNamed:@"chejianzhanzhifu"];
        _sixImage.image = [UIImage imageNamed:@"goux_car"];
        _sevenImage.image = [UIImage imageNamed:@"weigoux_car"];
    } else {
        // 不支付在线支付
        payStatus = @"1";
        _onLineLab.text = @"到车检站支付";
        _onlineNoteLab.text = @"";
        _sixImage.image = [UIImage imageNamed:@"goux_car"];
        _sevenImage.image = [UIImage imageNamed:@""];
        _onLineImage.image = [UIImage imageNamed:@"chejianzhanzhifu"];
        _stationImage.image = [UIImage imageNamed:@"zaixianzhifu"];
        
        _stationLab.text = @"在线支付";
        _stationNoteLab.text = @"本车检站不支持在线支付";
        CGFloat noteWidth = [KLCDTextHelper WidthForText:_onlineNoteLab.text withFontSize:15 withTextHeight:15];
        
        _stationNoteLab.frame = CGRectMake(52, 25, noteWidth+15, 15);
        _stationNoteLab.textAlignment = NSTextAlignmentCenter;
        _stationNoteLab.backgroundColor = CTXColor(108, 108, 108) ;
        _stationNoteLab.textColor = [UIColor whiteColor];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        // 日历
        CalendarView *calendarView = [[CalendarView alloc] init];
        calendarView.isLater = YES;
        @weakify(self)
        [calendarView setSelectDateListener:^(id result) {
            @strongify(self)
            [self dateCompare:(NSString *)result];
        }];
        [calendarView showView];
    } else if (indexPath.row==1) {
        //时间段
        if (self.dateTF.text.length<1) {
            [self showTextHubWithContent:@"请选择预约日期"];
            return;
        }
        [_carInspectNetData quertApptionmentTime:self.dateTF.text StationID:_model.stationid tag:@"apptionmentTime" ];
    } else if (indexPath.row==2) {
        //联系人
    } else if(indexPath.row==3) {
        //手机号
    } else if (indexPath.row==4) {
        //no
    } else if (indexPath.row==5) {
        _sixImage.image = [UIImage imageNamed:@"goux_car"];
        if ([_model.isCanOnlinePay isEqualToString:@"1"]) {
            payStatus = @"0";
             _sevenImage.image = [UIImage imageNamed:@"weigoux_car"];
        } else {
            payStatus = @"1";
             _sevenImage.image = [UIImage imageNamed:@""];
        }
    } else if (indexPath.row==6) {
        if ([_model.isCanOnlinePay isEqualToString:@"1"]) {
            //可以在线支付也可以到车检站
            payStatus = @"1";
            _sixImage.image = [UIImage imageNamed:@"weigoux_car"];
            _sevenImage.image = [UIImage imageNamed:@"goux_car"];
        } else {
           
        }
        
    } else if (indexPath.row==7){
        //提交按钮
        [self submitOrder];
    }
}

-(void)submitOrder{
    

    if (self.dateTF.text.length == 0) {
        [self showTextHubWithContent:@"请选择预约时间"];
        return ;
    } else if (self.timeTF.text.length == 0) {
        [self showTextHubWithContent:@"预约时间段不能为空"];
        return ;
    } else if (self.nameTF.text.length == 0) {
        [self showTextHubWithContent:@"请输入联系人"];
        return ;
    } else if (self.phoneTF.text.length == 0) {
        [self showTextHubWithContent:@"请输入手机号码"];
        return ;
    } else if ([DES3Util isMobileNumber:self.phoneTF.text]==NO) {
        [self showTextHubWithContent:@"联系人手机号格式不正确"];
        return ;
    }
    
    SaveSubscribeModel *model = [[SaveSubscribeModel alloc] init];
    [model setCarLisence:self.carModel.plateNumber];
    [model setLastFrame:self.carModel.frameNumber];
    [model setOrdertimeid:_timeModel.ordertimeid];
    [model setSubscribeDate:self.dateTF.text];
    [model setPaymethod:payStatus];
    [model setContactPerson:self.nameTF.text];
    [model setContactPhone:self.phoneTF.text];
    [model setCarType:self.carModel.plateType];
    [model setIsAutoReg:@"0"];
    [model setAvator:self.loginModel.photo];
    [model setPaymethod:@"0"];
    [model setBusinessType:@"1"];
    [model setStationid:_model.stationid];
    
    [self showHubWithLoadText:@"保存预约记录中..."];
    [_carInspectNetData saveSubscribeWithToken:self.loginModel.token subscribeMode:model cityName:nil tag:@"saveSubscribeTag"];
}

-(void)dateCompare:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *lastdate = [dateFormatter dateFromString:dateStr];
    if ([lastdate isEqualToDate:[[NSDate date] laterDate:lastdate]]) {
        //self.selectday表示临时选择的时间，与系统当前时间比较。此处比较结果为self.selectday大于系统当前时间
        NSInteger dis = 7; //前后的天数
        NSDate*nowDate = [NSDate date];
        NSDate* theDate;
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow: oneDay*dis ];
        if ([lastdate isEqualToDate:[theDate earlierDate:lastdate]]) {
            self.dateTF.text = dateStr;
            [self showHubWithLoadText:@"查询中..."];
            [_carInspectNetData quertApptionmentTime:self.dateTF.text StationID:_model.stationid tag:@"apptionmentTime" ];
        } else {
            [self showTextHubWithContent:@"请选择从第二天起一周之内的预约日期"];
            self.dateTF.placeholder = @"请选择预约日期";
        }
    } else {
        [self showTextHubWithContent:@"请选择从第二天起一周之内的预约日期"];
        self.dateTF.placeholder = @"请选择预约日期";
    }
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    if ([tag isEqualToString:@"apptionmentTime"]) {
        // 处理数据结果
        NSMutableArray * arr = [NSMutableArray array];
        
        for (NSDictionary * dic in (NSArray *)result) {
            StationOrderTime *models = [StationOrderTime convertFromDict:dic];
            [arr addObject:models];
        }
        
        CarInspectTimeView * timeView = [[CarInspectTimeView alloc]initWithFrame:CGRectMake(0, 0, CTXScreenWidth, CTXScreenHeight) arr:(NSArray *)arr];
        UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
        [currentWindow addSubview:timeView];
        
        @weakify(self)
        [timeView setSelectStationCellListener:^(id result){
            @strongify(self)
            self.timeModel = (StationOrderTime *)result;
            self.timeTF.text=[NSString stringWithFormat:@"%@-%@",self.timeModel.startTime,self.timeModel.endTime];
            
        }];
        
    }
    
    if ([tag isEqualToString:@"saveSubscribeTag"]) {
        SubscribeModel *sumodel = [SubscribeModel convertFromDict:(NSDictionary *)result];
        
        // 跳转到支付界面
        if ([payStatus isEqualToString:@"0"]) {
            //在线支付
            CarInspectOnlinePayViewController * controller = [[CarInspectOnlinePayViewController alloc]initWithStoryboard];
            controller.model = sumodel;
            [self basePushViewController:controller];
        }else{
            //线下支付
            PayResultViewController * controller  = [[PayResultViewController alloc]initWithStoryboard];
            controller.tag = ChannelPay_CarInspectSubscribe;
            controller.businessId = sumodel.businessid;
            [self basePushViewController:controller];
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [self hideHub];
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
}

-(void)textFieldTextChange:(UITextField*)textField
{
    
    if (textField.tag==3) {
        NSString *toBeString = textField.text;
        NSString *lang = [textField.textInputMode primaryLanguage];
        if ([lang isEqualToString:@"zh-Hans"])// 简体中文输入
        {
            //获取高亮部分
            UITextRange *selectedRange = [textField markedTextRange];
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position)
            {
                if (toBeString.length > 4)
                {
                    NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:4];
                    if (rangeIndex.length == 1)
                    {
                        self.nameTF.text = [toBeString substringToIndex:4];
                    }
                    else
                    {
                        NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 4)];
                        self.nameTF.text = [toBeString substringWithRange:rangeRange];
                    }
                }
            }
        }
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        else
        {
            if (toBeString.length > 4)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:4];
                if (rangeIndex.length == 1)
                {
                    self.nameTF.text = [toBeString substringToIndex:4];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 4)];
                    self.nameTF.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }
    if (textField.tag == 4) {
        NSString * str = (NSMutableString *)textField.text ;
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if (str.length>11) {
            str = [str substringWithRange:NSMakeRange(0, 11)];
        }
        self.phoneTF.text = str;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)getTimePort{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
