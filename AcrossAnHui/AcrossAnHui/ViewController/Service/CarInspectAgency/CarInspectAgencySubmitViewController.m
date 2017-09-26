//
//  CarInspectAgencySubmitViewController.m
//  AcrossAnHui
//
//  Created by ztd on 2017/8/2.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectAgencySubmitViewController.h"
#import "CTX-Prefix.pch"
#import "Masonry.h"
#import "UILabel+lineSpace.h"
#import "DBDateView.h"
#import "DBPromotionView.h"
#import "NetURLManager.h"
#import "DES3Util.h"
#import "CarInspectAgencyOrderModel.h"
#import "CarInspectNetData.h"
#import "CarInspectAgencyOnlinePayViewController.h"
#import "CarInspectAgencyDetailViewController.h"

@interface CarInspectAgencySubmitViewController ()<UITextFieldDelegate>{
    DBPromotionView * promotionView ;
    NSArray * timeArr;
    UILabel * waitPriceLab;//待支付价格
    UILabel * favourablePriceLab ;//已优惠
    UIView * foodview;
    UILabel * waitPayLab;
    UILabel * favourableLab;
    UIButton * submitBut;
    NSString * goodStr;//优惠码价格
    NSString * couponcodeid;
    BOOL isEffective;
}

@property(nonatomic,retain)CarInspectNetData * carInspectData;

@end

@implementation CarInspectAgencySubmitViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"Serve" bundle:nil] instantiateViewControllerWithIdentifier:@"DBSubmitOrderViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _carInspectData = [[CarInspectNetData alloc]init];
    _carInspectData.delegate = self;
    
    isEffective = YES;
    couponcodeid = @"";
    timeArr = [NSArray array];
    [_carInspectData queryCarInspectagencyStationAppintionTimeWithStationID:self.stationModel.stationid tag:@"time"];
    self.title = @"提交订单";
    
    _dateTextField.userInteractionEnabled = NO;
    _addressLab.text = self.addressStr;
    _addressLab.textColor  = UIColorFromRGB(CTXTextGrayColor);
    [_addressLab   getLabelHeightWithLineSpace:3 WithWidth:CTXScreenWidth-150 WithNumline:0];
    _plateLab.text = [self.carModel.plateNumber substringFromIndex:1];
    _plateLab.textColor = UIColorFromRGB(CTXTextGrayColor);
    if (self.loginModel.phone) {
        self.phoneTF.text = self.loginModel.phone;
    }
    
    _phoneTF.delegate = self;
    _nameTF.delegate = self;
    _goodTF.delegate = self;
    
    // 输入的限制 (非中文，字母大写)
    self.goodTF.keyboardType = UIKeyboardTypeASCIICapable;
    self.goodTF.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;//所有字母都大写;
    
    [_phoneTF addTarget:self action:@selector(ChangeTextField:) forControlEvents:UIControlEventEditingChanged];
    [_nameTF addTarget:self action:@selector(ChangeTextField:) forControlEvents:UIControlEventEditingChanged];
    [_goodTF addTarget:self action:@selector(ChangeTextField:) forControlEvents:UIControlEventEditingChanged];
    
    [self createFoodView];
}

#pragma 创建区尾

