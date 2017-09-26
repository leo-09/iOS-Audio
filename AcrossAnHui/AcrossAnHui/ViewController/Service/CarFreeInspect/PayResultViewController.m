//
//  PayResultViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "PayResultViewController.h"
#import "CarFreeInspectRecordViewController.h"
#import "CarSubscribeRecordViewController.h"
#import "CarInspectNetData.h"
#import "UILabel+lineSpace.h"
#import "SubscribeModel.h"

@interface PayResultViewController ()

@property (nonatomic, assign) CGFloat descCellHeight;

@property (nonatomic, retain) CarInspectNetData *carInspectNetData;

@end

@implementation PayResultViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"CarFreeInspect" bundle:nil] instantiateViewControllerWithIdentifier:@"PayResultViewController"];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDescCell];
    CTXViewBorderRadius(_payLabel, 5.0, 0, [UIColor clearColor]);
    
    _carInspectNetData = [[CarInspectNetData alloc] init];
    _carInspectNetData.delegate = self;
    
    [_carInspectNetData orderDetailWithBusinessID:self.businessId tag:@"orderDetailTag"];
}

- (void) setDescCell {
    NSString *desc;
    if (self.tag == ChannelPay_CarInspectSubscribe) {
        desc = @"已成功预约订单，请按时到车检站享受绿色通道免排队车检服务。";
        self.navigationItem.title = @"预约成功";
    } else if (self.tag == ChannelPay_CarInspectSubscribePay) {
        desc = @"已成功支付订单，请按时到车检站享受绿色通道免排队车检服务。";
        self.navigationItem.title = @"支付成功";
    } else {
        desc = @"已成功申请6年免检，请准备好您的机动车行驶证原件、交强险（有效期内）留存联原件，等待快递人员上门收取材料，收件人请填写【畅行安徽】，收件人联系电话请填写【0551-65315641】，并选择【到付】。如快递人员长时间未联系上门取件，请拨打客服电话：055165315641。";
        self.navigationItem.title = @"申请成功";
    }
    
    self.descLabel.text = desc;
    
    CGFloat descHeight = [self.descLabel getLabelHeightWithLineSpace:5.0 WithWidth:(CTXScreenWidth-24) WithNumline:0].height;
    self.descCellHeight = 15 + 42 + 15 + descHeight + 15;
    
    // 更新tableView高度
    [self.tableView reloadData];
}

- (void) close:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL) gestureRecognizerShouldBegin {
    return NO;
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"orderDetailTag"]) {
        SubscribeModel *model = [SubscribeModel convertFromDict:(NSDictionary *)result];
        
        NSURL *url = [NSURL URLWithString:model.stationPic];
        [self.imageView setImageWithURL:url placeholder:[UIImage imageNamed:@"zet-1"]];
        self.stationNameLabel.text = model.stationName;
        self.stationAddressLabel.text = model.stationAddr;
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.descCellHeight;
    } else if (indexPath.row == 1) {
        return 115;
    } else if (indexPath.row == 3) {
        return 40;
    } else if (indexPath.row == 2 || indexPath.row == 4) {
        return 15;
    } else {
        return 0;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {// 完成
        if (self.tag == ChannelPay_CarFreeInspect) { // 6年免检支付成功
            CarFreeInspectRecordViewController *controller = [[CarFreeInspectRecordViewController alloc] init];
            controller.isFromPayResultViewController = YES;
            [self basePushViewController:controller];
        } else {        // 车检预约成功
            CarSubscribeRecordViewController *controller = [[CarSubscribeRecordViewController alloc] init];
            controller.isFromPayResultViewController = YES;
            [self basePushViewController:controller];
        }
    }
}

@end
