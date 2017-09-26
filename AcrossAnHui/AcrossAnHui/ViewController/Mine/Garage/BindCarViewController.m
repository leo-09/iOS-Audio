//
//  BindCarViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/28.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "BindCarViewController.h"
#import "SelectCarTypeViewController.h"
#import "CarTypeModel.h"
#import "OneListSelectorView.h"
#import "CTXWebViewController.h"
#import "ShowImageView.h"
#import "MineNetData.h"

// 限制最大输入字符数
#define MAX_LIMIT_NUMS 6

@interface BindCarViewController ()

@property (nonatomic, retain) MineNetData *mineNetData;

@property (nonatomic, retain) CBModel *carTypeModel;
@property (nonatomic, retain) OneListSelectorModel *plateTypeModel;

@end

@implementation BindCarViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"Garage" bundle:nil] instantiateViewControllerWithIdentifier:@"BindCarViewController"];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setPlateType];
    
    self.navigationItem.title = self.naviTitle;
    
    if ([self.naviTitle isEqualToString:@"编辑车辆"]) {
        // 编辑车辆时，不可修改车牌号、车架号、号牌类型
        self.plateNumberTextField.enabled = NO;
        self.frameNumberTextField.enabled = NO;
        self.frameNumberBtn.hidden = YES;
        self.plateTypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.plateNumberTextField.textColor = UIColorFromRGB(CTXTextGrayColor);
        self.frameNumberTextField.textColor = UIColorFromRGB(CTXTextGrayColor);
        self.plateTypeLabel.textColor = UIColorFromRGB(CTXTextGrayColor);
        
        // 填充车辆信息
        self.plateNumberTextField.text = [self.carModel.plateNumber substringFromIndex:1];
        self.frameNumberTextField.text = self.carModel.frameNumber;
        self.plateTypeLabel.text = [self plateTypeName:self.carModel.plateType];
        self.carTypeLabel.text = self.carModel.name;
        self.textView.text = self.carModel.note;
        if ([self.textView.text isEqualToString:@""]) {
            self.tintLabel.hidden = NO;
        } else {
            self.tintLabel.hidden = YES;
        }
        
        // rightBarButtonItem
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"delete_changeCar"] style:UIBarButtonItemStyleDone target:self action:@selector(deleteBindedCar)];
        [rightBarButtonItem setTintColor:[UIColor whiteColor]];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
    
    // view设置
    [self.plateNumberTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self.frameNumberTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    self.textView.delegate = self;
    [_agreeBtn setImage:[UIImage imageNamed:@"weigouxuan"] forState:UIControlStateNormal];
    [_agreeBtn setImage:[UIImage imageNamed:@"gouxuan"] forState:UIControlStateSelected];
    self.agreeBtn.selected = YES;
    CTXViewBorderRadius(self.bindLabel, 5.0, 0, [UIColor clearColor]);
    
    // 输入的限制 (非中文，字母大写)
    self.plateNumberTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.frameNumberTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.plateNumberTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;//所有字母都大写;
    
    self.mineNetData = [[MineNetData alloc] init];
    self.mineNetData.delegate = self;
    
    // 选择车辆类型的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSelectCarType:) name:SelectCarTypeNotificationName object:nil];
}

- (void) setSelectCarType:(NSNotification *)noti {
    CBModel *carBrandModel = (CBModel *) noti.userInfo[@"carBrandModel"];   // 车品牌
    self.carTypeModel = (CBModel *) noti.userInfo[@"carTypeModel"];         // 车系
    
    NSString *name = [NSString stringWithFormat:@"%@ %@", carBrandModel.name, self.carTypeModel.name];
    self.carTypeLabel.text = name;
    
    if (self.carModel) {
        self.carModel.name = name;
    }
}

