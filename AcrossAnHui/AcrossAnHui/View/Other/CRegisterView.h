//
//  CRegisterView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/21.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"

typedef void (^RegisterListener)(NSString *phone, NSString *code, NSString *psw);

@interface CRegisterView : CTXBaseView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswTextField1;
@property (weak, nonatomic) IBOutlet UITextField *pswTextField2;

@property (weak, nonatomic) IBOutlet UIView *protocolView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerBtnMarginTop;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *gainCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic, strong) ClickListener backListener;
@property (nonatomic, strong) ClickListener loginListener;
@property (nonatomic, strong) ClickListener showProtocolListener;
@property (nonatomic, strong) SelectCellModelListener gainCodeListener;
@property (nonatomic, strong) RegisterListener registerListener;

- (instancetype) initWithMyFrame:(CGRect)frame isRegister:(BOOL)isRegister;
- (void) updateGainCodeBtnWithTitle:(NSString *)title backgroundColor:(UIColor *)color isEnabled:(BOOL)enabled;

@end