-(void)createFoodView {
    if (foodview == nil) {
        foodview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CTXScreenWidth, 200)];
        self.tableView.tableFooterView = foodview;
    }
    
    if (waitPayLab==nil) {
        waitPayLab = [[UILabel alloc]init];
        [foodview addSubview:waitPayLab];
        waitPriceLab = [[UILabel alloc]init];
        [foodview addSubview:waitPriceLab];
    }
    waitPayLab.frame = CGRectMake(12.5, 20, 55, 15);
    waitPayLab.text = @"待支付:";
    waitPayLab.font = [UIFont systemFontOfSize:15];
    waitPriceLab.frame = CGRectMake(12.5+55+2, 20, 150, 15);
    waitPriceLab.font = [UIFont systemFontOfSize:15];
    waitPriceLab.textColor  = UIColorFromRGB(0xfe6e00);
    if (favourableLab==nil) {
        favourableLab = [[UILabel alloc]init];
        [foodview addSubview:favourableLab];
        favourablePriceLab = [[UILabel alloc]init];
        [foodview addSubview:favourablePriceLab];
    }
    favourableLab.text = @"已优惠:";
    favourableLab.font = [UIFont systemFontOfSize:15];
    if (submitBut == nil) {
        submitBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [foodview addSubview:submitBut];
        
    }
    submitBut.layer.cornerRadius = 5;
    submitBut.layer.masksToBounds = true;
    submitBut.backgroundColor = UIColorFromRGB(CTXThemeColor);
    [submitBut setTitle:@"立即提交" forState:UIControlStateNormal];
    submitBut.titleLabel.font = [UIFont systemFontOfSize:15];
    [submitBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBut addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    
    if ([_stationModel.personyh isEqualToString:@"0.00"]&&goodStr.length<1) {
        favourableLab.frame = CGRectMake(12.5, 50, 0, 0);
        favourablePriceLab.frame =  CGRectMake(12.5+55+2, 50, 0, 0);
        submitBut.frame = CGRectMake(12.5, 50+5, CTXScreenWidth-25, 40);
    }else{
        favourableLab.frame = CGRectMake(12.5, 50, 55, 15);
        favourablePriceLab.frame =  CGRectMake(12.5+55+2, 50, 100, 15);
        
        favourablePriceLab.text = [NSString stringWithFormat:@"￥%0.2f元",_stationModel.personyh.floatValue];
        favourablePriceLab.font = [UIFont systemFontOfSize:15];
        [foodview addSubview:favourablePriceLab];
        favourablePriceLab.textColor  = UIColorFromRGB(0xfe6e00);
        submitBut.frame = CGRectMake(12.5, 85, CTXScreenWidth-25, 40);
    }
    CGFloat price = _stationModel.totalFee.floatValue ;
    waitPriceLab.text = [NSString stringWithFormat:@"￥%0.2f元",price];
}

#pragma 提交的点击事件

-(void)submitClick {
    if (_dateTextField.text.length < 1) {
        [self showTextHubWithContent:@"请预约取车时间"];
        return;
    } else if (_nameTF.text.length < 1){
        [self showTextHubWithContent:@"请填写联系人姓名"];
        return;
    } else if (![DES3Util isMobileNumber:_phoneTF.text]){
        [self showTextHubWithContent:@"请填写正确的手机号"];
        return;
    } else if(_goodTF.text.length > 0 && _goodTF.text.length < 8){
        [self showTextHubWithContent:@"请填写正确的优惠码"];
        return;
    } else if (_goodTF.text.length > 0 && !isEffective){
        [self showTextHubWithContent:@"请填写正确的优惠码"];
        return;
    } else if (_goodTF.text.length <= 0){
        couponcodeid = @"";
    }
    
    [self getOrderRecode];
}

#pragma mark 生成订单

-(void)getOrderRecode {
    NSString * dateTime = [NSString stringWithFormat:@"%@:00",self.dateTextField.text];
    NSString * lat = [NSString stringWithFormat:@"%f", self.latStr];
    NSString * lng = [NSString stringWithFormat:@"%f", self.lngStr];
    
    SaveSubscribeModel *model = [[SaveSubscribeModel alloc] init];
    [model setCarLisence:self.carModel.plateNumber];
    [model setLastFrame:self.carModel.frameNumber];
    [model setLat:lat];
    [model setLng:lng];
    [model setHlat:lat];
    [model setHlng:lng];
    [model setDetailAddr:self.addressLab.text];
    [model setSjDetailAdd:self.addressLab.text];
    [model setContactPerson:self.nameTF.text];
    [model setContactPhone:self.phoneTF.text];
    [model setCarType:self.carModel.plateType];
    [model setSubscribeDate:dateTime];
    [model setStationid:self.stationModel.stationid];
    [model setAvator:self.loginModel.photo];
    [model setPaymethod:@"1"];
    [model setBusinessType:@"3"];
    [model setCouponcodeid:couponcodeid];
    
    [self showHubWithLoadText:@"保存预约记录中..."];
    [_carInspectData saveSubscribeWithToken:self.loginModel.token subscribeMode:model cityName:nil tag:@"saveSubscribeTag"];
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        UILabel * lab  = [[UILabel alloc]init];
        lab.font = [UIFont systemFontOfSize:15];
        lab.numberOfLines = 0;
        lab.text = self.addressStr;
        CGSize sixe = [lab getLabelHeightWithLineSpace:3 WithWidth:CTXScreenWidth - 132 WithNumline:3];
        
        return 40 + sixe.height ;
    } else {
        return 55;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UIWindow * windoow = [UIApplication sharedApplication].keyWindow;
        DBDateView * dateView = [[DBDateView alloc]initWithFrame:CGRectMake(0, 0, CTXScreenWidth, CTXScreenHeight)];
        
        if (timeArr.count < 1) {
            [self showTextHubWithContent:@"暂无可预约的时间"];
            return;
        }
        
        dateView.dateDic = timeArr;
        [windoow addSubview:dateView];
        dateView.blcok = ^(NSString *dateString) {
            _dateTextField.text = dateString;
        };
        dateView.chooseTimeLabel.text = @"选择时间";
        [dateView fadeIn];
    }
}