// 删除绑定的车辆
- (void) deleteBindedCar {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"确认删除该车辆吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showHubWithLoadText:@"正在删除该车辆"];
        
        // 删除车库的车
        [self.mineNetData unbindCarWithToken:self.loginModel.token carID:self.carModel.carID tag:@"unbindCarTag"];
        
        // 删除停车服务的车
        [self.mineNetData deleteCarParkServiceWithToken:self.loginModel.token
                                            plateNumber:self.carModel.plateNumber
                                                    tag:@"deleteCarParkServiceTag"];
    }];
    [controller addAction:cancelAction];
    [controller addAction:okAction];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) setPlateType {
    plateTypes = @[ @"大型汽车", @"小型汽车", @"使馆汽车", @"领馆汽车",
                             @"境外汽车", @"外籍汽车", @"普通摩托车", @"轻便摩托车",
                             @"使馆摩托车", @"领馆摩托车", @"境外摩托车", @"外籍摩托车",
                             @"农用运输车", @"拖拉机", @"挂车", @"教练汽车", @"教练摩托车",
                             @"试验汽车", @"试验摩托车", @"临时入境汽车", @"临时入境摩托车",
                             @"临时行驶车", @"警用汽车", @"警用摩托", @"武警汽车", @"军车"];
    plateTypeIDs = @[ @"01", Compact_Car_PlateType, @"03", @"04", @"05", @"06", @"07", @"08",
                      @"09", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18",
                      @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26"];
}

// 获取号牌类型的名字
- (NSString *) plateTypeName:(NSString *)plateTypeID {
    for (int i = 0; i < plateTypeIDs.count; i++) {
        if ([plateTypeID isEqualToString:plateTypeIDs[i]]) {
            return plateTypes[i];
        }
    }
    
    return @"";
}

#pragma mark - event response

- (IBAction)showPlateImage:(id)sender {
    // 隐藏键盘
    [self.plateNumberTextField resignFirstResponder];
    [self.frameNumberTextField resignFirstResponder];
    [self.textView resignFirstResponder];
    
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

- (IBAction)userProtocol:(id)sender {
    // 用户协议
    CTXWebViewController *controller = [[CTXWebViewController alloc] init];
    controller.naviTitle = @"用户协议";
    controller.address = @"userProtocol";
    [self basePushViewController:controller];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 3) {// 号牌类型
        if ([self.naviTitle isEqualToString:@"绑定车辆"]) {
            [self addSelectPlateTypeView];
        }
    } else if (indexPath.row == 4) {// 车型
        SelectCarTypeViewController *controller = [[SelectCarTypeViewController alloc] init];
        [self basePushViewController:controller];
    } else if (indexPath.row == 8) {// 立即绑定
        // 必须同意用户协议
        if (self.agreeBtn.selected) {
            if ([self.naviTitle isEqualToString:@"绑定车辆"]) {
                [self bindCar];
            } else {
                [self editCar];
            }
        }
    }
}

// 绑定车辆
- (void) bindCar {
    if ([self.plateNumberTextField.text isEqualToString:@""]) {
        [self showTextHubWithContent:@"请输入车牌号"];
        return;
    }
    
    if ([self.frameNumberTextField.text isEqualToString:@""]) {
        [self showTextHubWithContent:@"请输入车架号"];
        return;
    }
    
    if (!self.plateTypeModel) {
        self.plateTypeModel = [[OneListSelectorModel alloc] init];
        self.plateTypeModel.modelID = Compact_Car_PlateType;// 默认是小型车
    }
    
    BoundCarModel *model = [[BoundCarModel alloc] init];
    model.plateNumber = [NSString stringWithFormat:@"皖%@", self.plateNumberTextField.text];
    model.frameNumber = self.frameNumberTextField.text;
    model.plateType = self.plateTypeModel.modelID;
    model.inspectionReminder = @"1";// 暂时用不上过，传1
    if (self.carTypeModel) {
        model.carType = self.carTypeModel.CBID;
    }
    model.note = self.textView.text;
    
    [self showHubWithLoadText:@"正在绑定车辆"];
    [self.mineNetData bindCarWithToken:self.loginModel.token boundCarModel:model tag:@"bindCarTag"];
}

// 编辑车辆
- (void) editCar {
    self.carModel.note = self.textView.text;
    
    // 重新选择车型，再赋值
    if (self.carTypeModel) {
        self.carModel.carType = self.carTypeModel.CBID;
    }
    
    [self showHubWithLoadText:@"正在编辑车辆"];
    [self.mineNetData bindCarWithToken:self.loginModel.token boundCarModel:self.carModel tag:@"editCarTag"];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"unbindCarTag"] || [tag isEqualToString:@"deleteCarParkServiceTag"]) {
        [self showTextHubWithContent:@"车辆删除完成"];
    }
    
    if ([tag isEqualToString:@"bindCarTag"]) {
        [self showTextHubWithContent:@"绑定车辆完成"];
    }
    
    NSDictionary *userInfo;
    if ([tag isEqualToString:@"editCarTag"]) {
        [self showTextHubWithContent:@"编辑车辆完成"];
        
        // 由违章查询的‘编辑此车’进来，处理成功后，违章查询只需要接收备注信息即可
        userInfo = @{ @"note" : self.carModel.note,
                      @"name" : self.carModel.name,
                      @"carType" : self.carModel.carType};
    }
    
    // 发出 ‘删除、绑定、编辑车辆’通知
    [[NSNotificationCenter defaultCenter] postNotificationName:BindOrDeleteCarNotificationName object:nil userInfo:userInfo];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self hideHub];
    
    if (![tag isEqualToString:@"deleteCarParkServiceTag"]) {
        [self showTextHubWithContent:tint];
    }
}

