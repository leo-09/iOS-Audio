//
//  SubmitCarInfoViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "SubmitCarInfoViewController.h"
#import "CarInspectSubscribeViewController.h"
#import "CarInspectAgencyViewController.h"
#import "CarFreeInspectViewController.h"
#import "CTXWKWebViewController.h"
#import "CarInspectModel.h"
#import "ShowImageView.h"
#import "CalendarView.h"
#import "DialogView.h"
#import "MineNetData.h"

@implementation SubmitCarInfoViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"CarFreeInspect" bundle:nil] instantiateViewControllerWithIdentifier:@"SubmitCarInfoViewController"];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _carInspectNetData = [[CarInspectNetData alloc] init];
    _carInspectNetData.delegate = self;
    
    if ([self.fromViewController isEqualToString:NSStringFromClass([CarInspectSubscribeViewController class])]) {
        self.navigationItem.title = @"车检预约";
    } else if ([self.fromViewController isEqualToString:NSStringFromClass([CarInspectAgencyViewController class])]) {
        self.navigationItem.title = @"车检代办";
    } else {
        self.navigationItem.title = @"申请6年免检";
    }
    
    if ([self.fromViewController isEqualToString:NSStringFromClass([CarInspectSubscribeViewController class])] ||
        [self.fromViewController isEqualToString:NSStringFromClass([CarFreeInspectViewController class])]) {
        // 车检预约／6年免检
        
        // rightBarButtonItem
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"常见问题"
                                                                               style:UIBarButtonItemStyleDone
                                                                              target:self
                                                                              action:@selector(normalQuestion)];
        [rightBarButtonItem setTintColor:[UIColor whiteColor]];
        NSDictionary *dict = @{ NSFontAttributeName: [UIFont systemFontOfSize:CTXTextFont] };
        [rightBarButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
    
    // UI 公共的设计
    self.dateTextField.enabled = NO;
    CTXViewBorderRadius(self.bindLabel, 5.0, 0, [UIColor clearColor]);
    [self.plateNumberTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self.frameNumberTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [_agreeBtn setImage:[UIImage imageNamed:@"weigouxuan"] forState:UIControlStateNormal];
    [_agreeBtn setImage:[UIImage imageNamed:@"gouxuan"] forState:UIControlStateSelected];
    self.agreeBtn.selected = YES;
    
    // 输入的限制 (非中文，字母大写)
    self.plateNumberTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.frameNumberTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.plateNumberTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;//所有字母都大写;
    
    // 根据功能区分各个UI
    if ([self.fromViewController isEqualToString:NSStringFromClass([CarInspectSubscribeViewController class])]) {
        // 车检预约
        [self.understandProtocol setTitle:@"一分钟了解车检预约" forState:UIControlStateNormal];
    } else if ([self.fromViewController isEqualToString:NSStringFromClass([CarInspectAgencyViewController class])]) {
        // 车检代办
        [self.userProtocol setTitle:@"《申请车检代办须知》" forState:UIControlStateNormal];
    }
    
    // 选择过车辆择直接填充值
    if (self.model) {
        self.plateNumberTextField.text = [self.model.plateNumber substringFromIndex:1];
        self.frameNumberTextField.text = self.model.frameNumber;
    }
}

// 常见问题
- (void) normalQuestion {
    NSString *url = @"";
    if ([self.fromViewController isEqualToString:NSStringFromClass([CarInspectSubscribeViewController class])]) {
        // 车检预约
        url = @"http://www.ah122.cn/static/html/Cjyy-qa-M.html";
    } else if([self.fromViewController isEqualToString:NSStringFromClass([CarFreeInspectViewController class])]){
        // 6年免检
        url = @"http://www.ah122.cn/static/html/Lnmj-qa-M.html";
    }
    
    CTXWKWebViewController *controller = [[CTXWKWebViewController alloc] init];
    controller.name = @"常见问题";
    controller.desc = nil;
    controller.url = url;
    [self basePushViewController:controller];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 10;
    } else if ((indexPath.row == 1) || (indexPath.row == 2) || (indexPath.row == 3)) {
        return 60;
    } else if (indexPath.row == 4) {
        if ([self.fromViewController isEqualToString:NSStringFromClass([CarInspectSubscribeViewController class])]) {// 车检预约
            return 0;
        } else {
            return 60;
        }
    } else if (indexPath.row == 5) {
        return 10;
    } else if (indexPath.row == 6) {
        return 40;
    } else if (indexPath.row == 7) {
        if ([self.fromViewController isEqualToString:NSStringFromClass([CarInspectSubscribeViewController class])]) {// 车检预约
            return 0;
        } else {
            return 40;
        }
    } else if (indexPath.row == 8) {
        if ([self.fromViewController isEqualToString:NSStringFromClass([CarInspectAgencyViewController class])]) {// 车检代办
            return 0;
        } else {
            return 40;
        }
    } else {
        return 0;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {// 交强险终止日期
        CalendarView *calendarView = [[CalendarView alloc] init];
        [calendarView setSelectDateListener:^(id result) {
            self.dateTextField.text = (NSString *)result;
        }];
        [calendarView showView];
    } else if (indexPath.row == 6) {// 下一步
        [self nextStep];
        [self bindCar];
    }
}

#pragma mark - event response

- (IBAction)showPlateImage:(id)sender {
    // 隐藏键盘
    [self.plateNumberTextField resignFirstResponder];
    [self.frameNumberTextField resignFirstResponder];
    
    ShowImageView *showIV = [[ShowImageView alloc] init];
    [showIV showViewWithImagePath:@"xingshizheng"];
}

- (IBAction)agree:(id)sender {
    self.agreeBtn.selected = !self.agreeBtn.selected;
    
    if (self.agreeBtn.selected) {
        self.bindLabel.backgroundColor = UIColorFromRGB(CTXThemeColor);
    } else {
        self.bindLabel.backgroundColor = UIColorFromRGB(0x999999);
    }
}

// 6年免检 ／ 车检代办 须知
- (IBAction)userProtocol:(id)sender {
    if ([self.fromViewController isEqualToString:NSStringFromClass([CarFreeInspectViewController class])]) {
        // 六年免检
        CTXWKWebViewController *controller = [[CTXWKWebViewController alloc] init];
        controller.name = @"申请6年免检须知";
        controller.desc = nil;
        controller.url = @"http://csfw.ah122.cn/qrzfb/web/rest/toshenQingXuZhiToApp";
        [self basePushViewController:controller];
    } else if ([self.fromViewController isEqualToString:NSStringFromClass([CarInspectAgencyViewController class])]) {
        // 车检代办
        CTXWKWebViewController *controller = [[CTXWKWebViewController alloc] init];
        controller.name = @"车检代办须知";
        controller.desc = nil;
        controller.url = @"http://ah122.cn/zhuanti/cjdbxz/";
        [self basePushViewController:controller];
    }
}

// 一分钟了解 申请6年免检／车检预约
- (IBAction)understandProtocol:(id)sender {
    // 1分钟新手指南 的地址
    NSString *url = @"http://www.ah122.cn/static/html/Cjyy-1Minute-M.html";
    if ([self.fromViewController isEqualToString:@"CarInspectSubscribeViewController"]) {
        // 车检预约
        url = @"http://www.ah122.cn/static/html/Cjyy-1Minute-M.html";
    } else if ([self.fromViewController isEqualToString:@"CarFreeInspectViewController"]) {
        // 六年免检
        url = @"http://www.ah122.cn/static/html/Lnmj-1Minute-M.html";
    }
    
    CTXWKWebViewController *controller = [[CTXWKWebViewController alloc] init];
    controller.name = @"1分钟新手指南";
    controller.desc = nil;
    controller.url = url;
    [self basePushViewController:controller];
}

#pragma mark - 下一步

// 车检预约／六年免检／车检代办
- (void) nextStep {
    if ([self judge]) {
        [self checkModel];
        
        [self showHubWithLoadText:@"验证中..."];
        [self.carInspectNetData userApiNJWZCXWithPlateNumber:self.model.plateNumber
                                                 frameNumber:self.model.frameNumber
                                                     carType:self.model.plateType
                                                         tag:@"userApiNJWZCXTag"];
    }
}

// 进入下一页：车检预约／车检代办
- (void) nextPage {
    if ([self.fromViewController isEqualToString:NSStringFromClass([CarInspectSubscribeViewController class])]) {
        // 车检预约：不去看，则直接往下走
        [self toSubscribeViewController];
    } else {
        // 车检代办：不去看，则直接往下走
        [self toAgencyViewController];
    }
}

// 车检预约
- (void) toSubscribeViewController {
    CarInspectSubscribeViewController *controller = [[CarInspectSubscribeViewController alloc] init];
    controller.carModel = self.model;
    [self basePushViewController:controller];
}

// 车检代办
- (void) toAgencyViewController {
    CarInspectAgencyViewController *controller = [[CarInspectAgencyViewController alloc] init];
    controller.carModel = self.model;
    [self basePushViewController:controller];
}

// 申请6年免检
- (void) toFreeInspectViewController {
    CarFreeInspectViewController *controller = [[CarFreeInspectViewController alloc] initWithStoryboard];
    controller.model = self.model;
    controller.subscribeDate = self.dateTextField.text;
    [self basePushViewController:controller];
}

- (void) checkModel {
    // 添加‘添加车辆’过来的，没有BoundCarModel
    if (!self.model) {
        self.model = [[BoundCarModel alloc] init];
    }
    
    self.model.plateNumber = [NSString stringWithFormat:@"皖%@", self.plateNumberTextField.text];
    self.model.frameNumber = self.frameNumberTextField.text;
    self.model.plateType = Compact_Car_PlateType;
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    // 车牌号车架号年检信息查询
    if ([tag isEqualToString:@"userApiNJWZCXTag"]) {
        CarInspectModel *model = [CarInspectModel convertFromDict:(NSDictionary *)result];
        
        if (model.status == CarInspectStatus_noIllegal) {// 没有未处理的违章信息
            // 车牌号车架号免检信息查询
            NSString *plateNumber = self.model.plateNumber;
            NSString *frameNumber = self.model.frameNumber;
            
            NSString *date;
            if (![self.dateTextField.text isEqualToString:@"请选择交强险终止日期"]) {
                date = self.dateTextField.text;
            } else {
                date = nil;
            }
            
            [self.carInspectNetData userApiMJWZCXWithPlateNumber:plateNumber
                                                     frameNumber:frameNumber
                                                         carType:self.model.plateType
                                                            date:date
                                                             tag:@"userApiMJWZCXTag"];
        } else {
            [self hideHub];
            [self showTextHubWithContent:model.info];
        }
    }
    
    // 车牌号车架号免检信息查询
    if ([tag isEqualToString:@"userApiMJWZCXTag"]) {
        [self hideHub];
        CarInspectModel *model = [CarInspectModel convertFromDict:(NSDictionary *)result];
        [self userApiMJWZCXWithModel:model];
    }
    
    // 绑定车辆
    if ([tag isEqualToString:@"bindCarTag"]) {
        // 发出 ‘删除、绑定、编辑车辆’通知
        [[NSNotificationCenter defaultCenter] postNotificationName:BindOrDeleteCarNotificationName object:nil userInfo:nil];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    
    // 绑定车辆 不做提示
    if (![tag isEqualToString:@"bindCarTag"]) {
        [self hideHub];
        [self showTextHubWithContent:tint];
    }
}

#pragma mark - 下一步的统一处理

// 车牌号车架号免检信息查询
- (void) userApiMJWZCXWithModel:(CarInspectModel *)model {
    if (model.status == CarInspectStatus_conformity) {// 符合申请6年免检
        if ([self.fromViewController isEqualToString:NSStringFromClass([CarFreeInspectViewController class])]) {
            // 六年免检
            [self toFreeInspectViewController];
        } else {
            // 车检预约、车检代办需要提示用户选择
            [self dialogViewWithConformCarFreeInspect:YES];
        }
    } else if (model.status == CarInspectStatus_mayConformity) {// 可能符合申请6年免检
        if ([self.fromViewController isEqualToString:NSStringFromClass([CarFreeInspectViewController class])]) {
            // 六年免检
            [self toFreeInspectViewController];
        } else {
            // 车检预约、车检代办需要提示用户选择
            [self dialogViewWithConformCarFreeInspect:NO];
        }
    } else {
        if ([self.fromViewController isEqualToString:NSStringFromClass([CarFreeInspectViewController class])]) {
            // 不符合申请6年免检条件
            if ([model nonConformityCarFreeInspect]) {
                DialogView *dialogView = [[DialogView alloc] init];
                [dialogView setTitle:[NSString stringWithFormat:@"%@，推荐您去车检代办", model.info] topBtnTitle:@"去看看" bottomBtnTitle:@"不去"];
                [dialogView setTopBtnListener:^{
                    // 推荐去车检代办
                    SubmitCarInfoViewController *controller = [[SubmitCarInfoViewController alloc] initWithStoryboard];
                    controller.fromViewController = NSStringFromClass([CarInspectAgencyViewController class]);
                    controller.model = self.model;
                    [self basePushViewController:controller];
                }];
                [dialogView setBottomBtnListener:^{
                    // 不符合申请6年免检条件，不去，则不进行下一步,没有操作
                }];
                [dialogView showView];
            } else {
                [self showTextHubWithContent:model.info];
            }
        } else {
            [self nextPage];
        }
    }
}

- (void) dialogViewWithConformCarFreeInspect:(BOOL)isConform {
    NSString *desc;
    
    if (isConform) {
        desc = @"您的车辆符合申请6年免检条件，推荐您去申请";
    } else {
        desc = @"您的车辆可能符合申请6年免检条件，推荐您去申请";
    }
    
    // 对话框
    DialogView *dialogView = [[DialogView alloc] init];
    [dialogView setTitle:desc topBtnTitle:@"去看看" bottomBtnTitle:@"不去"];
    [dialogView setTopBtnListener:^{
        // 推荐去申请申请6年免检
        SubmitCarInfoViewController *controller = [[SubmitCarInfoViewController alloc] initWithStoryboard];
        controller.fromViewController = NSStringFromClass([CarFreeInspectViewController class]);
        controller.model = self.model;
        [self basePushViewController:controller];
    }];
    [dialogView setBottomBtnListener:^{
        [self nextPage];
        
//        // 可能符合6年免检条件，可以往下走；符合6年免检条件，则不允许往下走
//        if (!isConform) {
//            [self nextPage];
//        }
    }];
    [dialogView showView];
}

#pragma mark - private method

- (void) textChange:(UITextField *)textField {
    NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    text = text.uppercaseString;// 保证车牌号字母大写
    
    if (text.length > 6) {
        text = [text substringToIndex:6].uppercaseString;// 保证车牌号字母大写
    }
    
    if (textField == self.plateNumberTextField) {
        self.plateNumberTextField.text = text;
    }
    
    if (textField == self.frameNumberTextField) {
        self.frameNumberTextField.text = text;
    }
}

- (BOOL) judge {
    if ([self.plateNumberTextField.text isEqualToString:@""]) {
        [self showTextHubWithContent:@"请输入车牌号信息"];
        return NO;
    }
    
    if ([self.frameNumberTextField.text isEqualToString:@""]) {
        [self showTextHubWithContent:@"请输入车架号后6位"];
        return NO;
    }
    
    // 车检预约没有“交强险终止日期”
    if (![self.fromViewController isEqualToString:NSStringFromClass([CarInspectSubscribeViewController class])]) {
        if ([self.dateTextField.text isEqualToString:@"请选择交强险终止日期"]) {
            [self showTextHubWithContent:@"请选择交强险终止日期"];
            return NO;
        }
    }
    
    if ([self.fromViewController isEqualToString:NSStringFromClass([CarInspectAgencyViewController class])]) {
        if (!self.agreeBtn.isSelected) {
            [self showTextHubWithContent:@"请阅读并同意申请车检代办须知"];
            return NO;
        }
    }
    
    if ([self.fromViewController isEqualToString:NSStringFromClass([CarFreeInspectViewController class])]) {
        if (!self.agreeBtn.isSelected) {
            [self showTextHubWithContent:@"请阅读并同意申请6年免检须知"];
            return NO;
        }
    }
    
    return YES;
}

// 绑定车辆
- (void) bindCar {
    BoundCarModel *model = [[BoundCarModel alloc] init];
    model.plateNumber = self.model.plateNumber;
    model.frameNumber = self.model.frameNumber;
    model.plateType = Compact_Car_PlateType;
    model.inspectionReminder = @"1";// 暂时用不上过，传1
    
    MineNetData *mineNetData = [[MineNetData alloc] init];
    mineNetData.delegate = self;
    [mineNetData bindCarWithToken:self.loginModel.token boundCarModel:model tag:@"bindCarTag"];
}

@end