#pragma mark - event response

// 优惠码使用提示
- (IBAction)toast:(id)sender {
    UIWindow * windoow = [UIApplication sharedApplication].keyWindow;
    promotionView = [[DBPromotionView alloc]initWithFrame:CGRectMake(0, 0, CTXScreenWidth, CTXScreenHeight) note:@"若司机在预约时间内到达,取消订单则使用的优惠码不予退回" title:@"注意事项"];
    [windoow addSubview:promotionView];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"time"]) {
        // 处理数据结果
        NSArray * arr = (NSArray *)result;
        if (arr.count>0) {
            timeArr = arr;
        }
    }
    
    if ([tag isEqualToString:@"isCouponCodeTag"]) {
        NSDictionary *dict = (NSDictionary *)result;
        
        goodStr = dict[@"sportsyh"];
        couponcodeid = [dict[@"id"] stringValue];
        CGFloat price = _stationModel.totalFee.floatValue-goodStr.floatValue;
        CGFloat goodPirce = _stationModel.personyh.floatValue+goodStr.floatValue;
        isEffective = YES;
        
        //改变布局
        [self createFoodView];
        waitPriceLab.text = [NSString stringWithFormat:@"￥%0.2f元",price];
        favourablePriceLab.text = [NSString stringWithFormat:@"￥%0.2f元",goodPirce];
    }
    
    if ([tag isEqualToString:@"saveSubscribeTag"]) {
        // 跳转到支付界面
        CarInspectAgencyOrderModel * orderModel = [CarInspectAgencyOrderModel convertFromDict:(NSDictionary *)result];
        
        if (orderModel.payfee <= 0) {
            CarInspectAgencyDetailViewController * controller = [[CarInspectAgencyDetailViewController alloc]init];
            controller.businessid = orderModel.businessid;
            controller.isFromDBOnlinePayViewController = YES;
            [self basePushViewController:controller];
        } else {
            CarInspectAgencyOnlinePayViewController * controller = [[CarInspectAgencyOnlinePayViewController alloc]init];
            controller.orderModel = orderModel;
            [self basePushViewController:controller];
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [self hideHub];
    [super queryFailureWithTag:tag tint:tint];
    
    if ([tag isEqualToString:@"isCouponCodeTag"]) {
        isEffective = NO;
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return  YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)ChangeTextField:(UITextField *)textField {
    if (textField == _phoneTF) {
        // 手机号 限制输入11位
        NSString * str = (NSMutableString *)textField.text ;
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if (str.length > 11) {
            str = [str substringWithRange:NSMakeRange(0, 11)];
        }
        
        self.phoneTF.text = str;
    } else if (textField == _nameTF) {
        NSString *toBeString = textField.text;
        NSString *lang = [textField.textInputMode primaryLanguage];
        if ([lang isEqualToString:@"zh-Hans"]) {// 简体中文输入
            //获取高亮部分
            UITextRange *selectedRange = [textField markedTextRange];
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (toBeString.length > 4) {
                    NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:4];
                    if (rangeIndex.length == 1) {
                        _nameTF.text = [toBeString substringToIndex:4];
                    } else {
                        NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 4)];
                        _nameTF.text = [toBeString substringWithRange:rangeRange];
                    }
                }
            }
        } else {
            // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            if (toBeString.length > 4) {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:4];
                if (rangeIndex.length == 1) {
                    _nameTF.text = [toBeString substringToIndex:4];
                } else {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 4)];
                    _nameTF.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    } else if (textField == _goodTF) {
        if (textField.text.length == 8) {
            NSRange rangeIndex = [textField.text rangeOfComposedCharacterSequenceAtIndex:7];
            if (rangeIndex.length == 1) {
                _goodTF.text = [textField.text substringToIndex:8];
            } else {
                NSRange rangeRange = [textField.text rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 8)];
                _goodTF.text = [textField.text substringWithRange:rangeRange];
            }
            
            // 监听  当输入到8位数时获取优惠码价格
            [_carInspectData isCouponCodeWithCouponCode:_goodTF.text tag:@"isCouponCodeTag"];
        } else {
            goodStr = @"";
            couponcodeid = @"";
            CGFloat price = _stationModel.totalFee.floatValue;
            isEffective = YES;
            //改变布局
            [self createFoodView];
            waitPriceLab.text = [NSString stringWithFormat:@"￥%0.2f元",price];
            favourablePriceLab.text = nil;
        }
    }
}

@end