#pragma mark - private method

- (void) addSelectPlateTypeView {
    OneListSelectorView *selectorView = [[OneListSelectorView alloc] init];
    selectorView.isMultiSelect = NO;
    selectorView.title = @"选择号牌类型";
    selectorView.btnTitle = @"取消";
    
    // 具体选项
    NSMutableArray *dataSource = [[NSMutableArray alloc] init];
    for (int i = 0; i < plateTypes.count; i++) {
        OneListSelectorModel *model = [[OneListSelectorModel alloc] init];
        model.modelID = plateTypeIDs[i];
        model.name = plateTypes[i];
        model.isSelected = NO;
        model.isMultiSelect = NO;
        [dataSource addObject:model];
    }
    
    selectorView.dataSource = dataSource;
    
    [selectorView setSelectorResultListener:^(id result) {
        self.plateTypeModel = (OneListSelectorModel *)result;
        self.plateTypeLabel.text = self.plateTypeModel.name;
    }];
    [selectorView showView];
}

- (void) textChange:(UITextField *)textField {
    NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    text = text.uppercaseString;// 保证车牌号、车架号字母大写
    
    if (text.length > 6) {
        text = [text substringToIndex:6];
    }
    
    if (textField == self.plateNumberTextField) {
        self.plateNumberTextField.text = text;
    }
    
    if (textField == self.frameNumberTextField) {
        self.frameNumberTextField.text = text;
    }
}

#pragma mark - UITextViewDelegate

// 有输入时触但对于中文键盘出示的联想字选择时不会触发
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [textView resignFirstResponder];
    }
    
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0]; //获取高亮部分
    //NSString * selectedtext = [textView textInRange:selectedRange];//获取高亮部分内容
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        } else {
            return NO;
        }
    }
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0) {
        return YES;
    } else {
        NSInteger len = text.length + caninputlen;
        // 防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0) {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        
        return NO;
    }
    
}

// 当输入且上面的代码返回YES时触发。或当选择键盘上的联想字时触发
- (void)textViewDidChange:(UITextView *)textView {
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];//获取高亮部分
    
    // 如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        self.tintLabel.hidden = YES;
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS) {
        //截取到最大位置的字符
        NSString *content = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:content];
    }
    
    if (existTextNum > 0) {
        self.tintLabel.hidden = YES;
    } else {
        self.tintLabel.hidden = NO;
    }
}

@end
